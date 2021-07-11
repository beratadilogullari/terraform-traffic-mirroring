# define the GCP authentication file
variable "gcp_auth_file" {
  type = string
  description = "GCP authentication file"
}
# define the Project ID
variable "project_id" {
  type = string
  description = "GCP authentication file"
}
# define GCP project name
variable "app_project" {
  type = string
  description = "GCP project name"
}
# define GCP region
variable "gcp_region_1" {
  type = string
  description = "GCP region"
}
# define GCP zone
variable "gcp_zone_1" {
  type = string
  description = "GCP zone"
}
# define Public subnet
variable "public_subnet_cidr_1" {
  type = string
  description = "Public subnet CIDR 1"
}
# define IDS Network
variable "ids_network" {
  type = string
  description = "IDS Network"
}
# define the Instance Template Name
variable "instance_template_name" {
  type = string
  description = "GCP authentication file"
}
