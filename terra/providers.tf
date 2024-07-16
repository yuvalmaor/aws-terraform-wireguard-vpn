terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    
  }


  backend "s3" {
    bucket = "yuval-s3-state"
    key    = "portfo/terraform.state"
    region = "ap-south-1"
    dynamodb_table = "yuval-terraform-locks"
  }
}



provider "aws" {
  region = "ap-south-1"
  default_tags {
    tags = var.tags
  }
}

