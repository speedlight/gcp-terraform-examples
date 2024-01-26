# Replace all 'gcpHttpFunctionGen2' occurrecences with the name of a your function

variable "gcpHttpFunctionGen2_env_vars" {
  type    = any
  default = []
}

variable "gcpHttpFunctionGen2_secrets" {
  type    = any
  default = []
}

data "archive_file" "gcpHttpFunctionGen2-zip" {
  type             = "zip"
  source_dir       = "../code/nodejs-example-cf/" # replace with the relative path of function's code directory.
  output_path      = "${var.function_zip_path}/gcpHttpFunctionGen2.zip"
  output_file_mode = "0644"

  excludes = var.function_excludes
}

module "gcpHttpFunctionGen2" {
  source      = "../modules/gcp-http-function-gen2"
  project_id = var.gcp_project_id
  region      = var.gcp_region
  environment = var.environment

  function_name                  = "gcpHttpFunctionGen2"
  function_runtime               = "nodejs18" # Check https://cloud.google.com/functions/docs/concepts/execution-environment#runtimes for other runtimes.
  function_entrypoint            = "main" # Modify to match cloud function entrypoint
  function_invoker_account       = var.function_invoker_account
  function_labels                = var.function_labels
  function_environment_variables = local.gcpHttpFunctionGen2_environment_variables
  function_secrets               = var.gcpHttpFunctionGen2_secrets

  depends_on = [data.archive_file.gcpHttpFunctionGen2-zip]
}
