
# Create subnet for the IDS
resource "google_compute_subnetwork" "default" {
  provider = google-beta
  name          = "deneme-subnet-terraform" #name of your subnet
  ip_cidr_range = var.public_subnet_cidr_1
  region        = var.gcp_region_1
  network       = "default"
  secondary_ip_range = [ {
    ip_cidr_range = "10.11.1.0/24"
    range_name = "deneme-subnet-terraform-2"
  } ]
}


# Create firewall rules and Cloud NAT
# 1 allows the standard http port (TCP 80) and the ICMP protocol to all VMs from all sources.

resource "google_compute_firewall" "firewall-1" {
  name    = "allow-any-web"
  network = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  direction = "INGRESS"
  priority = 1000
  source_ranges = [ "0.0.0.0/0" ]
}

# 2 allows the IDS to receive ALL traffic from ALL sources.
resource "google_compute_firewall" "firewall-2" {
  name    = "ids-any-any"
  network = "default"

  allow {
    protocol = "all"
  }

  priority = 1000
  direction = "INGRESS"
  source_ranges = [ "0.0.0.0/0" ]
  source_tags = [ "ids" ]
}

# 3 allows the "GCP IAP Proxy" IP range TCP port 22 to ALL VMs, 
# enabling you to ssh into the VMs via the Cloud Console.
resource "google_compute_firewall" "firewall-3" {
  name    = "aipproxy-firewall"
  network = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  priority = 1000
  direction = "INGRESS"
  source_ranges = [ "35.235.240.0/20" ]
}


# Create a Cloud Router

resource "google_compute_router" "foobar" {
  name    = "terraform-router"
  network = "default"
  region = var.gcp_region_1
  # set bgp variables if needed.
  
    bgp {
    asn               = 64514
    advertise_mode    = "CUSTOM"
    advertised_groups = ["ALL_SUBNETS"]
    advertised_ip_ranges {
      range = "1.2.3.4"
    }
    advertised_ip_ranges {
      range = "6.7.0.0/16"
    } 
  } 

} 

# Create a Cloud NAT

module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 1.2"
  project_id = var.project_id
  region     = var.gcp_region_1
  router     = "terraform-router"
  # nat_ip_allocate_option = TRUE
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
} 
