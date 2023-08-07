terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.76.0"
    }
  }

  required_version = "~> 1.4.5"

  backend "http" {
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}