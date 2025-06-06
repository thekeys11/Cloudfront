resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = var.s3domain[0]
    origin_id   = "${var.stack_id}-${var.s3_name[0]}-s3Origin"
    s3_origin_config {
      origin_access_identity = var.origin_access_identitypath
    }
  }
  origin {
    domain_name = "${var.apgw_id}.execute-api.${var.aws_region}.amazonaws.com"
    origin_id   = "${var.stack_id}-${var.api_gw_origin_id}-apw-apwOrigin"
    origin_path = var.origin_path
    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  custom_error_response {
    error_caching_min_ttl = var.cloudfront_error_caching_min_ttl
    response_code         = var.cloudfront_response_code
    response_page_path    = var.cloudfront_response_page_path
    error_code            = var.cloudfront_error_code
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.cloudfront_s3_origin_id # Reemplaza con tu origen S3
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 60
    max_ttl                = 120
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behavior
    content {
      path_pattern           = ordered_cache_behavior.value.path_pattern
      allowed_methods        = ordered_cache_behavior.value.allowed_methods
      cached_methods         = ordered_cache_behavior.value.cached_methods
      target_origin_id       = ordered_cache_behavior.value.target_origin_id
      compress               = ordered_cache_behavior.value.compress
      min_ttl                = ordered_cache_behavior.value.min_ttl
      default_ttl            = ordered_cache_behavior.value.default_ttl
      max_ttl                = ordered_cache_behavior.value.max_ttl
      viewer_protocol_policy = ordered_cache_behavior.value.viewer_protocol_policy
    }
  }
  lifecycle {
    ignore_changes = [
      ordered_cache_behavior[0].cache_policy_id, ordered_cache_behavior[1].cache_policy_id
    ]
  }

  price_class = "PriceClass_All"
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
    #minimum_protocol_version       = "TLSv1.2_2021"
  }
  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.s3.bucket_domain_name
    prefix          = "logs"
  }
  web_acl_id = var.waf_global_id
}

resource "aws_s3_bucket" "s3" { #tfsec:ignore:aws-s3-enable-bucket-logging
  bucket = "${var.stack_id}-s3-cloudfront-login"
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.s3.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "access_block" {
  bucket                  = aws_s3_bucket.s3.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.s3.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" { #tfsec:ignore:aws-s3-encryption-customer-key
  bucket = aws_s3_bucket.s3.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}