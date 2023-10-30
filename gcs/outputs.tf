output "bucket_name" {
  value = local.bucket_name
}

output "service_account_key" {
  value     = var.create_key ? base64decode(google_service_account_key.this.0.private_key) : ""
  sensitive = true
}

output "bucket_region" {
  value = var.region
}

output "service_account_email" {
  value = var.create_service_account ? google_service_account.this.0.email : ""
}

output "suffix" {
  value = var.random_suffix ? random_id.suffix.0.hex : ""
}
