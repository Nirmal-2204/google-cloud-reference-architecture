terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
    }

    random = {
      source  = "hashicorp/random"
    }
  }
}

provider "google" {
  project     = var.project_id
  credentials = var.credentials

  default_labels = {
    "hum-gsa"       = var.gsa_email
  }
}