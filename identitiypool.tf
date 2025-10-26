resource "google_iam_workload_identity_pool" "aws_pooll" {
  workload_identity_pool_id = "aws-pooll"
  display_name              = "AWS Workload Identity Pool"
  description               = "Allows AWS account to access GCP"
}

resource "google_iam_workload_identity_pool_provider" "aws_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.aws_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "aws-provider"
  display_name                       = "AWS Provider"
  description                        = "Trust AWS IAM role"

  aws {
    account_id = "my-project-mohammad-476307"
  }
}

