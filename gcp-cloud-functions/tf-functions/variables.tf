variable "environment" {
  type = string
}

variable "gcp_project_id" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "function_zip_path" {
  description = "Local path for function's tarball"
  type = string
  default = "/tmp"
}

variable "function_excludes" {
  description = "Files to exclude from zip generation. In this case as example for a nodejs function"
  type = any
  default = [
    "__tests__", 
    "README.md", 
    "CHANGELOG.md", 
    "jest.config.js",
    "node_modules",
  ]
}
variable "function_labels" {
  type = any
  default = [
   { "name": "project", "value": "awesome-project" },
   { "name": "deployer-tool", "value": "terraform" },
  ]
}

variable "function_vpc_connector_postfix" {
  type = string
}

variable "default_environment_variables" {
  type = any
  default = []
}
 
variable "function_invoker_account" {
description = "Account or value for authentication invokation. Check https://cloud.google.com/functions/docs/securing/managing-access-iam for more information"
  type = string
  default = "allUsers"
}