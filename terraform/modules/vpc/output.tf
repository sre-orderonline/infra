output "vpc-prod" {
    value = google_compute_network.vpc_prod.id
}

output "subnet-general-prod" {
    value = google_compute_subnetwork.subnet_general_prod.id
}

output "subnet-gke-prod" {
    value = google_compute_subnetwork.subnet_gke_prod.id
}