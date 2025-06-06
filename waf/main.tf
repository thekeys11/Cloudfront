### Ip set ipv4-ipv6 rule for whitelist ###
resource "aws_wafv2_ip_set" "WAFWhitelistSetV4" {
  count              = length(var.wafv2_scope)
  name               = "AWSWAFSecurityAutomationsWhitelistSetIPV4"
  description        = "Allow List for IPV4 addresses"
  scope              = var.wafv2_scope[count.index]
  ip_address_version = "IPV4"
  addresses          = var.wafv2_ipset_whitelist_ipv4
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_wafv2_ip_set" "WAFWhitelistSetV6" {
  count              = length(var.wafv2_scope)
  name               = "AWSWAFSecurityAutomationsWhitelistSetIPV6"
  description        = "Allow List for IPV6 addresses"
  scope              = var.wafv2_scope[count.index]
  ip_address_version = "IPV6"
  addresses          = var.wafv2_ipset_whitelist_ipv6
  lifecycle {
    create_before_destroy = true
  }
}

### Ip set ipv4-ipv6 rule for blacklist ###
resource "aws_wafv2_ip_set" "WAFBlacklistSetV4" {
  count              = length(var.wafv2_scope)
  name               = "AWSWAFSecurityAutomationsBlacklistSetIPV4"
  description        = "Block Denied List for IPV4 addresses"
  scope              = var.wafv2_scope[count.index]
  ip_address_version = "IPV4"
  addresses          = var.wafv2_ipset_blacklist_ipv4
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_wafv2_ip_set" "WAFBlacklistSetV6" {
  count              = length(var.wafv2_scope)
  name               = "AWSWAFSecurityAutomationsBlacklistSetIPV6"
  description        = "Block Denied List for IPV6 addresses"
  scope              = var.wafv2_scope[count.index]
  ip_address_version = "IPV6"
  addresses          = var.wafv2_ipset_blacklist_ipv6
  lifecycle {
    create_before_destroy = true
  }
}

### IP SET ipv4-ipv6 RULE ScannersProbes ###
resource "aws_wafv2_ip_set" "ScannersProbesSetV4" {
  count              = length(var.wafv2_scope)
  name               = "AWSWAFSecurityAutomationsScannersProbesSetIPV4"
  description        = "Block Scanners/Probes IPV4 addresses"
  scope              = var.wafv2_scope[count.index]
  ip_address_version = "IPV4"
  addresses          = var.wafv2_ipset_ScannersProbes_ipv4
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_wafv2_ip_set" "ScannersProbesSetV6" {
  count              = length(var.wafv2_scope)
  name               = "AWSWAFSecurityAutomationsScannersProbesSetIPV6"
  description        = "Block Scanners/Probes IPV6 addresses"
  scope              = var.wafv2_scope[count.index]
  ip_address_version = "IPV6"
  addresses          = var.wafv2_ipset_ScannersProbes_ipv6
  lifecycle {
    create_before_destroy = true
  }
}

### IP SET ipv4-ipv6 RULE Block_Reputation ###
resource "aws_wafv2_ip_set" "Block_ReputationSetV4" {
  count              = length(var.wafv2_scope)
  name               = "AWSWAFSecurityAutomationsIPReputationListsSetIPV4"
  description        = "Block Reputation List IPV4 addresses"
  scope              = var.wafv2_scope[count.index]
  ip_address_version = "IPV4"
  addresses          = var.wafv2_ipset_Block_Reputation_ipv4
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_wafv2_ip_set" "Block_ReputationSetV6" {
  count              = length(var.wafv2_scope)
  name               = "AWSWAFSecurityAutomationsIPReputationListsSetIPV6"
  description        = "Block Reputation List IPV6 addresses"
  scope              = var.wafv2_scope[count.index]
  ip_address_version = "IPV6"
  addresses          = var.wafv2_ipset_Block_Reputation_ipv6
  lifecycle {
    create_before_destroy = true
  }
}

### IP SET ipv4-ipv6 RULE BadBotRule ###
resource "aws_wafv2_ip_set" "BadBotRuleSetV4" {
  count              = length(var.wafv2_scope)
  name               = "AWSWAFSecurityAutomationsIPBadBotSetIPV4"
  description        = "Block Bad Bot IPV4 addresses"
  scope              = var.wafv2_scope[count.index]
  ip_address_version = "IPV4"
  addresses          = var.wafv2_ipset_BadBotRule_ipv4
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_wafv2_ip_set" "BadBotRuleSetV6" {
  count              = length(var.wafv2_scope)
  name               = "AWSWAFSecurityAutomationsIPBadBotSetIPV6"
  description        = "Block Bad Bot IPV6 addresses"
  scope              = var.wafv2_scope[count.index]
  ip_address_version = "IPV6"
  addresses          = var.wafv2_ipset_BadBotRule_ipv6
  lifecycle {
    create_before_destroy = true
  }
}

### Waf web acl ####
resource "aws_wafv2_web_acl" "wafv2" {
  count       = length(var.wafv2_scope)
  name        = lower("${var.stack_id}-${var.wafv2_scope[count.index]}-wafv2")
  description = var.wafv2_description
  scope       = var.wafv2_scope[count.index]

  default_action {
    allow {}
  }

  ### Waf rule whitelist ###
  rule {
    name     = "AWSWAFSecurityAutomationsWhitelistRule"
    priority = 1
    action {
      block {}
    }
    statement {
      or_statement {
        statement {
          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.WAFWhitelistSetV4[count.index].arn
          }
        }
        statement {
          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.WAFWhitelistSetV6[count.index].arn
          }
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSWAFSecurityAutomationsWhitelistRule"
      sampled_requests_enabled   = true
    }
  }

  ### Waf rule blacklist ###
  rule {
    name     = "AWSWAFSecurityAutomationsBlacklistRule"
    priority = 2
    action {
      block {}
    }
    statement {
      or_statement {
        statement {
          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.WAFBlacklistSetV4[count.index].arn
          }
        }
        statement {
          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.WAFBlacklistSetV6[count.index].arn
          }
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSWAFSecurityAutomationsBlacklistRule"
      sampled_requests_enabled   = true
    }
  }
  ### WAF RULE HttpFloodRateBasedRule ###
  rule {
    name     = "AWSWAFSecurityAutomationsHttpFloodRateBasedRule"
    priority = 4
    action {
      block {}
    }
    statement {
      rate_based_statement {
        limit              = 1000
        aggregate_key_type = "IP"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSWAFSecurityAutomationsHttpFloodRateBasedRule"
      sampled_requests_enabled   = true
    }
  }

  ### Waf rule ScannersProbes ###
  rule {
    name     = "AWSWAFSecurityAutomationsScannersAndProbesRule"
    priority = 5
    action {
      block {}
    }
    statement {
      or_statement {
        statement {
          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.ScannersProbesSetV4[count.index].arn
          }
        }
        statement {
          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.ScannersProbesSetV6[count.index].arn
          }
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSWAFSecurityAutomationsScannersAndProbesRule"
      sampled_requests_enabled   = true
    }
  }

  ### Waf rule ScannersProbes ###
  rule {
    name     = "AWSWAFSecurityAutomationsIPReputationListsRule"
    priority = 6
    action {
      block {}
    }
    statement {
      or_statement {
        statement {
          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.Block_ReputationSetV4[count.index].arn
          }
        }
        statement {
          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.Block_ReputationSetV6[count.index].arn
          }
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSWAFSecurityAutomationsIPReputationListsRule"
      sampled_requests_enabled   = true
    }
  }

  ### Waf rule BadBotRule ###
  rule {
    name     = "AWSWAFSecurityAutomationsBadBotRule"
    priority = 7
    action {
      block {}
    }
    statement {
      or_statement {
        statement {
          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.BadBotRuleSetV4[count.index].arn
          }
        }
        statement {
          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.BadBotRuleSetV6[count.index].arn
          }
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSWAFSecurityAutomationsBadBotRule"
      sampled_requests_enabled   = true
    }
  }

  ## BlockSQLInjectionAttack ###
  rule {
    name     = "AWSWAFSecurityAutomationsSqlInjectionRule"
    priority = 20
    action {
      block {}
    }
    statement {
      or_statement {
        statement {
          sqli_match_statement {
            field_to_match {
              query_string {}
            }
            text_transformation {
              priority = 1
              type     = "URL_DECODE"
            }
            text_transformation {
              priority = 2
              type     = "HTML_ENTITY_DECODE"
            }
          }
        }
        statement {
          sqli_match_statement {
            field_to_match {
              body {}
            }
            text_transformation {
              priority = 1
              type     = "URL_DECODE"
            }
            text_transformation {
              priority = 2
              type     = "HTML_ENTITY_DECODE"
            }
          }
        }
        statement {
          sqli_match_statement {
            field_to_match {
              uri_path {}
            }
            text_transformation {
              priority = 1
              type     = "URL_DECODE"
            }
            text_transformation {
              priority = 2
              type     = "HTML_ENTITY_DECODE"
            }
          }
        }
        statement {
          sqli_match_statement {
            field_to_match {
              single_header {
                name = "authorization"
              }
            }
            text_transformation {
              priority = 1
              type     = "URL_DECODE"
            }
            text_transformation {
              priority = 2
              type     = "HTML_ENTITY_DECODE"
            }
          }
        }
        statement {
          sqli_match_statement {
            field_to_match {
              single_header {
                name = "cookie"
              }
            }
            text_transformation {
              priority = 1
              type     = "URL_DECODE"
            }
            text_transformation {
              priority = 2
              type     = "HTML_ENTITY_DECODE"
            }
          }
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSWAFSecurityAutomationsSqlInjectionRule"
      sampled_requests_enabled   = true
    }
  }

  ### Rule XssRule ###
  rule {
    name     = "AWSWAFSecurityAutomationsXssRule"
    priority = 30
    action {
      block {}
    }
    statement {
      or_statement {
        statement {
          xss_match_statement {
            field_to_match {
              query_string {}
            }
            text_transformation {
              priority = 1
              type     = "URL_DECODE"
            }
            text_transformation {
              priority = 2
              type     = "HTML_ENTITY_DECODE"
            }
          }
        }
        statement {
          xss_match_statement {
            field_to_match {
              body {}
            }
            text_transformation {
              priority = 1
              type     = "URL_DECODE"
            }
            text_transformation {
              priority = 2
              type     = "HTML_ENTITY_DECODE"
            }
          }
        }
        statement {
          xss_match_statement {
            field_to_match {
              uri_path {}
            }
            text_transformation {
              priority = 1
              type     = "URL_DECODE"
            }
            text_transformation {
              priority = 2
              type     = "HTML_ENTITY_DECODE"
            }
          }
        }
        statement {
          xss_match_statement {
            field_to_match {
              single_header {
                name = "cookie"
              }
            }
            text_transformation {
              priority = 1
              type     = "URL_DECODE"
            }
            text_transformation {
              priority = 2
              type     = "HTML_ENTITY_DECODE"
            }
          }
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSWAFSecurityAutomationsXssRule"
      sampled_requests_enabled   = true
    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "AWSWAFSecurityAutomations-WAFWebACL"
    sampled_requests_enabled   = true
  }
}