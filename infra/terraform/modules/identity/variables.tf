variable "resource_group_name" {
  type        = string
  description = "Resource group to place the managed identity in."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "identity_name" {
  type        = string
  description = "Name of the User-Assigned Managed Identity for the AKS kubelet."
}

variable "acr_id" {
  type        = string
  description = "Resource ID of the ACR. The identity will be granted AcrPull on this registry."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags applied to the managed identity resource."
}
