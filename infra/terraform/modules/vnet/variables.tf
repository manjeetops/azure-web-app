variable "resource_group_name" {
  type        = string
  description = "Name of the Azure Resource Group to create."
}

variable "location" {
  type        = string
  description = "Azure region for all resources."
}

variable "vnet_name" {
  type        = string
  description = "Name of the Virtual Network."
}

variable "vnet_address_space" {
  type        = list(string)
  default     = ["10.0.0.0/8"]
  description = "Address space for the Virtual Network."
}

variable "aks_subnet_name" {
  type        = string
  default     = "aks-nodes"
  description = "Name of the AKS node subnet."
}

variable "aks_subnet_cidr" {
  type        = string
  default     = "10.240.0.0/16"
  description = "CIDR for the AKS node subnet."
}

variable "services_subnet_name" {
  type        = string
  default     = "services"
  description = "Name of the reserved services subnet."
}

variable "services_subnet_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR for the reserved services subnet."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags applied to all resources in this module."
}
