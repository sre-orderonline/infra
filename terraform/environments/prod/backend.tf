terraform {
  backend "gcs" {
    bucket = "orderonline-terragrunt-tfstate"
    prefix = "terraform/env/prod"
  }
}