locals {
  env = "${var.env == "prod" ? "prd-prod" : ( var.env == "staging" ? "nprd-staging" : ( var.env == "dev" ? "nprd-dev" : ""))}"
}

resource "google_service_account" "sa_gke" {
  account_id   = "orderonline-${local.env}-sa-gke"
  display_name = "Service Account Compute Engine gke"
}

# resource "google_service_account_iam_binding" "sa_gke_binding" {
#   service_account_id = google_service_account.sa_gke.name
#   role = "roles/iam.workloadIdentityUser"

#   members = [
#     "serviceAccount:rf-asl-0.svc.id.goog[imageserver/sa-be-svc-cdn]"
#   ]
# }

# resource "google_project_iam_binding" "sa_binding_gke_cls_01" {
#   project = var.project
#   role = "roles/storage.admin"
#   members = [
#     "serviceAccount:orderonline-prd-prod-sa-gke@rf-asl-0.iam.gserviceaccount.com"
#   ]
# }

resource "google_container_cluster" "gke_cls_01" {
  name = "orderonline-${local.env}-k8s-cls-01"
  location = "${var.location}"
  remove_default_node_pool = true
  initial_node_count = 1
  network = "${var.network}"
  subnetwork = "${var.subnetwork}"
  enable_intranode_visibility = false
  enable_shielded_nodes = true
  min_master_version = "1.27.3-gke.1700"
  resource_labels = {
    "env" = "prod"
  }
  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }
    http_load_balancing {
      disabled = false
    }
  }

  dns_config {
    cluster_dns = "CLOUD_DNS"
    cluster_dns_scope = "VPC_SCOPE"
    cluster_dns_domain = "gke-prod.internal"
  }
  
  ip_allocation_policy {
    cluster_secondary_range_name = "orderonline-${local.env}-sub-sec-pods"
    services_secondary_range_name = "orderonline-${local.env}-sub-sec-services"
  }

  private_cluster_config {
    enable_private_nodes = true  
    master_ipv4_cidr_block = "${var.master-ipv4-cidr-block}"
    master_global_access_config {
      enabled = true
    }
  }

  release_channel {
    channel = "REGULAR" 
  }

  workload_identity_config {
    workload_pool = "${var.project}.svc.id.goog"
  }

  logging_config {
    enable_components = [ "SYSTEM_COMPONENTS" ]
  }

  timeouts {
    create = "20m"
    update = "40m"
  }
}

resource "google_container_node_pool" "gke_nodes_all" {
  name = "orderonline-${local.env}-k8s-cls-01-npl-all"
  location = "${var.location}"
  cluster = google_container_cluster.gke_cls_01.id
  node_count = "${var.gke-num-nodes-all}"
  max_pods_per_node = "110"

  node_config {
    image_type = "UBUNTU_CONTAINERD"
    machine_type = "e2-custom-2-4096"
    disk_type = "pd-balanced"
    disk_size_gb = "50"
    tags = [ "allow-ext-traefik", "allow-int-all"]
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
  # autoscaling {
  #   min_node_count = "2"
  #   max_node_count = "3"
  #   location_policy = "BALANCED"
  # }
}