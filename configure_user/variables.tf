variable "resource_group_id" {
  description = "ID of the IBM Cloud resource group in which resources are created."
  type        = string
}

variable "region" {
  description = "The region that is used with the IBM Cloud Terraform IBM provider. It is also used during resource creation."
  type        = string
}

variable "install_required_binaries" {
  type        = bool
  default     = true
  description = "When set to true, a script will run to check if `jq` exist on the runtime and if not attempt to download them from the public internet and install them to /tmp. Set to false to skip running this script."
  nullable    = false
}
