data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    actions = [ 
			"s3:ListBucket",
			"s3:GetObject" 
		]
    resources = [ 
			"${aws_s3_bucket.s3_bucket.arn}",
			"${aws_s3_bucket.s3_bucket.arn}/*"
		]
    principals {
      type = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test = "StringEquals"
      variable = "AWS:SourceArn"
      values = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}
