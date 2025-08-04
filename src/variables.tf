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

variable "files_path" {
    type        = string
    description = "The path to the files to be uploaded to the S3 bucket."
}

variable "domain_enabled" {
  type        = bool
  default     = false
  description = "Enable or disable the creation of domain-related resources."
}