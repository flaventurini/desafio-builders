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
variable "region" {
  description = "Region for the Compute Engine and KMS key"
  type = string
  default = "us-central1"
}
