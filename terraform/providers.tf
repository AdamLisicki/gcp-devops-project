terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.76.0"
    }
  }

  required_version = "~> 1.5.4"

  backend "http" {
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}