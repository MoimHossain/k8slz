# Following environment values are set 
# ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_SUBSCRIPTION_ID, ARM_TENANT_ID 

terraform {
  backend "azurerm" {
    resource_group_name  = "azure-ad-b2x-demo"
    storage_account_name = "aadb2x"
    container_name       = "terraformgovernance"
    key                  = "prod.terraform.tfstate"
  }
}

terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

# Configure the GitHub Provider
provider "github" {}

data "github_user" "current" {
  username = "moimhossain"
}

resource "github_repository" "moimha" {
  name        = "moimha"
  description = "Kubernetes workload repository"
  visibility  = "public"
  auto_init   = true
}

resource "github_repository_environment" "production" {
  environment   = "Production"
  repository    = github_repository.moimha.name
  reviewers {
    users = [data.github_user.current.id]
  }
  deployment_branch_policy {
    protected_branches      = true
    custom_branch_policies  = false
  }
}