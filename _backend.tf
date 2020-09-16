terraform {
  backend "s3" {
    bucket  = "project-dev-terraform"
    key     = "ecs-project-dev/ecs-default.tf"
    region  = "us-east-1"
    profile = "project-dev"
  }
}