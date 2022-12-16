variable "credentials_file" {
  description = "Credenciais do Projeto"
  type        = string
  default     = "serviceaccount.yaml"
}

variable "project_id" {
  description = "Id do Projeto"
  type        = string
  default     = "teste-devsecops-builders" // substituir pelo id do projeto criado no GCP
}

variable "network_name" {
  description = "Nome da Rede"
  type        = string
  default     = "terraform-network"
}
variable "region" {
  description = "Região do Compute Engine"
  type = string
  default = "us-central1"
}
