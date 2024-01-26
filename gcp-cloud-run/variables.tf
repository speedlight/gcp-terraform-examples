variable "environment" {
  type = string
}

variable "gcp_project_id" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "gcp_run_service_name" {
  type = string 
}

variable "gcp_run_service_registry" {
  type = string 
}

variable "gcp_run_service_registry_sa" {
  type = string 
}
  
variable "run_service_env_vars" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "run_service_secret_vars" {
  type = list(object({
    name = string
    secret_id = string
    version = string
  }))
  default = []
}

variable "run_service_image_digest" {
  type = string 
}

variable "run_service_vpc_connector_postfix" {
  type = string
}

variable "run_service_memory" {
  type = string
}

variable "run_service_port" {
  type = string
}

variable "run_service_timeout" {
  type = string
}