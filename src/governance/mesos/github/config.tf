# Make sure az cli login before this.

terraform {
  backend "azurerm" {
    resource_group_name  = "azure-ad-b2x-demo"
    storage_account_name = "aadb2x"
    container_name       = "k8s-github-governance"
    key                  = "prod.mesos.tfstate"
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