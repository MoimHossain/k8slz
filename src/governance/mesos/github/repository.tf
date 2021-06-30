data "github_user" "current" {
  username = "moimhossain"
}

resource "github_repository" "moimha" {
  name        = "moimha"
  description = "Kubernetes workload repository"
  visibility  = "public"
  auto_init   = false
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

resource "github_actions_environment_secret" "k8s_token" {
  repository        = github_repository.moimha.name  
  environment       = github_repository_environment.production.environment
  secret_name       = "k8s_token"
  plaintext_value   = filebase64("./kubeconfig")
}