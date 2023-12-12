resource "google_storage_bucket" "bucket" {
  name          = lower("cf_${var.function_name}_${var.environment}")
  location      = var.region
  force_destroy = "true"

  versioning {
    enabled = "true"
  }
}

resource "google_storage_bucket_object" "function_object" {
  name   = "${var.function_name}.zip"
  bucket = google_storage_bucket.bucket.name
  source = "${var.function_zip_path}/${var.function_name}.zip"

  depends_on = [google_storage_bucket.bucket]
}

resource "google_cloudfunctions2_function" "function" {
  provider = google-beta
  name     = var.function_name
  location = var.region
  project  = var.project_id

  build_config {
    runtime     = var.function_runtime
    entry_point = var.function_entrypoint

    source {
      storage_source {
        bucket = google_storage_bucket.bucket.name
        object = google_storage_bucket_object.function_object.output_name
      }
    }
  }

  service_config {
    max_instance_count               = var.function_max_instances
    min_instance_count               = var.function_min_instances
    max_instance_request_concurrency = var.function_concurrency
    available_memory                 = var.function_memory
    available_cpu                    = var.function_cpu
    timeout_seconds                  = var.function_timeout
    vpc_connector                    = var.function_vpc_connector
    vpc_connector_egress_settings    = var.function_vpc_connector_egress

    environment_variables = {
      for v in var.function_environment_variables : v.name => v.value
    }

    dynamic "secret_environment_variables" {
      for_each = var.function_secrets == null ? [] : var.function_secrets
      content {
        project_id = var.project_id
        key        = secret_environment_variables.value["key"]
        secret     = secret_environment_variables.value["secret_id"]
        version    = secret_environment_variables.value["version"]
      }
    }
  }

  labels = {
    for l in var.function_labels : l.name => l.value
  }

  depends_on = [ google_storage_bucket_object.function_object ]
}

resource "google_cloudfunctions2_function_iam_member" "function_invoker" {
  project        = google_cloudfunctions2_function.function.project
  location       = google_cloudfunctions2_function.function.location
  cloud_function = google_cloudfunctions2_function.function.name
  role           = "roles/cloudfunctions.invoker"
  member         = var.function_invoker_account

  depends_on = [google_cloudfunctions2_function.function]
}
