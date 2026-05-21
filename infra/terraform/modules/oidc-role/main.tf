data "azurerm_client_config" "current" {}

# ── CI identity (GitHub Actions build workflow) ───────────────────────────────
resource "azurerm_user_assigned_identity" "ci" {
  name                = var.ci_identity_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# Federated credential: trusts tokens issued by GitHub Actions for pushes to the configured branch.
# The subject format "repo:org/repo:ref:refs/heads/branch" scopes trust to that specific branch.
resource "azurerm_federated_identity_credential" "ci" {
  name                = var.ci_credential_name
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.ci.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  subject             = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/${var.github_branch}"
}

# Allows the CI identity to push Docker images to ACR — no stored registry credentials needed
resource "azurerm_role_assignment" "ci_acr_push" {
  principal_id                     = azurerm_user_assigned_identity.ci.principal_id
  role_definition_name             = "AcrPush"
  scope                            = var.acr_id
  skip_service_principal_aad_check = true
}

# ── Terraform identity (infrastructure workflow) ──────────────────────────────
resource "azurerm_user_assigned_identity" "terraform" {
  name                = var.terraform_identity_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# Scoped to a GitHub Environment so only the protected environment can run terraform apply
resource "azurerm_federated_identity_credential" "terraform" {
  name                = var.terraform_credential_name
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.terraform.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  subject             = "repo:${var.github_org}/${var.github_repo}:environment:${var.github_environment}"
}

# Contributor allows Terraform to create, update, and delete Azure resources
resource "azurerm_role_assignment" "terraform_contributor" {
  principal_id                     = azurerm_user_assigned_identity.terraform.principal_id
  role_definition_name             = "Contributor"
  scope                            = var.resource_group_id
  skip_service_principal_aad_check = true
}

# Scoped role: allows Terraform to manage role assignments (e.g. AcrPull for kubelet)
# without granting full User Access Administrator over the resource group.
resource "azurerm_role_definition" "terraform_role_assigner" {
  name        = "Terraform Role Assigner - ${var.resource_group_name}"
  scope       = var.resource_group_id
  description = "Allows managing role assignments within the resource group"

  permissions {
    actions = [
      "Microsoft.Authorization/roleAssignments/read",
      "Microsoft.Authorization/roleAssignments/write",
      "Microsoft.Authorization/roleAssignments/delete",
    ]
    not_actions = []
  }

  assignable_scopes = [var.resource_group_id]
}

resource "azurerm_role_assignment" "terraform_role_assigner" {
  principal_id                     = azurerm_user_assigned_identity.terraform.principal_id
  role_definition_id               = azurerm_role_definition.terraform_role_assigner.role_definition_resource_id
  scope                            = var.resource_group_id
  skip_service_principal_aad_check = true
}
