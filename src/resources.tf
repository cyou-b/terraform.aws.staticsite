# --------------------------------------------------------------
# Amazon Certificate Manager
# --------------------------------------------------------------

resource "aws_acm_certificate" "cert" {
  count             = var.domain_enabled ? 1 : 0
  domain_name       = var.domain
  validation_method = "DNS"

  tags = local.project_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert" {
  count                   = var.domain_enabled ? 1 : 0
  certificate_arn         = aws_acm_certificate.cert[0].arn
  validation_record_fqdns = [for record in aws_route53_record.www : record.fqdn]
}


# --------------------------------------------------------------
# Cloudfront
# --------------------------------------------------------------

resource "aws_cloudfront_distribution" "s3_distribution" {
  count = var.domain_enabled ? 1 : 0

  origin {
    domain_name = aws_s3_bucket.s3_bucket[0].bucket_regional_domain_name
    origin_id   = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_s3_oac[0].id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"
  web_acl_id          = aws_wafv2_web_acl.waf.arn

  # If there is a 404, return index.html with a HTTP 200 Response
  custom_error_response {
    error_caching_min_ttl = 3000
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  aliases = [var.domain]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.security_headers[0].id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  ordered_cache_behavior {
    path_pattern     = "/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

		function_association {
      event_type   = "viewer-request"
      function_arn = "${aws_cloudfront_function.rewrite_index.arn}"
    }

		min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations = []
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert[0].arn
    ssl_support_method  = "sni-only"
  }

  tags = local.project_tags
}


# --------------------------------------------------------------
# CloudFront Rewrite Function
# --------------------------------------------------------------

resource "aws_cloudfront_function" "rewrite_index" {
  name    = "rewrite_index"
  runtime = "cloudfront-js-2.0"
  comment = "function for rewrite to index.html"
  publish = true
  code    = file("${path.module}/function/function.js")
}


# --------------------------------------------------------------
# Route53
# --------------------------------------------------------------

resource "aws_route53_zone" "public_zone" {
  name          = var.domain
  comment       = "Public hosted zone for ${var.domain}"
  force_destroy = true
  
  tags = local.project_tags
}

resource "aws_route53_record" "www" {
  count = var.domain_enabled ? 1 : 0

  for_each = {
    for dvo in aws_acm_certificate.cert[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.public_zone.zone_id
}

resource "aws_route53_record" "record_a" {
  count = var.domain_enabled ? 1 : 0

  zone_id = aws_route53_zone.public_zone.id
  name    = var.domain
  type    = "A"

  alias {
    name                   = replace(aws_cloudfront_distribution.s3_distribution[0].domain_name, "/[.]$/", "")
    zone_id                = aws_cloudfront_distribution.s3_distribution[0].hosted_zone_id
    evaluate_target_health = true
  }
}


# --------------------------------------------------------------
# Bucket S3
# --------------------------------------------------------------

resource "aws_s3_bucket" "s3_bucket" {
  count = var.domain_enabled ? 1 : 0

  bucket = var.bucket_name
  tags = local.project_tags
}

resource "aws_s3_bucket_ownership_controls" "s3_ownership" {
  count = var.domain_enabled ? 1 : 0

  bucket = aws_s3_bucket.s3_bucket[0].id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  count = var.domain_enabled ? 1 : 0

  bucket = aws_s3_bucket.s3_bucket[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_origin_access_control" "cloudfront_s3_oac" {
  count = var.domain_enabled ? 1 : 0

  name                              = "CloudFront S3 OAC - ${var.domain}"
  description                       = "Cloud Front S3 OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_s3_bucket_policy" "cdn_oac_bucket_policy" {
  count = var.domain_enabled ? 1 : 0

  bucket = aws_s3_bucket.s3_bucket[0].id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}


# --------------------------------------------------------------
# Upload files
# --------------------------------------------------------------

resource "aws_s3_object" "upload_files" {
  count = var.domain_enabled ? 1 : 0

  for_each = fileset(var.files_path, "**/*.*")
  bucket = aws_s3_bucket.s3_bucket[0].id
  key    = each.value
  source = "${var.files_path}/${each.value}"
  etag = filemd5("${var.files_path}/${each.value}")
}

# --------------------------------------------------------------
# WAF
# --------------------------------------------------------------

resource "aws_wafv2_web_acl" "waf" {
  count = var.domain_enabled ? 1 : 0
  name  = "waf-${var.domain}"
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWS-AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "aws-managed-common-rules"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "waf-metrics"
    sampled_requests_enabled   = false
  }
}
