# Basic Network Firewall Rules | network-firewall.tf  

# Allow http
resource "google_compute_firewall" "allow-http" {
  name    = "${var.app_name}-${var.app_environment}-fw-allow-http"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["4440"]
  }
  target_tags = ["iap-rundeck"]
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
}

# allow ssh
resource "google_compute_firewall" "allow-ssh" {
  name    = "${var.app_name}-${var.app_environment}-fw-allow-ssh"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["iap-ssh"]
  source_ranges = ["35.235.240.0/20"]

}
