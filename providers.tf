terraform {
  cloud {
    organization = "estebanmorenoit"

    workspaces {
      name = "terra-house-1"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.16.2"
    }
  }
}

provider "aws" {
  # Configuration options
}
