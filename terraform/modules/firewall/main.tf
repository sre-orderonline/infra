locals {
  env = "${var.env == "prod" ? "prd-prod" : ( var.env == "staging" ? "nprd-staging" : ( var.env == "dev" ? "nprd-dev" : ""))}"
}

resource "google_compute_firewall" "allow_http" {
  name        = "orderonline-${local.env}-infra-fwl-tcp-80-allow-http"
  network     = "${var.vpc-prod}"
  description = "Allow port tcp 80 http"

  allow {
    protocol  = "tcp"
    ports     = ["80"]
  }

  source_ranges = [ "0.0.0.0/0" ]
  target_tags = ["allow-http"]
}

resource "google_compute_firewall" "allow_https" {
  name        = "orderonline-${local.env}-infra-fwl-tcp-443-allow-https"
  network     = "${var.vpc-prod}"
  description = "Allow port tcp 443 http"

  allow {
    protocol  = "tcp"
    ports     = ["443"]
  }
  
  source_ranges = [ "0.0.0.0/0" ]
  target_tags = ["allow-https"]
}

resource "google_compute_firewall" "allow_int_all" {
  name        = "orderonline-${local.env}-infra-fwl-allow-int-all"
  network     = "${var.vpc-prod}"
  description = "Allow all port for internal network only"

  allow {
    protocol  = "all"
  }

  source_ranges = [ "10.0.0.0/8"]
  target_tags = ["allow-int-all"]
}

resource "google_compute_firewall" "allow_ingress_from_iap" {
  name        = "orderonline-${local.env}-infra-fwl-allow-ingress-from-iap"
  network     = "${var.vpc-prod}"
  description = "Allow all port for internal network only"

  allow {
    protocol  = "tcp"
    ports = [ "22" ]
  }

  source_ranges = [ "35.235.240.0/20"]
  target_tags = ["allow-ingress-from-iap"]
}