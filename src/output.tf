output "bucket_regional_domain_name" {
  value = var.domain_enabled ? aws_s3_bucket.s3_bucket[0].bucket_regional_domain_name : ""
}

output "bucket_id" {
  value = var.domain_enabled ? aws_s3_bucket.s3_bucket[0].id : ""
}

output "bucket_arn" {
  value = var.domain_enabled ? aws_s3_bucket.s3_bucket[0].arn : ""
}

output "name_servers" {
  description = "Name servers for the Route 53 hosted zone."
  value       = aws_route53_zone.public_zone.name_servers
}
