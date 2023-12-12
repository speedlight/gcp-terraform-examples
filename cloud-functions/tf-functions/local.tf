locals {
  # Get default environment variables and combine them with per function's environment variables.

  gcpHttpFunctionGen1_environment_variables  = distinct(concat(var.default_environment_variables, var.gcpHttpFunctionGen1_env_vars))
  gcpEventFunction_environment_variables  = distinct(concat(var.default_environment_variables, var.gcpEventFunction_env_vars))
  gcpHttpFunctionGen2_environment_variables  = distinct(concat(var.default_environment_variables, var.gcpHttpFunctionGen2_env_vars))
}
