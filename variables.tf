variable "credentials_file" {
  description = "Id do Projeto"
  type        = string
  default     = "serviceaccount.yaml"
}

variable "project_id" {
  description = "Id do Projeto"
  type        = string
  default     = "fventurini-devsecops-builders" // substituir pelo id do projeto criado no GCP
}

variable "network_name" {
  description = "Nome da Rede"
  type        = string
  default     = "terraform-network"
}

variable "key_name" {
  description = "Name of the KMS key"
  type = string
  default = "crypto-builders"
}

variable "keyring_name" {
  description = "Name of the KMS Keyring"
  type = string
  default = "builders_keyring_central1"
}

variable "algorithm" {
  description = "Algorithm for the KMS key"
  type = string
  default = "GOOGLE_SYMMETRIC_ENCRYPTION"
}

variable "region" {
  description = "Region for the Compute Engine and KMS key"
  type = string
  default = "us-central1"
}

variable "rotation_period" {
  description = "Time in seconds to rotate key"
  type = string
  default = "2592000s" //30 days [its the default]
}

