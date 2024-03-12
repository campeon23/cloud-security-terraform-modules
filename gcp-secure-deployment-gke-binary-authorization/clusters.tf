resource "google_container_cluster" "ecc_binary_authorization" {
  name     = "ecc-binauthz-lab"
  location = var.GCP_ZONE

  // other required cluster configurations...
  // Basic configurations
  initial_node_count = 2
  node_config {
    machine_type = "e2-micro"
    disk_size_gb = 10
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    service_account = var.GCP_SERVICE_ACCOUNT
  }

  // Advanced configurations
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  networking_mode = "VPC_NATIVE"

  network    = google_compute_network.ecc_vpc_network.name
  subnetwork = google_compute_subnetwork.ecc_subnetwork.name
  
  // Binary Authorization
  binary_authorization {
    # evaluation_mode = "policy-bindings-and-project-singleton-policy-enforce"
    evaluation_mode   = "PROJECT_SINGLETON_POLICY_ENFORCE"
  }

  // Network policies
  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  addons_config {
    network_policy_config {
      disabled = false
    }
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.authorized_networks
      content {
        cidr_block = cidr_blocks.key
        display_name = cidr_blocks.value
      }
    }
  }

  // IP Allocation Policy for VPC-native clusters
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods-range"
    services_secondary_range_name = "services-range"
  }

  // Maintenance Policy
  maintenance_policy {
    daily_maintenance_window {
      start_time = "04:00"
    }
  }

  // Logging and Monitoring
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  // Private Cluster Configuration
  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
    master_global_access_config {
      enabled = true
    }
  }

  // Release Channel
  release_channel {
    channel = "REGULAR"
  }

  // Workload Identity
  workload_identity_config {
    workload_pool = "${var.GCP_PROJECT_ID}.svc.id.goog"
  }

  // Vertical Pod Autoscaling
  vertical_pod_autoscaling {
    enabled = true
  }

  // Resource Labels
  resource_labels = {
    env = "production"
  }

  // Database Encryption
  database_encryption {
    state    = "ENCRYPTED"
    key_name = can(data.google_kms_crypto_key.existing_symm_crypto_key[0].id) ? data.google_kms_crypto_key.existing_symm_crypto_key[0].id : can(google_kms_crypto_key.symm_crypto_key[0].id) ? google_kms_crypto_key.symm_crypto_key[0].id : ""
  }

  // Default SNAT status for nodes
  default_snat_status {
    disabled = true
  }

  # // Cluster Telemetry Configuration
  # monitoring_config {
  #     enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  # }

  deletion_protection = false

}

# resource "google_container_node_pool" "pool" {
#   name       = "bin-auth-node-pool"
#   cluster    = google_container_cluster.ecc_binary_authorization.name
#   node_count = 3

#   // Node Pool Management (Auto-Repair and Auto-Upgrade)
#   management {
#     auto_repair  = true
#     auto_upgrade = true
#   }

#   node_config {
#     preemptible  = true
#     machine_type = "e2-micro"

#     tags = ["web-servers", "production"]

#     // other node configurations...
#   }
# }