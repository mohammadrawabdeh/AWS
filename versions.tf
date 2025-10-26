terraform {
  required_version = ">= 1.4.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0"
    }
  }
}

provider "google" {
  project     = "my-project-mohammad-476307"
  region      = "us-west4"
  credentials = file("my-project-mohammad-476307-339d242880fc.json")
}

