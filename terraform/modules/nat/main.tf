locals {
  env = "${var.env == "prod" ? "prd-prod" : ( var.env == "staging" ? "nprd-staging" : ( var.env == "dev" ? "nprd-dev" : ""))}"
}

resource "google_compute_router" "rtr_prod" {
  name = "orderonline-${local.env}-rtr"
  network = "${var.vpc-prod}"
}

resource "google_compute_router_nat" "nat_prod" {
  name = "orderonline-${local.env}-nat"
  router = google_compute_router.rtr_prod.name
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips = ["${var.ips-nat-prod}"]
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}