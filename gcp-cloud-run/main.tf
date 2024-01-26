terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.0.0"
    }
  }
  backend "local" { }
}

provider "google" {
  project = var.gcp_project_id
  region = var.gcp_region
}

provider "google-beta" {
  region      = var.gcp_region
  project     = var.gcp_project_id
} 
