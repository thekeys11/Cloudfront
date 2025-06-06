aws_region = "us-east-1"
vpc_id     = ""

### Enviroment taxonomy ###
local_tag_cloud               = ""
local_tag_reg                 = ""
local_tag_ou                  = ""
local_tag_pro                 = ""
local_tag_env                 = ""

### Cloudfront ###
cloudfront_error_caching_min_ttl = 10
cloudfront_response_code         = 200
cloudfront_response_page_path    = "/index.html"
cloudfront_error_code            = 404
cloudfront_origin_id             = ""
cloudfront_s3_origin_id = ""
origin_path             = "/dev"
ordered_cache_behavior = [
  {
    path_pattern          = ""
    allowed_methods       = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods        = ["GET", "HEAD"]
    target_origin_id      = ""
    viewer_protocol_policy = "redirect-to-https"
    compress              = true
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  },
  {
    path_pattern          = ""
    allowed_methods       = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods        = ["GET", "HEAD"]
    target_origin_id      = ""
    viewer_protocol_policy = "redirect-to-https"
    compress              = true
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  },
  {
    path_pattern          = ""
    allowed_methods       = ["GET", "HEAD", "OPTIONS"]
    cached_methods        = ["GET", "HEAD"]
    target_origin_id      = ""
    viewer_protocol_policy = "redirect-to-https"
    compress              = true
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }
]

### S3 ###
s3_name = ["s3"]

### WAF ###
wafv2_description                 = "WAF con reglas de tipo WEB ACL para la proteccion del recurso"
wafv2_scope                       = ["REGIONAL", "CLOUDFRONT"]
wafv2_ipset_whitelist_ipv4        = ["0.0.0.0/32"]
wafv2_ipset_whitelist_ipv6        = ["fd00:db8:deca:daed::/64"]
wafv2_ipset_blacklist_ipv4        = ["0.0.0.0/32"]
wafv2_ipset_blacklist_ipv6        = ["fd00:db8:deca:daed::/64"]
wafv2_ipset_ScannersProbes_ipv4   = ["0.0.0.0/32"]
wafv2_ipset_ScannersProbes_ipv6   = ["fd00:db8:deca:daed::/64"]
wafv2_ipset_Block_Reputation_ipv4 = ["0.0.0.1/32"]
wafv2_ipset_Block_Reputation_ipv6 = ["fd00:db8:deca:daed::/64"]
wafv2_ipset_BadBotRule_ipv4       = ["0.0.0.0/32"]
wafv2_ipset_BadBotRule_ipv6       = ["fd00:db8:deca:daed::/64"]
