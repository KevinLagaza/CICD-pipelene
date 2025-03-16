provider "google" {
  project     = "constant-host-448316-e1"
  region      = "us-central1"
}

resource "google_cloud_run_service" "api_fetcher_cb" {
  name     = "api-fetcher-cb"
  location = "us-central1"
  lifecycle {
    create_before_destroy = false
  }

  template {
    spec {
      containers {
        image = "gcr.io/constant-host-448316-e1/api-fetcher-cb"
        env {
          name  = "GCS_BUCKET_NAME"
          value = "test-cloud-bucket-build"
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "public_access" {
  service  = google_cloud_run_service.api_fetcher_cb.name
  location = google_cloud_run_service.api_fetcher_cb.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "service_url" {
  value = google_cloud_run_service.api_fetcher_cb.status[0].url
}