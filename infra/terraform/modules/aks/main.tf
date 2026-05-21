resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.cluster_name
  kubernetes_version  = var.kubernetes_version

  # Private cluster: API server has no public endpoint — access is via Azure Private Link
  private_cluster_enabled             = var.private_cluster_enabled
  private_cluster_public_fqdn_enabled = false  # no public FQDN even for DNS resolution

  # Only apply IP allowlisting when the cluster is NOT private (mutually exclusive with private mode)
  api_server_authorized_ip_ranges = (
    !var.private_cluster_enabled && length(var.api_server_authorized_ip_ranges) > 0
    ? var.api_server_authorized_ip_ranges
    : null
  )

  # UserAssigned identity: the same managed identity is used for both the control plane
  # and the kubelet so AKS can pull images from ACR without any stored credentials
  identity {
    type         = "UserAssigned"
    identity_ids = [var.identity_id]
  }

  kubelet_identity {
    user_assigned_identity_id = var.identity_id
    client_id                 = var.identity_client_id
    object_id                 = var.identity_principal_id
  }

  default_node_pool {
    name                = var.node_pool_name
    vm_size             = var.node_vm_size
    os_disk_size_gb     = var.os_disk_size_gb
    vnet_subnet_id      = var.aks_subnet_id
    max_pods            = var.max_pods_per_node
    # node_count must be null when autoscaling is enabled — the cluster autoscaler manages it
    node_count          = var.enable_auto_scaling ? null : var.node_count
    enable_auto_scaling = var.enable_auto_scaling
    min_count           = var.enable_auto_scaling ? var.min_node_count : null
    max_count           = var.enable_auto_scaling ? var.max_node_count : null

    node_labels = {
      "nodepool" = var.node_pool_name
      "env"      = var.environment
    }
  }

  network_profile {
    network_plugin    = "azure"   # Azure CNI: pods get IPs from the VNet subnet
    load_balancer_sku = "standard"
    service_cidr      = var.service_cidr
    dns_service_ip    = var.dns_service_ip
  }

  # Required for workload identity (pod-level OIDC) used by operators like External Secrets
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  # Managed upgrade channels — AKS applies patches automatically within the chosen channel
  automatic_channel_upgrade = var.automatic_channel_upgrade
  node_os_channel_upgrade   = var.node_os_channel_upgrade
  azure_policy_enabled      = var.azure_policy_enabled

  tags = var.tags
}
