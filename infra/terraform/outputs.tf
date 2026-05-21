output "acr_login_server" {
  description = "ACR login server URL. Set as ACR_LOGIN_SERVER in GitHub Actions variables."
  value       = module.acr.login_server
}

output "aks_cluster_name" {
  description = "AKS cluster name."
  value       = module.aks.cluster_name
}

output "get_credentials_cmd" {
  description = "Run this after apply to configure kubectl."
  value       = module.aks.get_credentials_cmd
}

output "kube_config_raw" {
  description = "Raw kubeconfig — sensitive."
  value       = module.aks.kube_config_raw
  sensitive   = true
}

output "github_actions_setup" {
  description = "Values to add to GitHub Actions repository variables."
  value       = module.oidc_role.github_secrets_summary
}
