environment    = "development"
gcp_region     = "us-west2"
gcp_project_id = "my-awesome-project"

gcp_run_service_name        = "my-project"
gcp_run_service_registry    = "my-project-image-registry-development"
gcp_run_service_registry_sa = "my-project-pusher-dev"

run_service_vpc_connector_postfix = "-dev"
run_service_memory      = 1024
run_service_port        = 5000
run_service_timeout     = 60

run_service_env_vars = [
  { "name" : "MY_VAR", "value" : "1" },
  { "name" : "ANOTHER_VAR", "value" : "foobar" },
]
