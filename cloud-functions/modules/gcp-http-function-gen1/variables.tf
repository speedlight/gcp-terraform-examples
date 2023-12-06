variable "region" {
  description = "The region of the gcp project"
  type = string
}

variable "environment" {
  description = "Development or production"
  type = string
}

variable "function_name" {
  description = "The name of the cloud function"
  type = string
}

variable "function_runtime" {
  description = "The version of the runtime. Check https://cloud.google.com/functions/docs/runtime-support"
  type = string
}

variable "function_entrypoint" {
  description = "The code that will be executed when function run"
  type = string
}

variable "function_invoker_account" {
  description = "The service account that will invoke the cloud function. Ensure that have the cloudfunctions.invoker role"
  type = string
}

variable "function_memory" {
  description = "The amount of memory available for the function container"
  type = string
  default = 256
}

variable "function_timeout" {
  description = "The number of seconds for the function to wait"
  type = string
  default = 60
}

variable "function_zip_path" {
  description = "The local path where to create the zipfile of a function code"
  type = string
  default = "/tmp"
}

variable "function_labels" {
  description = "Labels list to add to cloud functions."
  type = list(object({
    name = string,
    value = string
  }))
}

variable "function_environment_variables" {
  type = any 
  default = []
}

variable "function_secrets" {
  type = list(object({
    key = string, 
    secret_id = string,
    version = string
    }
  ))
}

variable "function_vpc_connector" {
  type = string
  default = ""
}