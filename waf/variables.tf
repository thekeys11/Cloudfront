### Variables Waf ###
variable "stack_id" {
  type = string
}
variable "aws_region" {
  type = string
}

variable "wafv2_description" {
  type = string
}

variable "wafv2_scope" {
  type = list(string)
}

variable "wafv2_web_acl_association" {
  #type = string
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