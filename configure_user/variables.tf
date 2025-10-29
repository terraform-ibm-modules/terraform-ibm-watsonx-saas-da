variable "watsonx_admin_api_key" {
  description = "The Watson API key needed to call Watson APIs for configuring users."
  sensitive   = true
  type        = string
}

variable "resource_group_id" {
  description = "ID of the IBM Cloud resource group in which resources are created."
  type        = string
}

variable "region" {
  description = "The region that is used with the IBM Cloud Terraform IBM provider. It is also used during resource creation."
  type        = string
}
