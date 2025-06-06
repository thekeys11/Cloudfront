resource "aws_s3_bucket_website_configuration" "web" {
  bucket = var.s3_bucket_website
  index_document {
    suffix = var.s3_bucket_website_index_suffix
  }
}