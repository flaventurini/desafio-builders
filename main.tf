terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  credentials = "${file(var.credentials_file)}"
  
  project = var.project_id
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "log_devsecops_builders" {
  name          = "bucket-devsecops-builders"
  project = var.project_id
  location      = "US"
  storage_class = "COLDLINE"
  force_destroy = true

  uniform_bucket_level_access = true
}

resource "google_compute_instance" "vm_instance" {
  name         = "fventurini-devsecops-builders"
  machine_type = "e2-small"

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20221206"
    }
  }

  network_interface {
    network = "default"
    access_config {

    }
  }

  metadata_startup_script = "sudo apt-get update && sudo apt-get install -y && sudo apt install git-all -y && sudo apt-get install ca-certificates curl gnupg lsb-release -y sudo mkdir /logs-app && sudo mkdir /app-builders && sudo git clone https://github.com/flaventurini/desafio-builders.git /app-builders && sudo chmod u+x /app-builders/install_docker.sh && cd /app-builders/install_docker.sh && ./install_docker.sh && gcloud auth login --cred-file=${file(var.credentials_file)} -y && sudo chmod u+x /app-builders/app/exec_app.sh && sudo crontab /app-builders/app/crontab.txt"

}