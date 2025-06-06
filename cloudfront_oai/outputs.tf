output "oai_arn" {
  value = aws_cloudfront_origin_access_identity.OAI.iam_arn
}

output "oai_path" {
  value = aws_cloudfront_origin_access_identity.OAI.cloudfront_access_identity_path
}
