output "acr_id" {
  description = "Resource ID of the Azure Container Registry."
  value       = azurerm_container_registry.this.id
}

output "acr_name" {
  description = "Name of the Azure Container Registry."
  value       = azurerm_container_registry.this.name
}

output "login_server" {
  description = "ACR login server URL (e.g. helloworldacr.azurecr.io). Use as the Docker registry."
  value       = azurerm_container_registry.this.login_server
}
