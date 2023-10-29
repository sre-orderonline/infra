locals {
  env = "${var.env == "prod" ? "prd-prod" : ( var.env == "staging" ? "nprd-staging" : ( var.env == "dev" ? "nprd-dev" : ""))}"
}

resource "google_service_account" "sa_bastion" {
  account_id   = "orderonline-${local.env}-sa-bas"
  display_name = "Service Account Compute Engine Bastion"
}

resource "google_compute_instance" "cen_bastion" {
  zone = "${var.zone}"
  name = "orderonline-${local.env}-cen-bas"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
        image = "ubuntu-2204-lts"
        size = "50"
        type = "pd-balanced"
    }
  }

  network_interface {
    subnetwork = "${var.subnetwork}"
    network_ip = "10.10.0.10"
  }

  service_account {
    email = google_service_account.sa_bastion.email 
    scopes = ["cloud-platform"]
  }  

  tags = ["allow-int-all", "allow-ingress-from-iap"]

  metadata = {
    ssh-keys="root:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/TpS8ZYZBKi9vmrBi4zrpihAQSDOyXRD39H04TU9r1LdRvkWgc+6URv5U+qVJQtEpc8vLjTx0YVkSQxG1qkD5znWz9BcwZW011lYKzmm858uJbBGuc56uRgJBKVtXOqokByLd8poK2ztbdF1+Kj/QfjuuZ/NcAoz1tFUxMMo1nMxAMadRe8jDYZKq1jgbJaO5dP7uxb8WMFYtHIxqjjABJvcK+cpj83K4973gPsVWMVZaM2AY/Wp/QTAQ32sfpgSlfPB130BVb8i0ixDi0DhUahzseTXGLIgST2/LhfRQYsELW5OHzk2nfnP/cAyL1WCV0JVibGyFjEz5d/wS2Wi8y521GOjEEYsPFbhkHEt9JkOMY9TEs5xH1mDFk4tUanbv8p9m846pOEAYJq1FDFkIi/EUaEU03tlioZwUQ+SGwDiWjgN36Mgj72bqIbDdN7YBHOTdKSGAdm+s8si1eFvMfltUZ1QfMge0jFNW+t2wDJ7wlI++b2zdlBu1jyVt0EM= root"
  }
}

