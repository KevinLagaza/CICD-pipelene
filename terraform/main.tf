provider "google" {
  project     = var.project_id
  region      = var.region
}

# Fetch the secret from Google Secret Manager
data "google_secret_manager_secret_version" "my_secret" {
  secret = "API_KEY" # Replace with your secret name
  version = "1"
}

resource "google_cloud_run_service" "api_fetcher_cb" {
  name     = "api-fetcher-cb"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/${var.project_id}/api-fetcher-cb"
        env {
          name  = "GCS_BUCKET_NAME"
          value = "test-cloud-bucket-build"
        }
        env {
          name  = "API_URL"
          value = "https://jsonplaceholder.typicode.com/posts"
        }
        env {
          name  = "API_KEY"
          value = data.google_secret_manager_secret_version.my_secret.secret_data
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