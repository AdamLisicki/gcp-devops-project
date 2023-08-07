resource "google_compute_network" "vpc" {
  name                    = "gcp-devops-project-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "gcp-devops-project-network" {
  name          = "gcp-devops-project-network"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.10.0/24"
}

resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "gcp-devops-project"
}

resource "google_container_cluster" "primary" {
  name     = "gcp-devops-project-gke-cluster"
  location = var.zone

  min_master_version       = var.cluster_version
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = "gcp-devops-project-network"
}


resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes
  version    = var.cluster_version

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels = {
      env = var.project_id
    }

    service_account = google_service_account.default.email
    image_type      = "COS"
    machine_type    = var.machine_type
    disk_size_gb    = var.disk_size_gb
    disk_type       = var.disk_type
    preemptible     = false
    tags         = [
      "gke-node",
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}