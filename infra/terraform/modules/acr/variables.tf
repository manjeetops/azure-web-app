variable "resource_group_name" {
  type        = string
  description = "Resource group to place the ACR in."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "acr_name" {
  type        = string
  description = "ACR name — must be globally unique, 5-50 lowercase alphanumeric chars."

  validation {
    condition     = can(regex("^[a-z0-9]{5,50}$", var.acr_name))
    error_message = "ACR name must be 5-50 lowercase alphanumeric characters."
  }
}

variable "sku" {
  type        = string
  default     = "Basic"
  description = "ACR SKU. Basic for dev/demo; Standard for production (enables geo-replication and content trust)."

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "SKU must be Basic, Standard, or Premium."
  }
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags applied to the ACR resource."
}
