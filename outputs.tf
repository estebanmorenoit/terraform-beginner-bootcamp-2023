output "bucket_name" {
  description = "Bucket name for our static website hosting"
  value       = module.terrahome_hosting.bucket_name
}

output "s3_website_endpoint" {
  description = "S3 Static Website Hosting Endpoint"
  value       = module.terrahome_hosting.s3_website_endpoint
}

output "cloudfront_url" {
  description = "The CloudFront Distribution Domain Name"
  value       = module.terrahome_hosting.domain_name
}