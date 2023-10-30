provider "google" {
	region = "asia-southeast1"
}

run "create_bucket" {
	module {
		source = "../gcp/gcs/"
	}
	variables {
		bucket_name = "test_create_bucket"
		project_id = "develop-339203"
		random_suffix = true
	}
	assert {
		condition = google_storage_bucket.this.name == "test_create_bucket-${output.suffix}"
		error_message = "failed to create bucket"
	}
}

run "test_create_bucket_without_suffix" {
	variables {
		bucket_name = "test-create-bucket-2x394"
		project_id = "develop-339203"
	}
	assert {
		condition = google_storage_bucket.this.name == "test-create-bucket-2x394"
		error_message = "failed to create bucket"
	}
}
