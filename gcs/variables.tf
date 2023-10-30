variable "project_id" {
  description = "The ID of the project in which the resource belongs to (required)"
  type        = string
}

variable "bucket_name" {
  description = "Bucket name."
  type        = string
}

variable "create_service_account" {
  description = "Whether or not create service account id from bucket name"
  type        = bool
  default     = false
}

variable "random_suffix" {
  description = "Whether or not to generate a random suffix in bucket name."
  type        = bool
  default     = false
}

variable "region" {
  description = "Bucket region."
  type        = string
  default     = "asia-southeast1"
}

variable "force_destroy" {
  description = "When deleting a bucket, this boolean option whill delete all contained objects."
  type        = bool
  default     = false
}

variable "storage_class" {
  description = "The Storage Class of the new bucket. Support values include: STANDARD, REGIONAL, NEARLINE, COLDLINE, ARCHIVE."
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "REGIONAL", "NEARLINE", "COLDLINE", "ARCHIVE"], var.storage_class)
    error_message = "Storage Class just only accept 'STANDARD', 'REGIONAL', 'NEARLINE', 'COLDLINE' and 'ARCHIVE'."
  }
}

variable "versioning_enabled" {
  description = "While set to 'true', versioning is fully enabled for the bucket."
  type        = bool
  default     = true
}

variable "create_key" {
  description = "Whether or not create a Service Account key"
  type        = bool
  default     = false
}

variable "labels" {
  description = "Bucket labels"
  type        = map(string)
  default     = {}
}

/*
cors = {
  origin          = ["http://image-store.com"]
  method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
  response_header = ["*"]
  max_age_seconds = 3600
}
*/
variable "cors" {
  description = "CORS settings"
  type        = any
  default     = null
}

variable "retention_policy" {
  description = "Retention period in seconds"
  type = object({
    enable_retention = bool
    retention_period = number
  })
  default = {
    enable_retention = false
    retention_period = 0
  }
  validation {
    condition     = !var.retention_policy.enable_retention || (var.retention_policy.retention_period > 0 && var.retention_policy.retention_period < 2147483647)
    error_message = "Retention Period must be greater than 0 and smaller than 2147483647."
  }
}
