# ── User-Assigned Managed Identity ───────────────────────────────────────────
# User-assigned (vs system-assigned) means the identity:
#   - Survives AKS cluster recreation without needing new role assignments
#   - Can be pre-created and referenced before the cluster exists
#   - Has an explicit lifecycle independent of any single Azure resource
resource "azurerm_user_assigned_identity" "kubelet" {
  name                = var.identity_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# ── Managed Identity Operator ────────────────────────────────────────────────
# AKS requires the control plane identity to have 'Managed Identity Operator'
# on the kubelet identity so it can assign it to the node VMs.
# We use the same identity for both roles, so this is a self-referential
# role assignment — but Azure still requires it to be explicit.
resource "azurerm_role_assignment" "managed_identity_operator" {
  principal_id                     = azurerm_user_assigned_identity.kubelet.principal_id
  role_definition_name             = "Managed Identity Operator"
  scope                            = azurerm_user_assigned_identity.kubelet.id
  skip_service_principal_aad_check = true
}

# ── AcrPull role assignment ───────────────────────────────────────────────────
# Allows AKS nodes (kubelet) to pull images from ACR without any stored
# credentials. No imagePullSecret is needed in Kubernetes manifests.
#
# skip_service_principal_aad_check = true: the managed identity principal may
# not yet be replicated to all AAD nodes at apply time — this flag bypasses the
# pre-flight check and avoids a race condition.
resource "azurerm_role_assignment" "acr_pull" {
  principal_id                     = azurerm_user_assigned_identity.kubelet.principal_id
  role_definition_name             = "AcrPull"
  scope                            = var.acr_id
  skip_service_principal_aad_check = true
}
