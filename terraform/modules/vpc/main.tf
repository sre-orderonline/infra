locals {
  env = "${var.env == "prod" ? "prd-prod" : ( var.env == "staging" ? "nprd-staging" : ( var.env == "dev" ? "nprd-dev" : ""))}"
}

resource "google_compute_network" "vpc_prod" {
  name                    = "orderonline-${local.env}-vpc"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "subnet_general_prod" {
  name      = "orderonline-${local.env}-sub-general"
  ip_cidr_range = "10.10.0.0/24"
  network = google_compute_network.vpc_prod.id
}

resource "google_compute_subnetwork" "subnet_gke_prod" {
  name          = "orderonline-${local.env}-sub-gke"
  ip_cidr_range = "10.20.0.0/22"
  network       = google_compute_network.vpc_prod.id
  secondary_ip_range {
    range_name    = "orderonline-${local.env}-sub-sec-services"
    ip_cidr_range = "10.21.0.0/20"
  }
  secondary_ip_range {
    range_name    = "orderonline-${local.env}-sub-sec-pods"
    ip_cidr_range = "10.22.0.0/16"
  }
}