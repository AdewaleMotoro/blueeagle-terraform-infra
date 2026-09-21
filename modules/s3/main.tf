# modules/s3/main.tf
#
# Creates a secure, versioned S3 bucket for application data.
# Similar to the bootstrap bucket, but reusable - this module
# can be called multiple times with different names/prefixes.

resource "aws_s3_bucket" "app" {
  bucket = "${var.name_prefix}-app"

  tags = merge(var.tags, {
    Name  = "${var.name_prefix}-app"
    Owner = var.trainee_name
  })
}

resource "aws_s3_bucket_versioning" "app" {
  bucket = aws_s3_bucket.app.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app" {
  bucket = aws_s3_bucket.app.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "app" {
  bucket = aws_s3_bucket.app.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}