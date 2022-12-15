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
}