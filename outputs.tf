output "bucket_name" {
  description = "Bucket name for our static website hosting"
  value       = module.terrahouse_aws.bucket_name
}

output "s3_website_endpoint" {
  description = "S3 Static Website Hosting Endpoint"
  value       = module.terrahouse_aws.s3_website_endpoint
}

output "index_html_filepath" {
  value = var.index_html_filepath
}

output "error_html_filepath" {
  value = var.error_html_filepath
}