resource "google_compute_instance" "usinstance_1" {
    name         = "usinstance-1"
    machine_type = "e2-micro"
    zone         = var.GCP_ZONE
    can_ip_forward = true
    deletion_protection = false

    boot_disk {
        initialize_params {
        image = "debian-11-bullseye-v20240110"
        size = 50 // Disk size in GB
        type = "pd-standard" // or "pd-ssd" for SSD
        }
        auto_delete = true // Whether the disk will be auto-deleted when the instance is deleted
    }

    network_interface {
        network = google_compute_network.eccnetwork.id
        subnetwork = google_compute_subnetwork.ecc_central_subnet.id

        access_config {
        // Block external access
            nat_ip = null
        }

        alias_ip_range {
            ip_cidr_range = "/24"
            subnetwork_range_name = "secondary-range-name"
        }
    }

    metadata = {
        foo = "bar"
    }

    tags = ["web", "production"]

    service_account {
        email = var.GCP_SERVICE_ACCOUNT
        scopes = ["cloud-platform"]
    }

    scheduling {
        preemptible = false
        on_host_maintenance = "MIGRATE"
        automatic_restart = true
    }

    shielded_instance_config {
        enable_secure_boot = true
        enable_vtpm = true
        enable_integrity_monitoring = true
    }

    # guest_accelerator {
    #     type = "nvidia-tesla-k80"
    #     count = 1
    # }

    # scratch_disk {
    #     interface = "NVME"
    # }

    attached_disk {
        source = google_compute_disk.additional_disk.id
        mode = "READ_WRITE"
        device_name = "extra-disk"
    }

    // Enable the confidential VM feature
    confidential_instance_config {
        enable_confidential_compute = false
    }

    // You can specify labels as key/value pairs
    labels = {
        environment = "production"
        tier = "frontend"
    }

    metadata_startup_script = "echo hello > /test.txt"
}

resource google_compute_subnetwork ecc_central_subnet {
    name = "ecc-us-central1-subnet"
    ip_cidr_range = "10.0.1.0/24"
    region = var.GCP_REGION
    network = google_compute_network.eccnetwork.name
    secondary_ip_range {
        range_name = "secondary-range-name"
        ip_cidr_range = "10.0.2.0/24"
    }
}
    
resource google_compute_subnetwork ecc_west_subnet {
    name = "ecc-us-west1-subnet"
    ip_cidr_range = "10.0.3.0/24"
    region = var.GCP_SECONDDARY_REGION
    network = google_compute_network.eccnetwork.name
    secondary_ip_range {
        range_name = "secondary-range-name"
        ip_cidr_range = "10.0.5.0/24"
    }
}


// Example of additional disks as boot and attached disks
resource "google_compute_disk" "additional_disk" {
    name = "additional-disk"
    type = "pd-ssd"
    zone = var.GCP_ZONE
    image = "debian-11-bullseye-v20240110"
    size = 100
}


#############################################


resource "google_compute_instance_template" "ecctemplate" {
  for_each = toset([var.GCP_REGION, var.GCP_SECONDDARY_REGION])
  disk {
    source_image = "debian-11-bullseye-v20240110"
    auto_delete  = true
  }
  name_prefix   = "ecctemplate-${each.key}"
  machine_type  = "e2-micro"
  can_ip_forward = false

  tags = ["http-server"]

  network_interface {
    network = google_compute_network.eccnetwork.id
    subnetwork = "ecc-${each.key}-subnet"
    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    startup-script-url = "gs://cloud-training/gcpnet/httplb/startup.sh"
  }
}

resource "google_compute_instance_group_manager" "eccmg" {
    for_each = {
        us-central1 = "ecc-template-${var.GCP_REGION}",
        us-west1 = "ecc-template-${var.GCP_SECONDDARY_REGION}"
    }

    name = "ecc-${each.key}-mg"
    version {
        instance_template = google_compute_instance_template.ecctemplate[each.key].self_link
    }
    base_instance_name = "ecc-instance"
    zone = "${each.key}-b"



    # target_pools = [google_compute_target_pool.default.self_link]

    target_size = 2
    update_policy {
        type = "PROACTIVE"
        minimal_action = "REPLACE"
        max_surge_fixed = 1        // Adding this line
        max_unavailable_fixed = 1  // Adding this line
    }
}

# resource "google_compute_targetpool" "default" {
#     name = "ecc-pool"
#     region = var.GCP_REGION
#     instances = [for instance in google_compute_instance_group_manager.eccmg : instance.self_link] 
#     health_check = google_compute_health_check.default.self_link
#     session_affinity = "NONE"

#     depends_on = [google_compute_instance_group_manager.eccmg]
#     lifecycle {
#         create_before_destroy = true
#         ignore_changes = [instances]
#     }
# }

resource "google_compute_health_check" "default" {
  name                 = "ecc-health-check"
  check_interval_sec   = 1
  timeout_sec          = 1
  healthy_threshold    = 1
  unhealthy_threshold  = 1

  http_health_check {
    port = 80
  }
}


resource "google_compute_target_pool" "default" {
    name = "ecc-pool"
    region = var.GCP_REGION
    instances = [for instance in google_compute_instance_group_manager.eccmg : instance.self_link] 
    session_affinity = "NONE"

    depends_on = [google_compute_instance_group_manager.eccmg]
    lifecycle {
        create_before_destroy = true
        ignore_changes = [instances]
    }
}
