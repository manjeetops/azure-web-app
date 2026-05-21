# ── Service Principal credentials (local dev) ─────────────────────────────────
# Store these in environments/prod/secrets.tfvars (git-ignored).
# Leave unset in CI/CD — the provider reads ARM_* environment variables instead.

variable "subscription_id" {
  type        = string
  default     = null
  sensitive   = true
  description = "Azure subscription ID. Required for local dev via secrets.tfvars; CI/CD reads ARM_SUBSCRIPTION_ID from environment."
}

variable "tenant_id" {
  type        = string
  default     = null
  sensitive   = true
  description = "Azure AD tenant ID."
}

variable "client_id" {
  type        = string
  default     = null
  sensitive   = true
  description = "Service Principal client ID."
}

variable "client_secret" {
  type        = string
  default     = null
  sensitive   = true
  description = "Service Principal client secret."
}

# ── Global ────────────────────────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "Azure region for all resources."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the main resource group."
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod). Used in tags and node labels."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags applied to all resources."
}

# ── Networking ────────────────────────────────────────────────────────────────

variable "vnet_name" {
  type        = string
  description = "Name of the Virtual Network."
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Address space for the Virtual Network."
}

variable "aks_subnet_name" {
  type        = string
  description = "Name of the AKS node subnet."
}

variable "aks_subnet_cidr" {
  type        = string
  description = "CIDR for the AKS node subnet."
}

variable "services_subnet_name" {
  type        = string
  description = "Name of the reserved services subnet."
}

variable "services_subnet_cidr" {
  type        = string
  description = "CIDR for the reserved services subnet."
}

# ── ACR ───────────────────────────────────────────────────────────────────────

variable "acr_name" {
  type        = string
  description = "Globally unique ACR name (5-50 lowercase alphanumeric)."
}

variable "acr_sku" {
  type        = string
  description = "ACR SKU: Basic, Standard, or Premium."
}

# ── Identity ──────────────────────────────────────────────────────────────────

variable "kubelet_identity_name" {
  type        = string
  description = "Name of the User-Assigned Managed Identity for the AKS kubelet."
}

# ── AKS ───────────────────────────────────────────────────────────────────────

variable "cluster_name" {
  type        = string
  description = "Name of the AKS cluster."
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version. Check `az aks get-versions -l <region>`."
}

variable "node_pool_name" {
  type        = string
  description = "Name of the default node pool."
}

variable "node_count" {
  type        = number
  description = "Initial node count."
}

variable "node_vm_size" {
  type        = string
  description = "VM size for AKS nodes."
}

variable "os_disk_size_gb" {
  type        = number
  description = "OS disk size in GB per node."
}

variable "max_pods_per_node" {
  type        = number
  description = "Max pods per node."
}

variable "enable_auto_scaling" {
  type        = bool
  description = "Enable cluster autoscaler on the default node pool."
}

variable "min_node_count" {
  type        = number
  description = "Minimum node count (autoscaling only)."
}

variable "max_node_count" {
  type        = number
  description = "Maximum node count (autoscaling only)."
}

variable "service_cidr" {
  type        = string
  description = "CIDR for Kubernetes services."
}

variable "dns_service_ip" {
  type        = string
  description = "IP for the Kubernetes DNS service. Must be within service_cidr."
}

variable "private_cluster_enabled" {
  type        = bool
  description = "Make the API server private."
}

variable "api_server_authorized_ip_ranges" {
  type        = list(string)
  description = "CIDRs allowed to reach the API server (only when private_cluster_enabled = false)."
}

variable "automatic_channel_upgrade" {
  type        = string
  description = "Cluster upgrade channel: none, patch, rapid, stable."
}

variable "node_os_channel_upgrade" {
  type        = string
  description = "Node OS upgrade channel."
}

variable "azure_policy_enabled" {
  type        = bool
  description = "Enable Azure Policy add-on."
}

# ── GitHub OIDC ───────────────────────────────────────────────────────────────

variable "github_org" {
  type        = string
  description = "GitHub organisation or username."
}

variable "github_repo" {
  type        = string
  description = "GitHub repository name."
}

variable "github_branch" {
  type        = string
  description = "Branch the CI workflow runs on."
}

variable "github_environment" {
  type        = string
  description = "GitHub Environment name used by the Terraform workflow."
}

variable "ci_identity_name" {
  type        = string
  description = "Name of the CI managed identity."
}

variable "terraform_identity_name" {
  type        = string
  description = "Name of the Terraform managed identity."
}

variable "ci_credential_name" {
  type        = string
  description = "Name of the CI federated credential."
}

variable "terraform_credential_name" {
  type        = string
  description = "Name of the Terraform federated credential."
}
