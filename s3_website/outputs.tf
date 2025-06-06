output "s3_website_endpoint" {
  value = aws_s3_bucket_website_configuration.web.website_endpoint
}