variable "acr_id" {
  type        = string
  description = "Resource ID of the ACR. The CI credential will be granted AcrPush here."
}

variable "resource_group_id" {
  type        = string
  description = "Resource ID of the main resource group. The Terraform credential will get Contributor here."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group to place the managed identities in."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "ci_identity_name" {
  type        = string
  default     = "github-ci-identity"
  description = "Name of the managed identity used by the CI workflow."
}

variable "terraform_identity_name" {
  type        = string
  default     = "github-terraform-identity"
  description = "Name of the managed identity used by the Terraform workflow."
}

variable "ci_credential_name" {
  type        = string
  default     = "github-ci-federated"
  description = "Name of the federated credential for the CI identity."
}

variable "terraform_credential_name" {
  type        = string
  default     = "github-terraform-federated"
  description = "Name of the federated credential for the Terraform identity."
}

variable "github_org" {
  type        = string
  description = "GitHub organisation or username that owns the repository."
}

variable "github_repo" {
  type        = string
  description = "GitHub repository name."
}

variable "github_branch" {
  type        = string
  default     = "main"
  description = "Branch that the CI workflow runs on."
}

variable "github_environment" {
  type        = string
  default     = "dev"
  description = "GitHub Environment name used by the Terraform workflow."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags applied to the managed identity resources."
}
