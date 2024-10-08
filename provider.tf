terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.69.0"
    }
  }
}

provider "aws" {
  region  = "ap-south-1" # Don't change the region
}


# Add your S3 backend configuration here
terraform {
  backend "s3" {
    bucket = "467.devops.candidate.exam"
    key    = "parama.siva"
    region = "ap-south-1"
  }
}