# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# This module has been updated with 0.14 syntax, which means it is no longer compatible with any versions below 0.14.
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = "~> 0.13"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE s3 BUCKET
# ---------------------------------------------------------------------------------------------------------------------

locals {
  tags = {
    Description = "awslab"
    Project     = "awslab"
    Environment = "dev"
    Product     = "s3 bucket"
  }
}


data "template_file" "policy" {
  template = file("${path.module}/policy/bucket_policy.json")
  vars = {
    bucket_name = var.bucket
  }
}

resource "aws_s3_bucket" "main" {
  count = var.create_s3 ? 1 : 0

  bucket          = var.bucket
  acl             = var.acl
  force_destroy   = var.force_destroy
  policy          = data.template_file.policy.rendered

  versioning {
    enabled = var.versioning
  }

  dynamic "website" {
    for_each = var.website
    content {
      index_document = website.value["index"]
      error_document = website.value["error"]
      /*routing_rules  = website.value["routing"]*/
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.sse_algorithm
      }
    }
  }

  tags = merge(
    local.tags,
    {
      Name = format("%s", var.bucket)
    }
  )

}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = false
}

resource "null_resource" "remove_and_upload_to_s3" {

  count = var.create_s3 ? 1 : 0

  provisioner "local-exec" {
    command = "aws s3 sync ${path.module}/front/build s3://${aws_s3_bucket.main[0].id}"
  }

  depends_on = [aws_s3_bucket.main]
}
