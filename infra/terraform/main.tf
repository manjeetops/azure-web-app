# vnet must be created first — it also owns the resource group that all other modules reference
module "vnet" {
  source = "./modules/vnet"

  resource_group_name  = var.resource_group_name
  location             = var.location
  vnet_name            = var.vnet_name
  vnet_address_space   = var.vnet_address_space
  aks_subnet_name      = var.aks_subnet_name
  aks_subnet_cidr      = var.aks_subnet_cidr
  services_subnet_name = var.services_subnet_name
  services_subnet_cidr = var.services_subnet_cidr
  tags                 = var.tags
}

# ACR is created before identity so the kubelet identity module can receive the ACR resource ID
module "acr" {
  source = "./modules/acr"

  resource_group_name = module.vnet.resource_group_name
  location            = module.vnet.location
  acr_name            = var.acr_name
  sku                 = var.acr_sku
  tags                = var.tags
}

# Creates the kubelet managed identity and grants it AcrPull on the registry above
module "identity" {
  source = "./modules/identity"

  resource_group_name = module.vnet.resource_group_name
  location            = module.vnet.location
  identity_name       = var.kubelet_identity_name
  acr_id              = module.acr.acr_id
  tags                = var.tags
}

# AKS cluster — depends on vnet (subnet), acr (via identity), and identity (kubelet identity)
module "aks" {
  source = "./modules/aks"

  cluster_name                    = var.cluster_name
  resource_group_name             = module.vnet.resource_group_name
  location                        = module.vnet.location
  kubernetes_version              = var.kubernetes_version
  aks_subnet_id                   = module.vnet.aks_subnet_id
  identity_id                     = module.identity.identity_id
  identity_client_id              = module.identity.identity_client_id
  identity_principal_id           = module.identity.identity_principal_id
  node_pool_name                  = var.node_pool_name
  node_count                      = var.node_count
  node_vm_size                    = var.node_vm_size
  os_disk_size_gb                 = var.os_disk_size_gb
  max_pods_per_node               = var.max_pods_per_node
  enable_auto_scaling             = var.enable_auto_scaling
  min_node_count                  = var.min_node_count
  max_node_count                  = var.max_node_count
  service_cidr                    = var.service_cidr
  dns_service_ip                  = var.dns_service_ip
  private_cluster_enabled         = var.private_cluster_enabled
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges
  automatic_channel_upgrade       = var.automatic_channel_upgrade
  node_os_channel_upgrade         = var.node_os_channel_upgrade
  azure_policy_enabled            = var.azure_policy_enabled
  environment                     = var.environment
  tags                            = var.tags
}

# Creates the CI and Terraform managed identities with OIDC federated credentials for GitHub Actions
module "oidc_role" {
  source = "./modules/oidc-role"

  acr_id                    = module.acr.acr_id
  resource_group_id         = module.vnet.resource_group_id
  resource_group_name       = module.vnet.resource_group_name
  location                  = module.vnet.location
  ci_identity_name          = var.ci_identity_name
  terraform_identity_name   = var.terraform_identity_name
  ci_credential_name        = var.ci_credential_name
  terraform_credential_name = var.terraform_credential_name
  github_org                = var.github_org
  github_repo               = var.github_repo
  github_branch             = var.github_branch
  github_environment        = var.github_environment
  tags                      = var.tags
}
