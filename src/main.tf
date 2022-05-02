provider "aws" {
  region = var.aws_region
}

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }

  # backend "s3" {
  #   bucket = ""
  #   key    = ""
  #   region = ""
  # }
}