output "identity_id" {
  description = "Resource ID of the User-Assigned Managed Identity. Pass to the AKS module."
  value       = azurerm_user_assigned_identity.kubelet.id
}

output "identity_client_id" {
  description = "Client ID of the managed identity. Used in pod annotations for Workload Identity."
  value       = azurerm_user_assigned_identity.kubelet.client_id
}

output "identity_principal_id" {
  description = "Principal (object) ID of the managed identity."
  value       = azurerm_user_assigned_identity.kubelet.principal_id
}
