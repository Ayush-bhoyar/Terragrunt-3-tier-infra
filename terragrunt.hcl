locals {
  region = "us-east-1"
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "my-ayuush-terraform-state-bucket"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
    dynamodb_table = "ayush-terraform-lock"
    encrypt        = true
  }
}

generate "provider" {
  path      = "provider_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = "~>1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~>3.0"
    }
  }
}
EOF
}
