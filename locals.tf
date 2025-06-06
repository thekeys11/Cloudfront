locals {
  stack_id     = "${var.local_tag_reg}${var.local_tag_ou}${var.local_tag_pro}-${var.local_tag_env}"
  s3_origin_id = "${local.stack_id}-S3Origin"
}