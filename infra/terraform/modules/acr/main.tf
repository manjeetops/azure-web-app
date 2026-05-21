# ── Azure Container Registry ──────────────────────────────────────────────────
# admin_enabled = false: no shared username/password. Authentication is done
# exclusively through managed identities and RBAC role assignments, which is
# the recommended approach for production workloads.
resource "azurerm_container_registry" "this" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = false

  tags = var.tags
}
