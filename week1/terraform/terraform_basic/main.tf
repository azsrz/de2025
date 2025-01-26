terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  # Credentials only needs to be set if you do not have the GOOGLE_APPLICATION_CREDENTIALS set
  # credentials = 
  project = "sinuous-gist-448417-j9"
  region  = "us-central1"
}



resource "google_storage_bucket" "data-lake-bucket" {
  name     = "sinuous-gist-448417-j9-bucket"
  location = "US"

  # Optional, but recommended settings:
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 1 // days
    }
  }

  force_destroy = true
}


resource "google_bigquery_dataset" "dataset" {
  dataset_id = "my_dataset"
  project    = "sinuous-gist-448417-j9"
  location   = "US"
}