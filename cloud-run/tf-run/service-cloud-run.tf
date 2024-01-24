resource "google_cloud_run_service" "main" {
  provider = google-beta
  name     = var.gcp_run_service_name
  location = var.gcp_region
  project  = var.gcp_project_id

  template {
    spec {
      containers {
        image = "${var.gcp_region}-docker.pkg.dev/${var.gcp_project_id}/${var.gcp_run_service_registry}/${var.gcp_run_service_name}@${var.run_service_image_digest}"

        dynamic "env" {
          for_each = var.run_service_env_vars
          content {
            name  = env.value["name"]
            value = env.value["value"]
          }
        }

        dynamic "env" {
          for_each = var.run_service_secret_vars
          content {
            name = env.value["name"]
            value_from {
              secret_key_ref {
                name = env.value["secret_id"]
                key  = env.value["version"]
              }
            }
          }
        }

        resources {
          limits = {
            memory = "${var.run_service_memory}"
          }
        }
        ports {
          container_port = var.run_service_port
        }
      }

      timeout_seconds = var.run_service_timeout
    }

    metadata {
      annotations = {
        "name"                                    = "${var.gcp_run_service_name}"
        "run.googleapis.com/startup-cpu-boost"    = "true"
        "autoscaling.knative.dev/maxScale"        = 10
        "run.googleapis.com/vpc-access-connector" = "projects/${var.gcp_project_id}/locations/${var.gcp_region}/connectors/cloudfunction${var.run_service_vpc_connector_postfix}"
        "run.googleapis.com/vpc-access-egress"    = "private-ranges-only"
        "run.googleapis.com/cloudsql-instances"   = "GCP_PROJECT:GCP_REGION:SQL_INSTANCE_NAME"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "member" {
  location = google_cloud_run_service.main.location
  project  = google_cloud_run_service.main.project
  service  = google_cloud_run_service.main.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:cloudrun-invoker@${var.gcp_project_id}.iam.gserviceaccount.com"
}
