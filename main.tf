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
    echo "${file(var.credentials_file)}" > /app-builders/serviceaccount.yaml
    touch /logs-app/teste.txt
    EOF
  }

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