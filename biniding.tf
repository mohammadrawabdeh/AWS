resource "google_project_iam_binding" "aws_readonly_binding" {
  project = "my-project-mohammad-476307"
  role    = "projects/my-project-mohammad-476307/roles/readonlyAccessRole"

  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.aws_pool.name}/attribute.aws_role/arn:aws:sts::926837946404:assumed-role/AWStoGCP"
  ]
}

