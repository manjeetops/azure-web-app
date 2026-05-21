terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      # NOTE: v4.x is available but requires migration of AKS resources.
      # Evaluate upgrade path before bumping.
      version = "~> 3.100"
    }
  }

  # ── Remote state — Azure Blob Storage ────────────────────────────────────────
  # Partial backend config — the state key is passed at init time so each
  # environment gets its own state file without duplicating code:
  #
  #   terraform init \
  #     -backend-config="key=environments/dev/terraform.tfstate"
  #
  # The storage account name is set once after running bootstrap-tfstate.sh.
  # ─────────────────────────────────────────────────────────────────────────────
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateazurewebapp12390"
    container_name       = "tfstate"
    # key is passed via -backend-config at init time:
    #   terraform init -backend-config="key=environments/prod/terraform.tfstate"
  }
}

# Auth precedence:
#   Local dev  : set subscription_id / tenant_id / client_id / client_secret in
#                environments/prod/secrets.tfvars (git-ignored) and pass with
#                -var-file="environments/prod/secrets.tfvars"
#   CI/CD      : ARM_CLIENT_ID / ARM_TENANT_ID / ARM_SUBSCRIPTION_ID / ARM_USE_OIDC=true
#                set automatically by the azure/login GitHub Actions step;
#                the var_ arguments below are null and are ignored by the provider
provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret

  # Skip auto-registering all ~150 Azure resource providers.
  # Only the providers this project actually uses are registered below (or via bootstrap).
  skip_provider_registration = true

  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}
