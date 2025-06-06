output "waf_global_arn" {
  value = aws_wafv2_web_acl.wafv2[1].arn
}