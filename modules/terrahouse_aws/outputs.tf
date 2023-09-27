output "bucket_name" {
  value = aws_s3_bucket.website_bucket.bucket
}

output "s3_website_endpoint" {
  value = aws_s3_bucket_website_configuration.website_configuration.website_endpoint
}
output "index_html_filepath" {
  value = var.index_html_filepath
}

output "error_html_filepath" {
  value = var.error_html_filepath
}