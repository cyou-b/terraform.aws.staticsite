locals {
  s3_origin_id = "myS3Origin"
}

locals {
  project_tags = {
    Name        = "StaticSite"
    Environment = "Production"
    Project     = "Project"
  }
}