output "s3_bucket_name" {
  description = "S3 Bucket name for futher usage"
  value = aws_s3_bucket.session_store.bucket_domain_name
}
