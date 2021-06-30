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
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
# Configure the GitHub Provider, the GITHUB_TOKEN must present as env:variable
provider "github" {}