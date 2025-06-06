#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "s3" {
  count  = length(var.s3_name)
  bucket = "${var.stack_id}-${var.s3_name[count.index]}"
  tags = {
    "info:backup_S3" = "true"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  count  = length(aws_s3_bucket.s3)
  bucket = aws_s3_bucket.s3[count.index].id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "access_block" {
  count                   = length(aws_s3_bucket.s3)
  bucket                  = aws_s3_bucket.s3[count.index].id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  count  = length(aws_s3_bucket.s3)
  bucket = aws_s3_bucket.s3[count.index].id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" { #tfsec:ignore:aws-s3-encryption-customer-key
  count  = length(aws_s3_bucket.s3)
  bucket = aws_s3_bucket.s3[count.index].bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "oaipolicy" {
  count  = length(aws_s3_bucket.s3)
  bucket = aws_s3_bucket.s3[count.index].bucket
  policy = data.aws_iam_policy_document.policy[count.index].json
}