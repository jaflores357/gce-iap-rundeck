resource "google_compute_global_address" "mysql_private_ip" {
  provider = google-beta

  name          = "mysql-rundeck-private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider                = google-beta
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.mysql_private_ip.name]
}

resource "random_id" "mysql_password" {
  byte_length = 8
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "mysql_rundeck" {
  provider         = google-beta

  name             = "dgb-mysql-rundeck-${random_id.db_name_suffix.hex}"
  region           = var.gcp_region_1
  database_version = "MYSQL_5_7"
  root_password    = random_id.mysql_password.hex

  depends_on       = [google_service_networking_connection.private_vpc_connection]
  deletion_protection = false
  settings {
    tier = "db-f1-micro"
    
    backup_configuration {
      binary_log_enabled = true
      enabled = true
      start_time = "00:00"
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc.id
    }
  }
}

resource "google_sql_database" "db_rundeck_database" {
  name      = "rundeck"
  instance  = google_sql_database_instance.mysql_rundeck.name
  charset   = "latin1"
}

resource "google_sql_user" "db_rundeck_user" {
  name     = "rundeck"
  instance = google_sql_database_instance.mysql_rundeck.name
  host     = "%"
  password = "rundeck"
}

output db_instance_address {
  description = "IP address of the master database instance"
  value = google_sql_database_instance.mysql_rundeck.ip_address.0.ip_address
}

output db_instance_name {
  description = "Name of the database instance"
  value = google_sql_database_instance.mysql_rundeck.name
}

output db_instance_generated_user_password {
  description = "Root mysql passowrd"
  value = random_id.mysql_password.hex
}