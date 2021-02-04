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


resource "google_compute_address" "app_private_ip" {
  name         = "dgb-${var.app_name}-${var.app_environment}-1-private-ip"
  subnetwork   = google_compute_subnetwork.private_subnet_1.self_link
  address_type = "INTERNAL"
  region       = var.gcp_region_1
}

resource "google_compute_instance" "app" {
  project      = var.app_project
  name         = "dgb-${var.app_name}-${var.app_environment}-1"
  machine_type = "e2-small"
  zone         = data.google_compute_zones.available.names[0]
  hostname     = "dgb-${var.app_name}-${var.app_environment}-1.${var.app_domain}"
  tags         = ["iap-ssh","iap-rundeck"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  #metadata_startup_script = file("scripts/app_startup_script.sh")
  metadata_startup_script = templatefile("scripts/app_startup_script.sh",
    {
      db_host = google_sql_database_instance.mysql_rundeck.ip_address.0.ip_address,
      server_name = "dgb-${var.app_name}-${var.app_environment}-1",
      server_hostname = "dgb-${var.app_name}-${var.app_environment}-1.${var.app_domain}"
    }
  )

  network_interface {
    subnetwork = google_compute_subnetwork.private_subnet_1.name
    network_ip = google_compute_address.app_private_ip.address
  }

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

output "app-name" {
  value = google_compute_instance.app.name
}

output "app-internal-ip" {
  value = google_compute_instance.app.network_interface.0.network_ip
}
