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
  region  = var.region
  zone    = "us-central1-c"
}

data "google_project" "project" {
  project_id = var.project_id
}

output "project_number" {
  value = data.google_project.project.number
}

resource random_id crypto_key_name_suffix {
  byte_length = 8
}

resource "google_kms_key_ring" "keyring" {
  name = "${var.keyring_name}-${random_id.crypto_key_name_suffix.hex}"
  location = var.region
}

resource "google_kms_crypto_key" "key" {
  name = "${var.key_name}-${random_id.crypto_key_name_suffix.hex}"
  key_ring = google_kms_key_ring.keyring.id
  rotation_period = var.rotation_period
  
  version_template {
    algorithm = var.algorithm
  }
  
  lifecycle {
    prevent_destroy = false
  }
}

resource "google_kms_crypto_key_iam_binding" "crypto_key" {
  crypto_key_id = google_kms_crypto_key.key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members       = [
     "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com",
     "serviceAccount:${var.project_id}@${var.project_id}.iam.gserviceaccount.com",
  ]
}

resource "google_storage_bucket" "log_devsecops_builders" {
  name          = "bucket-devsecops-builders"
  project = var.project_id
  location      = "US"
  storage_class = "COLDLINE"
  force_destroy = true

  uniform_bucket_level_access = true

  encryption {
    default_kms_key_name = google_kms_crypto_key.key.id
  }

  depends_on = [google_kms_crypto_key_iam_binding.crypto_key]
}

resource "google_compute_instance" "vm_instance" {
  name         = "fventurini-devsecops-builders"
  machine_type = "e2-small"
  metadata = {
    startup-script = <<-EOF
    sudo apt-get update && sudo apt-get install -y
    sudo apt install git-all -y
    sudo apt-get install ca-certificates curl gnupg lsb-release -y 
    sudo mkdir /logs-app && sudo mkdir /app-builders 
    sudo git clone https://github.com/flaventurini/desafio-builders.git /app-builders 
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
    sudo chmod u+x /app-builders/app/exec_app.sh
    sudo chmod u+x /app-builders/app/bucket.sh
    crontab /app-builders/app/crontab.txt
    sudo touch /app-builders/serviceaccount.yaml
    EOF
  }

  boot_disk {

    kms_key_self_link = google_kms_crypto_key.key.id
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