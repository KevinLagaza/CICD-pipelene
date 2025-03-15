provider "google" {
  project     = "constant-host-448316-e1"
  region      = "us-central1"
}

resource "google_cloud_run_service" "api_fetcher" {
  name     = "api-fetcher"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/constant-host-448316-e1/api-fetcher"
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
  service  = google_cloud_run_service.api_fetcher.name
  location = google_cloud_run_service.api_fetcher.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "service_url" {
  value = google_cloud_run_service.api_fetcher.status[0].url
}