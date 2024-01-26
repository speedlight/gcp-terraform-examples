# Replace all 'gcpEventFunction' with the name of a working function

variable "gcpEventFunction_env_vars" {
  type    = any
  default = []
}

variable "gcpEventFunction_secrets" {
  type    = any
  default = []
}

data "archive_file" "gcpEventFunction-zip" {
  type             = "zip"
  source_dir       = "../code/nodejs-example-cf/" # replace with the relative path of function's code directory.
  output_path      = "${var.function_zip_path}/gcpEventFunction.zip"
  output_file_mode = "0644"

  excludes = var.function_excludes
}

module "gcpEventFunction" {
  source      = "../modules/gcp-event-function"
  region      = var.gcp_region
  environment = var.environment

  function_name                  = "gcpEventFunction"
  function_runtime               = "nodejs18" # Check https://cloud.google.com/functions/docs/concepts/execution-environment#runtimes for other runtimes.
  function_entrypoint            = "main"
  function_invoker_account       = var.function_invoker_account
  function_labels                = var.function_labels
  function_environment_variables = local.gcpEventFunction_environment_variables
  function_secrets               = var.gcpEventFunction_secrets

  event_trigger_event_type = "providers/google.firebase.database/eventTypes/ref.create"    #Example for firebase DB. Check https://cloud.google.com/functions/docs/calling/ for moe details.
  event_trigger_resource   = "projects/_/instances/${var.gcp_project_id}/refs/users/{uid}" # These two lines are configured depending on the event type.
  event_trigger_retry      = "false"

  depends_on = [data.archive_file.gcpEventFunction-zip]
}
