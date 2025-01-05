# VPC 생성
resource "google_compute_network" "kafka_network" {
  name = "kafka-network"
}

# 고정 ip
resource "google_compute_address" "kafka-node1-static-ip" {
  name   = "kafka-node1-static-ip"
  project = var.project
  region  = var.region
}

# 방화벽 정책
resource "google_compute_firewall" "allow-kafka-ports" {
  name    = "allow-kafka-ports"
  project = var.project
  network = google_compute_network.kafka_network.name

  allow {
    protocol = "tcp"
    ports    = ["2181", "9092", "9000"]
  }

  source_ranges = ["0.0.0.0/0"] 
  target_tags   = ["allow-kafka-ports"]
}

# disk
resource "google_compute_disk" "kafka-node1-disk" {
  name  = "kafka-node1-disk"
  zone  =  var.zone
  size  = 100 
  type  = "pd-standard"
}

# VM
resource "google_compute_instance" "kafka-node1" {
  name         = "kafka-node1"
  machine_type = "e2-small"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  attached_disk {
    source      = google_compute_disk.kafka-node1-disk.id
    device_name = "kafka-node1-disk"
  }

  network_interface {
    network = google_compute_network.kafka_network.name
    access_config {
      nat_ip = google_compute_address.kafka-node1-static-ip.address
    }
  }

  metadata_startup_script = file("startup_script.sh")

  tags = ["allow-kafka-ports"]
}