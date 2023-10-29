locals {
  env = "${var.env == "prod" ? "prd-prod" : ( var.env == "staging" ? "nprd-staging" : ( var.env == "dev" ? "nprd-dev" : ""))}"
}

resource "google_compute_address" "ips_nat_prod" {
    name = "orderonline-${local.env}-ips-nat-prod"
    address_type = "EXTERNAL" 
}