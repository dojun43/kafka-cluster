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

resource "google_compute_address" "kafka-node2-static-ip" {
  name   = "kafka-node2-static-ip"
  project = var.project
  region  = var.region
}

resource "google_compute_address" "kafka-node3-static-ip" {
  name   = "kafka-node3-static-ip"
  project = var.project
  region  = var.region
}



# 방화벽 정책
resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  project = var.project
  network = google_compute_network.kafka_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"] 
  target_tags   = ["allow-ssh"]
}

resource "google_compute_firewall" "allow-kafka-ports" {
  name    = "allow-kafka-ports"
  project = var.project
  network = google_compute_network.kafka_network.name

  allow {
    protocol = "tcp"
    ports    = ["29092", "9000"]
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

resource "google_compute_disk" "kafka-node2-disk" {
  name  = "kafka-node2-disk"
  zone  =  var.zone
  size  = 100 
  type  = "pd-standard"
}

resource "google_compute_disk" "kafka-node3-disk" {
  name  = "kafka-node3-disk"
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

  tags = ["allow-ssh", "allow-kafka-ports"]
}

resource "google_compute_instance" "kafka-node2" {
  name         = "kafka-node2"
  machine_type = "e2-small"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  attached_disk {
    source      = google_compute_disk.kafka-node2-disk.id
    device_name = "kafka-node2-disk"
  }

  network_interface {
    network = google_compute_network.kafka_network.name
    access_config {
      nat_ip = google_compute_address.kafka-node2-static-ip.address
    }
  }

  metadata_startup_script = file("startup_script.sh")

  tags = ["allow-ssh", "allow-kafka-ports"]
}

resource "google_compute_instance" "kafka-node3" {
  name         = "kafka-node3"
  machine_type = "e2-small"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  attached_disk {
    source      = google_compute_disk.kafka-node3-disk.id
    device_name = "kafka-node3-disk"
  }

  network_interface {
    network = google_compute_network.kafka_network.name
    access_config {
      nat_ip = google_compute_address.kafka-node3-static-ip.address
    }
  }

  metadata_startup_script = file("startup_script.sh")

  tags = ["allow-ssh", "allow-kafka-ports"]
}