data "google_container_engine_versions" "gke_version" {
  location = var.region
  version_prefix = "1.27."
}

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

resource "google_container_cluster" "primary" {
  name     = "gcp-devops-project-gke-cluster"
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = "gcp-devops-project-network"
}


resource "google_container_node_pool" "primary_nodes" {
  name       = google_container_cluster.primary.name
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  
  version = data.google_container_engine_versions.gke_version.release_channel_latest_version["STABLE"]
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    # preemptible  = true
    machine_type = "e2-small"
    disk_size_gb = var.disk_size_gb
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}