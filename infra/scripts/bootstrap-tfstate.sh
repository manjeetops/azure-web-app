#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────────────
# bootstrap-tfstate.sh
#
# Creates the Azure Storage Account used as the Terraform remote backend.
# Run this ONCE before the first `terraform init`.
#
# The storage account itself cannot be managed by Terraform (chicken-and-egg),
# so this script handles the bootstrapping manually.
#
# Prerequisites:
#   - Azure CLI installed and logged in (`az login`)
#   - Sufficient permissions: Contributor on the subscription
#
# Usage:
#   bash scripts/bootstrap-tfstate.sh
#
# Override defaults via environment variables:
#   TF_STATE_RG=my-tfstate-rg \
#   TF_STATE_SA=mytfstateaccount \
#   LOCATION=westeurope \
#   bash scripts/bootstrap-tfstate.sh
# ──────────────────────────────────────────────────────────────────────────────

set -euo pipefail

# ── Config (override via env vars) ────────────────────────────────────────────
LOCATION="${LOCATION:-eastus}"
TF_STATE_RG="${TF_STATE_RG:-tfstate-rg}"
TF_STATE_SA="${TF_STATE_SA:-tfstatehelloworld$RANDOM}"   # random suffix for uniqueness
TF_STATE_CONTAINER="${TF_STATE_CONTAINER:-tfstate}"

echo "──────────────────────────────────────────────"
echo "  Terraform State Bootstrap"
echo "──────────────────────────────────────────────"
echo "  Resource Group : $TF_STATE_RG"
echo "  Storage Account: $TF_STATE_SA"
echo "  Container      : $TF_STATE_CONTAINER"
echo "  Location       : $LOCATION"
echo "──────────────────────────────────────────────"
echo ""

# ── 1. Resource Group ─────────────────────────────────────────────────────────
echo "→ Creating resource group '$TF_STATE_RG'..."
az group create \
  --name     "$TF_STATE_RG" \
  --location "$LOCATION" \
  --output none

# ── 2. Storage Account ────────────────────────────────────────────────────────
echo "→ Creating storage account '$TF_STATE_SA'..."
az storage account create \
  --name                    "$TF_STATE_SA" \
  --resource-group          "$TF_STATE_RG" \
  --location                "$LOCATION" \
  --sku                     Standard_LRS \
  --kind                    StorageV2 \
  --min-tls-version         TLS1_2 \
  --allow-blob-public-access false \
  --output none

# ── 3. Enable versioning (accidental-deletion protection) ─────────────────────
echo "→ Enabling blob versioning..."
az storage account blob-service-properties update \
  --account-name      "$TF_STATE_SA" \
  --resource-group    "$TF_STATE_RG" \
  --enable-versioning true \
  --output none

# ── 4. Container ──────────────────────────────────────────────────────────────
echo "→ Creating container '$TF_STATE_CONTAINER'..."
az storage container create \
  --name           "$TF_STATE_CONTAINER" \
  --account-name   "$TF_STATE_SA" \
  --auth-mode      login \
  --output none

echo ""
echo "✓ Bootstrap complete!"
echo ""
echo "Next steps:"
echo "  1. Update infra/terraform/providers.tf with:"
echo "       storage_account_name = \"$TF_STATE_SA\""
echo "       resource_group_name  = \"$TF_STATE_RG\""
echo ""
echo "  2. Run:"
echo "       cd infra/terraform"
echo "       terraform init -backend-config=\"key=environments/prod/terraform.tfstate\""
