output "this_bucket_name" {
  value = element(concat(aws_s3_bucket.main.*.bucket, [""]), 0)
}

output "this_bucket_domain_name" {
  value = element(concat(aws_s3_bucket.main.*.bucket_domain_name, [""]), 0)
}

output "this_bucket_website_domain" {
  value = element(concat(aws_s3_bucket.main.*.website_domain, [""]), 0)
}

output "this_bucket_website_endpoint" {
  value = element(concat(aws_s3_bucket.main.*.website_endpoint, [""]), 0)
}
