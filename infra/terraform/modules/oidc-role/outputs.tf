output "ci_client_id" {
  description = "Client ID of the CI managed identity. Set as AZURE_CLIENT_ID in GitHub Actions ci.yml."
  value       = azurerm_user_assigned_identity.ci.client_id
}

output "terraform_client_id" {
  description = "Client ID of the Terraform managed identity. Set as AZURE_CLIENT_ID in GitHub Actions terraform.yml."
  value       = azurerm_user_assigned_identity.terraform.client_id
}

output "tenant_id" {
  description = "Azure tenant ID. Set as AZURE_TENANT_ID in both GitHub Actions workflows."
  value       = data.azurerm_client_config.current.tenant_id
}

output "subscription_id" {
  description = "Azure subscription ID. Set as AZURE_SUBSCRIPTION_ID in both GitHub Actions workflows."
  value       = data.azurerm_client_config.current.subscription_id
}

output "github_secrets_summary" {
  description = "Summary of values to configure in GitHub repository settings."
  value = <<-EOT
    GitHub Actions Variables (not secrets — safe to expose):
      AZURE_TENANT_ID       = ${data.azurerm_client_config.current.tenant_id}
      AZURE_SUBSCRIPTION_ID = ${data.azurerm_client_config.current.subscription_id}

    ci.yml specific:
      AZURE_CLIENT_ID       = ${azurerm_user_assigned_identity.ci.client_id}

    terraform.yml specific (Environment: dev):
      AZURE_CLIENT_ID       = ${azurerm_user_assigned_identity.terraform.client_id}
  EOT
}
