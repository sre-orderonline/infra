provider "google" {
  project = var.project
  region  = var.region-prod
}

module "vpc" {
  env    = "${var.env}"
  source = "../../modules/vpc"
}

module "ips" {
  env    = "${var.env}"
  source = "../../modules/ips"
}

module "nat" {
  env    = "${var.env}"
  source = "../../modules/nat"
  vpc-prod = "${module.vpc.vpc-prod}"
  ips-nat-prod = "${module.ips.ips-nat-prod}"
}

module "firewall" {
  env = "${var.env}"
  source = "../../modules/firewall"
  vpc-prod = "${module.vpc.vpc-prod}"
}

module "compute_engine" {
  env = var.env
  source = "../../modules/compute_engine"
  subnetwork = "${module.vpc.subnet-general-prod}"
  zone = "${var.zone-prod}"
  project = var.project
}

module "gke" {
  env                 = var.env
  source              = "../../modules/gke"
  project             = var.project
  gke-num-nodes-all   = var.gke-num-nodes-all-prod
  gke-num-nodes-loadtest = var.gke-num-nodes-loadtest
  network             = "${module.vpc.vpc-prod}"
  subnetwork          = "${module.vpc.subnet-gke-prod}"
  location            = var.zone-prod
  master-ipv4-cidr-block = var.master-ipv4-cidr-block-prod
}