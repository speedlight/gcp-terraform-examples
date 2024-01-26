variable "region" {
  description = "The region of the gcp project"
  type        = string
}

variable "event_trigger_event_type" {
  description = "Event type for event trigger"
  type        = string
}

variable "event_trigger_resource" {
  description = "Resource for event trigger"
  type        = string
}

variable "event_trigger_retry" {
  description = "Failure Policy for retry on failure"
  type        = string
}

variable "environment" {
  type = string
}

variable "function_name" {
  type = string
}

variable "function_runtime" {
  description = "The version of the runtime. Check https://cloud.google.com/functions/docs/runtime-support"
  type        = string
}

variable "function_entrypoint" {
  type = string
}

variable "function_invoker_account" {
  description = "The service account that will invoke the cloud function. Ensure that have the cloudfunctions.invoker role"
  type        = string
}

variable "function_memory" {
  type    = string
  default = 256
}

variable "function_timeout" {
  type    = string
  default = 60
}

variable "function_max_instances" {
  description = "Number to max instances, 3000 is the maximum value supported by GCP"
  type        = string
  default     = 3000
}

variable "function_zip_path" {
  description = "The local path where to create the zipfile of the function"
  type        = string
  default     = "/tmp"
}

variable "function_labels" {
  type = list(object({
    name  = string,
    value = string
  }))
}

# Environment variables to be added at runtime.
variable "function_environment_variables" {
  type = any
}

# Secret references stored on GCP Secret Manager
variable "function_secrets" {
  type = list(object({
    key       = string,
    secret_id = string,
    version   = string
    }
  ))
}
