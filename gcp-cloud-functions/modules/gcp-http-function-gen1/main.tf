resource "google_storage_bucket" "bucket" {
  name      = lower("cf_${var.function_name}_${var.environment}")
  location  =  var.region
  force_destroy = "true"
  
  versioning {
    enabled = "true"
  }
}

resource "google_storage_bucket_object" "function_object" {
  name   = "${var.function_name}.zip"
  bucket = "${google_storage_bucket.bucket.name}"
  source = "${var.function_zip_path}/${var.function_name}.zip"

  depends_on = [ google_storage_bucket.bucket ]
}

resource "google_cloudfunctions_function" "function" {
  name        = var.function_name
  description = var.function_name
  runtime     = var.function_runtime

  available_memory_mb   = var.function_memory
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.function_object.output_name
  trigger_http          = true
  timeout               = var.function_timeout
  entry_point           = "${var.function_entrypoint}"
  
  labels = {
    for l in var.function_labels : l.name => l.value
  }
  
  environment_variables = {
    for v in var.function_environment_variables : v.name => v.value
  }
  
  dynamic "secret_environment_variables" {
    for_each = var.function_secrets == null ? [] : var.function_secrets
    content {
      key = secret_environment_variables.value["key"]
      secret = secret_environment_variables.value["secret_id"]
      version = secret_environment_variables.value["version"]
    }
  }
  
  vpc_connector = var.function_vpc_connector
  
  depends_on = [ google_storage_bucket_object.function_object ]
}

resource "google_cloudfunctions_function_iam_member" "function_invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name
  role   = "roles/cloudfunctions.invoker"
  member = "${var.function_invoker_account}"

  depends_on = [ google_cloudfunctions_function.function ]
}