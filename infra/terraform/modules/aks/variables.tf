variable "cluster_name" {
  type        = string
  description = "Name of the AKS cluster."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group to place the AKS cluster in."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "kubernetes_version" {
  type        = string
  default     = "1.35"
  description = "Kubernetes version. Check `az aks get-versions -l <region>` for available versions."
}

variable "aks_subnet_id" {
  type        = string
  description = "Resource ID of the subnet for AKS nodes."
}

variable "identity_id" {
  type        = string
  description = "Resource ID of the User-Assigned Managed Identity for the cluster and kubelet."
}

variable "identity_client_id" {
  type        = string
  description = "Client ID of the User-Assigned Managed Identity."
}

variable "identity_principal_id" {
  type        = string
  description = "Principal ID of the User-Assigned Managed Identity."
}

# ── Node Pool ─────────────────────────────────────────────────────────────────

variable "node_pool_name" {
  type        = string
  default     = "default"
  description = "Name of the default node pool."
}

variable "node_count" {
  type        = number
  default     = 2
  description = "Initial node count. Ignored if enable_auto_scaling = true."
}

variable "node_vm_size" {
  type        = string
  default     = "Standard_DC2as_v5"
  description = "VM size for AKS nodes."
}

variable "os_disk_size_gb" {
  type        = number
  default     = 30
  description = "OS disk size in GB per node."
}

variable "max_pods_per_node" {
  type        = number
  default     = 30
  description = "Max pods per node."
}

variable "enable_auto_scaling" {
  type        = bool
  default     = false
  description = "Enable cluster autoscaler on the default node pool."
}

variable "min_node_count" {
  type        = number
  default     = 1
  description = "Minimum node count (only when enable_auto_scaling = true)."
}

variable "max_node_count" {
  type        = number
  default     = 5
  description = "Maximum node count (only when enable_auto_scaling = true)."
}

# ── Networking ────────────────────────────────────────────────────────────────

variable "service_cidr" {
  type        = string
  default     = "172.16.0.0/16"
  description = "CIDR for Kubernetes services. Must not overlap with VNet address space."
}

variable "dns_service_ip" {
  type        = string
  default     = "172.16.0.10"
  description = "IP address for the Kubernetes DNS service. Must be within service_cidr."
}

variable "private_cluster_enabled" {
  type        = bool
  default     = false
  description = "Make the API server private. When false, use api_server_authorized_ip_ranges."
}

variable "api_server_authorized_ip_ranges" {
  type        = list(string)
  default     = []
  description = "List of CIDRs allowed to reach the API server. Only applies when private_cluster_enabled = false."
}

# ── Cluster settings ──────────────────────────────────────────────────────────

variable "automatic_channel_upgrade" {
  type        = string
  default     = "patch"
  description = "Upgrade channel for the cluster. Options: none, patch, rapid, stable, node-image."
}

variable "node_os_channel_upgrade" {
  type        = string
  default     = "NodeImage"
  description = "Upgrade channel for node OS images."
}

variable "azure_policy_enabled" {
  type        = bool
  default     = false
  description = "Enable Azure Policy add-on (OPA Gatekeeper)."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment label applied to node labels."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags applied to the AKS cluster resource."
}
