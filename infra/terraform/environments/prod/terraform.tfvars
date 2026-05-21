# ── Global ────────────────────────────────────────────────────────────────────
location            = "eastus"
resource_group_name = "azure-web-app"
environment         = "prod"

tags = {
  project     = "azure-web-app"
  environment = "prod"
  managed_by  = "terraform"
}

# ── Networking ────────────────────────────────────────────────────────────────
vnet_name            = "azure-web-app-vnet"
vnet_address_space   = ["10.0.0.0/8"]
aks_subnet_name      = "aks-nodes"
aks_subnet_cidr      = "10.240.0.0/16"
services_subnet_name = "services"
services_subnet_cidr = "10.0.0.0/16"

# ── ACR ───────────────────────────────────────────────────────────────────────
acr_name = "imageregistryyy"
acr_sku  = "Basic"

# ── Identity ──────────────────────────────────────────────────────────────────
kubelet_identity_name = "prod-aks-1-kubelet-identity"

# ── AKS ───────────────────────────────────────────────────────────────────────
cluster_name              = "prod-aks-1"
kubernetes_version        = "1.35.4"
node_pool_name            = "default"
node_count                = 1
node_vm_size              = "Standard_DC2as_v5"
os_disk_size_gb           = 30
max_pods_per_node         = 30
enable_auto_scaling       = false
min_node_count            = 1
max_node_count            = 5
service_cidr              = "172.16.0.0/16"
dns_service_ip            = "172.16.0.10"
private_cluster_enabled   = true
api_server_authorized_ip_ranges = []
automatic_channel_upgrade = "patch"
node_os_channel_upgrade   = "NodeImage"
azure_policy_enabled      = false

# ── GitHub OIDC ───────────────────────────────────────────────────────────────
github_org                = "manjeetops"
github_repo               = "azure-web-app"
github_branch             = "main"
github_environment        = "prod"
ci_identity_name          = "github-ci-identity"
terraform_identity_name   = "github-terraform-identity"
ci_credential_name        = "github-ci-federated"
terraform_credential_name = "github-terraform-federated"
