variable "aws_region" {
    type        = string
    default     = "us-east-1"
    description = "The AWS region where the resources will be provisioned."
}

variable "bucket_name" {
    type        = string
    description = "The name of the S3 bucket used for hosting your application files."
}

variable "domain" {
    type        = string
    description = "The domain name for your application."
}
