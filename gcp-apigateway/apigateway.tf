resource "google_api_gateway_api" "apigw" {
  provider     = google-beta
  api_id       = var.gcp_apigw_id
  display_name = var.gcp_apigw_display_name
}

resource "local_file" "spec" {
      content = templatefile("templates/apigw-spec.tftpl", {
        apigw_url = "${var.gcp_apigw_url}"
        apigw_run_url = "${var.gcp_apigw_run_url}"
        apigw_project_id = "${var.gcp_project_id}"        
      })
      filename = "envs/${var.environment}/spec.yaml"
}

resource "google_api_gateway_api_config" "api_gw" {
  provider     = google-beta
  api          = google_api_gateway_api.api_gw.api_id
  display_name = "${var.gcp_apigw_display_name} Config"

  openapi_documents {
    document {
      path     = "spec.yaml"
      contents = filebase64("envs/${var.environment}/spec.yaml")
    }
  }

  lifecycle {
    create_before_destroy = true
  }
  
  depends_on = [ local_file.spec ]
}

resource "google_api_gateway_gateway" "api_gw" {
  provider   = google-beta
  api_config = google_api_gateway_api_config.api_gw.id
  gateway_id = var.gcp_apigw_id
}
