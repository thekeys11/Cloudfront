data "aws_iam_policy_document" "policy" {
  count = length(aws_s3_bucket.s3)
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3[count.index].arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [var.cloudfront_oai_arn]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.s3[count.index].arn]

    principals {
      type        = "AWS"
      identifiers = [var.cloudfront_oai_arn]
    }
  }
}