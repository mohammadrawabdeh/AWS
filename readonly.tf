terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "my-project-mohammad-476307"
  region  = "us-west4"
}

resource "google_iam_custom_role" "readonly_access_role" {
  role_id     = "readonlyAccessRole"
  title       = "ReadOnly Access Role"
  description = "Custom role granting read-only access to view resources."
  stage       = "GA"

  permissions = [
    "resourcemanager.projects.get",
    "compute.instances.get",
    "compute.instances.list",
    "compute.disks.get",
    "compute.disks.list",
    "storage.buckets.get",
    "storage.buckets.list",
    "storage.objects.get",
    "storage.objects.list",
    "iam.roles.get",
    "iam.roles.list",
    "iam.serviceAccounts.get",
    "iam.serviceAccounts.list",
    "cloudkms.keyRings.get",
    "cloudkms.keyRings.list",
    "cloudkms.cryptoKeys.get",
    "cloudkms.cryptoKeys.list",
    "monitoring.metricDescriptors.list",
    "monitoring.timeSeries.list",
    "logging.logEntries.list",
    "logging.sinks.list"
  ]
}

