provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# 1. Create a GCP Service Account
resource "google_service_account" "aws_readonly_sa" {
  account_id   = "aws-readonly-sa"
  display_name = "AWS Read-only Access Service Account"
}

# 2. Assign Viewer role to service account (read-only)
resource "google_project_iam_member" "readonly_binding" {
  project = var.gcp_project_id
  role    = "roles/viewer"
  member  = "serviceAccount:${google_service_account.aws_readonly_sa.email}"
}

# 3. Create a Workload Identity Pool
resource "google_iam_workload_identity_pool" "aws_pool" {
  workload_identity_pool_id = "aws-pool-new"
  display_name              = "AWS Workload Identity Pool"
  description               = "Pool to allow AWS access to GCP"
}

# 4. Create AWS Provider for the Pool
resource "google_iam_workload_identity_pool_provider" "aws_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.aws_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "aws-provider"
  display_name                       = "AWS Provider"
  description                        = "Provider for AWS account"

  aws {
    account_id = var.aws_account_id
  }

  attribute_mapping = {
    "google.subject"     = "assertion.arn"
    "attribute.aws_role" = "assertion.arn"
  }

  attribute_condition = "assertion.arn.startsWith('arn:aws:sts::${var.aws_account_id}:assumed-role/${var.aws_role_name}')"
}

# 5. Allow AWS role to impersonate the Service Account
resource "google_service_account_iam_binding" "aws_impersonate" {
  service_account_id = google_service_account.aws_readonly_sa.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.aws_pool.name}/attribute.aws_role/arn:aws:iam::${var.aws_account_id}:role/${var.aws_role_name}"
  ]
}

# Outputs
output "workload_identity_pool_id" {
  value = google_iam_workload_identity_pool.aws_pool.workload_identity_pool_id
}

output "wif_provider_name" {
  value = google_iam_workload_identity_pool_provider.aws_provider.name
}

output "gcp_service_account_email" {
  value = google_service_account.aws_readonly_sa.email
}

# Variables
variable "gcp_project_id" {
  type    = string
  default = "my-project-mohammad-476307"
}

variable "gcp_region" {
  type    = string
  default = "us-central1"
}

variable "aws_account_id" {
  type    = string
  default = "926837946404"
}

variable "aws_role_name" {
  type    = string
  default = "MyGCPfunction-role-6rkmwl64"
}
