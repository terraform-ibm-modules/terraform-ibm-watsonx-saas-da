variable "watsonx_admin_api_key" {
  description = "The Watson API key needed to call Watson APIs for configuring users."
  sensitive   = true
  type        = string
}

variable "resource_group_id" {
  description = "ID of the IBM Cloud resource group in which resources are created."
  type        = string
}
