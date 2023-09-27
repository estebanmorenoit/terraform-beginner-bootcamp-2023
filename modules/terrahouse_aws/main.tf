# Declare the required provider and version for AWS.
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}

# Define an AWS S3 bucket resource for hosting a website.
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name

  # Add tags to the S3 bucket for tracking purposes.
  tags = {
    user_uuid = var.user_uuid
  }
}

# Configure the AWS S3 bucket to serve as a static website.
resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.website_bucket.bucket

  # Specify the index document for the website.
  index_document {
    suffix = "index.html"
  }

  # Specify the error document to display on HTTP errors.
  error_document {
    key = "error.html"
  }
}

# Upload the index.html file to the S3 bucket.
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = var.index_html_filepath

  etag = filemd5(var.index_html_filepath)
}

# Upload the error.html file to the S3 bucket.
resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "error.html"
  source = var.error_html_filepath

  etag = filemd5(var.error_html_filepath)
}
