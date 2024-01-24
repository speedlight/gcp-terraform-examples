resource "google_artifact_registry_repository" "service_registry" {
  location      = var.gcp_region
  repository_id = var.gcp_run_service_registry
  description   = "Repository for service images"
  format        = "DOCKER"
}

resource "google_service_account" "service_registry_sa" {
  account_id   = var.gcp_run_service_registry_sa
  display_name = "GCP IAM service account to act as uploader of service images"
  depends_on   = [google_artifact_registry_repository.service_registry]
}

resource "google_artifact_registry_repository_iam_member" "service_registry_sa_iam" {
  location   = google_artifact_registry_repository.service_registry.location
  repository = google_artifact_registry_repository.service_registry.repository_id
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.service_registry_sa.email}"
  depends_on = [
    google_artifact_registry_repository.service_registry,
    google_service_account.service_registry_sa
  ]
}
