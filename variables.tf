### Variables Globales ###
variable "aws_region" {
  type = string
}
variable "vpc_id" {
  type = string
}

### Enviroment taxonomy ###
variable "local_tag_cloud" {
  type = string
}
variable "local_tag_reg" {
  type = string
}
variable "local_tag_ou" {
  type = string
}
variable "local_tag_pro" {
  type = string
}
variable "local_tag_env" {
  type = string
}

### Variables S3 ###
variable "s3_name" {
  type = list(string)
}

### Variables Waf ###
variable "wafv2_description" {
  type = string
}
variable "wafv2_scope" {
  type = list(string)
}
variable "wafv2_ipset_whitelist_ipv4" {
  description = "Allow whitelist for IPV4 addresses"
  default     = []
}
variable "wafv2_ipset_whitelist_ipv6" {
  description = "Allow whitelist for IPV4 addresses"
  default     = []
  type        = list(string)
}
variable "wafv2_ipset_blacklist_ipv4" {
  description = "Allow blacklist for IPV4 addresses"
  default     = []
}
variable "wafv2_ipset_blacklist_ipv6" {
  description = "Allow blacklist for IPV6 addresses"
  default     = []
  type        = list(string)
}
variable "wafv2_ipset_ScannersProbes_ipv4" {
  description = "Allow ScannersProbes for IPV4 addresses"
  default     = []
}
variable "wafv2_ipset_ScannersProbes_ipv6" {
  description = "Allow ScannersProbes for IPV6 addresses"
  default     = []
  type        = list(string)
}
variable "wafv2_ipset_Block_Reputation_ipv4" {
  description = "Allow Block_Reputation for IPV4 addresses"
  default     = []
}
variable "wafv2_ipset_Block_Reputation_ipv6" {
  description = "Allow Block_Reputation for IPV6 addresses"
  default     = []
  type        = list(string)
}
variable "wafv2_ipset_BadBotRule_ipv4" {
  description = "Allow BadBotRule for IPV4 addresses"
  default     = []
}
variable "wafv2_ipset_BadBotRule_ipv6" {
  description = "Allow BadBotRule for IPV6 addresses"
  default     = []
  type        = list(string)
}

### Variables Cloudfront ###
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
variable "cloudfront_s3_origin_id" {
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