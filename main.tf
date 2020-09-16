provider "aws" {
  region  = "us-east-1"
  profile = "project-dev"
}

data "terraform_remote_state" "vpc-project-dev" {
  backend = "s3"
  config = {
    bucket  = "project-dev-terraform"
    key     = "vpc-project-dev/vpc-default.tf"
    region  = "us-east-1"
    profile = "project-dev"
  }
}