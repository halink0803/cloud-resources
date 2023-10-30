locals {
  bucket_name = var.random_suffix ? "${var.bucket_name}-${random_id.suffix.0.hex}" : var.bucket_name
  cors = {
    origin          = try(var.cors.origin, [])
    method          = try(var.cors.method, [])
    response_header = try(var.cors.response_header, [])
    max_age_seconds = try(var.cors.max_age_seconds, 3600)
  }
}

resource "random_id" "suffix" {
  count = var.random_suffix ? 1 : 0

  byte_length = 4
}

resource "google_storage_bucket" "this" {
  name     = local.bucket_name
  project  = var.project_id
  location = var.region

  uniform_bucket_level_access = true
  force_destroy               = var.force_destroy
  storage_class               = var.storage_class
  labels                      = var.labels

  dynamic "retention_policy" {
    for_each = var.retention_policy.enable_retention ? [1] : []
    content {
      retention_period = var.retention_policy.retention_period
    }
  }

  versioning {
    enabled = var.versioning_enabled
  }

  dynamic "cors" {
    for_each = toset(var.cors != null ? [1] : [])

    content {
      origin          = local.cors.origin
      method          = local.cors.method
      response_header = local.cors.response_header
      max_age_seconds = local.cors.max_age_seconds
    }
  }
}

resource "google_service_account" "this" {
  project      = var.project_id
  display_name = "${local.bucket_name}'s Service Account"
  count        = var.create_service_account ? 1 : 0
  account_id   = substr(replace(local.bucket_name, ".", "-"), 0, 30) // trim to under 30 characters
}

resource "google_service_account_key" "this" {
  count              = var.create_key ? 1 : 0
  service_account_id = google_service_account.this[count.index].name
}

resource "google_storage_bucket_iam_binding" "binding" {
  count  = var.create_service_account ? 1 : 0
  bucket = google_storage_bucket.this.name
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.this.0.email}",
  ]
}
