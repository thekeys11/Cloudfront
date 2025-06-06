### Global Variables ###
variable "aws_region" {
  type = string
}
variable "stack_id" {
  type = string
}

### Cloudfront Variables ###
variable "s3_name" {
  type = list(string)
}
variable "apgw_id" {
  type = string
}
variable "api_gw_origin_id" {
  type = string
}
variable "s3domain" {
  type = list(string)
}
variable "origin_access_identitypath" {
  type = string
}
variable "cloudfront_error_caching_min_ttl" {
  type = number
}
variable "cloudfront_response_code" {
  type = number
}
variable "cloudfront_response_page_path" {
  type = string
}
variable "cloudfront_error_code" {
  type = number
}
variable "cloudfront_origin_id" {
  type = string
}
variable "origin_path" {
  type = string
}

variable "ordered_cache_behavior" {
  type = list(object({
    path_pattern           = string
    allowed_methods        = list(string)
    cached_methods         = list(string)
    target_origin_id       = string
    viewer_protocol_policy = string
    min_ttl                = number
    compress               = bool
    default_ttl            = number
    max_ttl                = number
  }))
}

variable "cloudfront_s3_origin_id" {
  type = string
}

### WAF GLOBAL ###
variable "waf_global_id" {
  type = string
}