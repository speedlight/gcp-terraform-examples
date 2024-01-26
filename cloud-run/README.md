# Terraform GCP Cloud Run provisioning

An opinionated terraform sample project to provision GCP cloud run services.

To provision the run service set service name on the `gcp_run_service_name` variable and the rest of values on `envs/development.tfvars` file.

The project will create a Docker registry on the Google Artifact Registry as well as a IAM service account with the `roles/artifactregistry.writer` role in order to upload the images.