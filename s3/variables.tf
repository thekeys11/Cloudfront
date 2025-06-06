### Variables S3 ###
variable "stack_id" {
  type = string
}
variable "s3_name" {
  type = list(string)
}
variable "cloudfront_oai_arn" {
  type = string
}