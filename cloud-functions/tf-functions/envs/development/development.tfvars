environment = "development"
gcp_region = "us-central1"
gcp_project_id = "my-gcp-project-id"
function_vpc_connector_postfix = "-dev"

# This environment variables will be added on all functions.
default_environment_variables = [
  { "name": "NODE_ENV", "value": "development" },
  { "name": "SOME_ENV", "value": "my_env_var_value" },
]

gcpEventFunction_env_vars = [
  { "name": "FUNCTION_ENV", "value": "some-value" },
]
gcpEventFunction_secrets = [
  {
    key       = "FUNCTION_SECRET"
    secret_id = "secret_name" # The name of the secret on GCP Secret Manager.
    version   = "latest" # Could also point to a specific version number.
  },
]

gcpHttpFunctionGen1_env_vars = [
  { "name": "FUNCTION_ENV", "value": "some-value" },
]
gcpHttpFunctionGen1_secrets = [
  {
    key       = "FUNCTION_SECRET"
    secret_id = "secret_name" # The name of the secret on GCP Secret Manager.
    version   = "1" # Could also use latest.
  },
]