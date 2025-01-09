resource "google_compute_network" "kafka_network" {
  name = "kafka-network"
}

resource "google_compute_subnetwork" "kafka_subnet" {
  name          = "kafka-subnet"
  region        = var.region
  network       = google_compute_network.kafka_network.name
  ip_cidr_range = "192.168.0.0/24" 
}