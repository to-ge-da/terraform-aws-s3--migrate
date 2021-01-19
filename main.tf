# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# This module has been updated with 0.14 syntax, which means it is no longer compatible with any versions below 0.14.
# ----------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = "eu-central-1"
}

terraform {
  required_version = "~> 0.13"
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY S3 BUCKET STATIC WEBSITE HOSTING
# Cloudfront takes 3 to 5 minutes for full deployment to become available via *.cloudfront.net.
# ---------------------------------------------------------------------------------------------------------------------

module "s3_bucket" {
  source = "./modules/s3"

  bucket     = "bucket_name"
  versioning = false
}
