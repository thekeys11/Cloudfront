resource "aws_cloudfront_origin_access_identity" "OAI" {
  comment = var.cloudfront_oai_comment
}