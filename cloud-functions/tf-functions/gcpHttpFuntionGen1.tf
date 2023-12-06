# Replace all 'gcpHttpFunctionGen1' occurrecences with the name of a your function

variable "gcpHttpFunctionGen1_env_vars" {
  type    = any
  default = []
}

variable "gcpHttpFunctionGen1_secrets" {
  type    = any
  default = []
}

data "archive_file" "gcpHttpFunctionGen1-zip" {
  type             = "zip"
  source_dir       = "../../code/python-example-cf/" # replace with the relative path of function's code directory.
  output_path      = "${var.function_zip_path}/gcpHttpFunctionGen1.zip"
  output_file_mode = "0644"

  excludes = var.function_excludes
}

module "gcpHttpFunctionGen1" {
  source      = "../modules/gcp-http-function-gen1"
  region      = var.gcp_region
  environment = var.environment

  function_name                  = "gcpHttpFunctionGen1"
  function_runtime               = "python3.10" # Check https://cloud.google.com/functions/docs/concepts/execution-environment#runtimes for other runtimes.
  function_entrypoint            = "main" # Modify to match cloud function entrypoint
  function_invoker_account       = var.function_invoker_account
  function_labels                = var.function_labels
  function_environment_variables = local.gcpHttpFunctionGen1_environment_variables
  function_secrets               = var.gcpHttpFunctionGen1_secrets

  depends_on = [data.archive_file.gcpHttpFunctionGen1-zip]
}
