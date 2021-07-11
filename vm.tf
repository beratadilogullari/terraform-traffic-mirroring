# Terraform plugin for creating random value
resource "random_id" "instance_id" {
  byte_length = 4
}

# Create VM IDS Instance Template
resource "google_compute_instance_template" "ids-vm-mig-template" {
  name        = var.instance_template_name
  description = "This template is used to create ids instance."
  region = var.gcp_region_1
  machine_type         = "e2-medium"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image      = "ubuntu-os-cloud/ubuntu-1804-lts"
    auto_delete       = true
    boot              = true
    disk_size_gb = 30
  }

  network_interface {
    network = var.ids_network
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    scopes = ["cloud-platform"]
  }
}

# Create VM IDS Instance from that Template will be manual because API tries to create an external IP Address.

resource "google_compute_instance_group_manager" "compute" {
  name = "ids-mig-compute"
  description = "compute VM IDS Instance Group"

  base_instance_name = var.instance_template_name

  instance_template = "${google_compute_instance_template.compute.self_link}"

  zone = var.gco_zone_1

  update_strategy = "RESTART"

  target_size = 1

}
