terraform {
  cloud {
    organization = "estebanmorenoit"

    workspaces {
      name = "terra-house-1"
    }
  }
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

provider "random" {
  # Configuration options
}

resource "random_string" "bucket_name" {
  length           = 32
  lower            = true
  upper            = false
  special          = true
  override_special = ".-"
}

resource "aws_s3_bucket" "example" {
  bucket = random_string.bucket_name.result

}

output "random_bucket" {
  value = random_string.bucket_name.result
}
