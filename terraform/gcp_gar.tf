# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository

resource "google_artifact_registry_repository" "gar_containers" {
  location      = var.gcp_region
  repository_id = "containers-${var.humanitec_env_type}"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_member" "gar_containers_reader" {
  location    = google_artifact_registry_repository.gar_containers.location
  repository  = google_artifact_registry_repository.gar_containers.name
  role        = "roles/artifactregistry.reader"
  member      = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_service_account" "gar_writer_access" {
  account_id    = "gar-${var.humanitec_env_type}-access"
  description   = "Account used by GitHub actions to push container images."
}

resource "google_artifact_registry_repository_iam_member" "gar_containers_writer" {
  location    = google_artifact_registry_repository.gar_containers.location
  repository  = google_artifact_registry_repository.gar_containers.name
  role        = "roles/artifactregistry.writer"
  member      = "serviceAccount:${google_service_account.gar_writer_access.email}"
}

resource "google_service_account_key" "gar_writer_access_key" {
  service_account_id = google_service_account.gar_writer_access.name
}