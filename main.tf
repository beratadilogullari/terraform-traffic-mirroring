provider "google" {
  credentials = file(var.gcp_auth_file)
  project = var.app_project
  region = var.gcp_region_1
  zone = var.gcp_zone_1
}

provider "google-beta" {
  credentials = file(var.gcp_auth_file)
  project = var.app_project
  region = var.gcp_region_1
  zone = var.gcp_zone_1
}

