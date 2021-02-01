# # Create Google Cloud VMs | vm.tf

# # Create web server #1
# resource "google_compute_instance" "web_private_1" {
#   name         = "dgb-${var.app_name}-${var.app_environment}-1"
#   machine_type = "e2-small"
#   zone         = var.gcp_zone_1
#   hostname     = "dgb-${var.app_name}-${var.app_environment}-1.${var.app_domain}"
#   tags         = ["ssh","http"]

#   boot_disk {
#     initialize_params {
#       image = "ubuntu-os-cloud/ubuntu-1804-lts"
#     }
#   }

#   metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential apache2"

#   network_interface {
#     network       = google_compute_network.vpc.name
#     subnetwork    = google_compute_subnetwork.private_subnet_1.name
#   }
# } 


resource "google_compute_instance" "app" {
  project      = var.project
  name         = "dgb-${var.app_name}-${var.app_environment}-1"
  machine_type = "e2-small"
  zone         = data.google_compute_zones.available.names[0]
  hostname     = "dgb-${var.app_name}-${var.app_environment}-1.${var.app_domain}"
  tags         = ["ssh","http"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  metadata_startup_script = file("scripts/app_startup_script.sh")

  network_interface {
    network       = google_compute_network.vpc.name
    subnetwork    = google_compute_subnetwork.private_subnet_1.name
  }
}
