module "cloudfront" {
  source                           = "./cloudfront"
  stack_id                         = local.stack_id
  aws_region                       = var.aws_region
  s3_name                          = module.s3.s3bucketname
  s3domain                         = module.s3.s3bucketdomain
  origin_access_identitypath       = module.cloudfront_oai.oai_path
  waf_global_id                    = module.waf.waf_global_arn
  cloudfront_error_caching_min_ttl = var.cloudfront_error_caching_min_ttl
  cloudfront_response_code         = var.cloudfront_response_code
  cloudfront_response_page_path    = var.cloudfront_response_page_path
  cloudfront_error_code            = var.cloudfront_error_code
  apgw_id                          = module.api_gateway.api_reg_id
  cloudfront_origin_id             = var.cloudfront_origin_id
  api_gw_origin_id                 = local.stack_id
  ordered_cache_behavior           = var.ordered_cache_behavior
  origin_path                      = var.origin_path
  cloudfront_s3_origin_id          = var.cloudfront_s3_origin_id
}

module "cloudfront_oai" {
  source                 = "./cloudfront_oai"
  cloudfront_oai_comment = "${local.stack_id}-${var.s3_name[0]}-OAI"
}

module "s3" {
  source             = "./modules/s3"
  stack_id           = local.stack_id
  s3_name            = var.s3_name
  cloudfront_oai_arn = module.cloudfront_oai.oai_arn
}

module "s3_website_static_content" {
  source                         = "./s3_website"
  s3_bucket_website              = module.s3.s3bucketname[0]
  s3_bucket_website_index_suffix = "index.html"
}

module "waf" {
  source                            = "./waf"
  stack_id                          = local.stack_id
  aws_region                        = var.aws_region
  wafv2_description                 = var.wafv2_description
  wafv2_scope                       = var.wafv2_scope
  wafv2_ipset_whitelist_ipv4        = var.wafv2_ipset_whitelist_ipv4
  wafv2_ipset_whitelist_ipv6        = var.wafv2_ipset_whitelist_ipv6
  wafv2_ipset_blacklist_ipv4        = var.wafv2_ipset_blacklist_ipv4
  wafv2_ipset_blacklist_ipv6        = var.wafv2_ipset_blacklist_ipv6
  wafv2_ipset_ScannersProbes_ipv4   = var.wafv2_ipset_ScannersProbes_ipv4
  wafv2_ipset_ScannersProbes_ipv6   = var.wafv2_ipset_ScannersProbes_ipv6
  wafv2_ipset_Block_Reputation_ipv4 = var.wafv2_ipset_Block_Reputation_ipv4
  wafv2_ipset_Block_Reputation_ipv6 = var.wafv2_ipset_Block_Reputation_ipv6
  wafv2_ipset_BadBotRule_ipv4       = var.wafv2_ipset_BadBotRule_ipv4
  wafv2_ipset_BadBotRule_ipv6       = var.wafv2_ipset_BadBotRule_ipv6
}