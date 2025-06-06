output "s3bucketname" {
  value = aws_s3_bucket.s3.*.bucket
}

output "s3bucketdomain" {
  value = aws_s3_bucket.s3.*.bucket_regional_domain_name
}

output "s3bucketarn" {
  value = aws_s3_bucket.s3.*.arn
}