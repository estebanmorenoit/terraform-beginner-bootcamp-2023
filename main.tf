

resource "random_string" "bucket_name" {
  length           = 32
  lower            = true
  upper            = false
  special          = true
  override_special = ".-"
}

resource "aws_s3_bucket" "example" {
  bucket = random_string.bucket_name.result
  tags = {
    UserUUID = var.user_uuid
  }
}


