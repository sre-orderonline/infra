locals {
  env = "${var.env == "prod" ? "prd-prod" : ( var.env == "staging" ? "nprd-staging" : ( var.env == "dev" ? "nprd-dev" : ""))}"
}

resource "google_storage_bucket" "gcs_cdn" {
  name = "skripsirf-${local.env}-gcs-cdn"
  location = "ASIA-SOUTHEAST1"
  force_destroy = true
  storage_class = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention = "inherited"
}

resource "google_storage_bucket_iam_member" "public_read" {
  bucket = google_storage_bucket.gcs_cdn.name
  role   = "roles/storage.legacyObjectReader"
  member = "allUsers"
}