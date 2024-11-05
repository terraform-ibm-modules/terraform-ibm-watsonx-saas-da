variable "ibmcloud_api_key" {
  description = "Used with the Terraform IBM-Cloud/ibm provider"
  sensitive   = true
  type        = string
}

variable "location" {
  default     = "us-south"
  description = "Used with the Terraform IBM-Cloud/ibm provider as well as resource creation."
  type        = string
  validation {
    condition     = contains(["eu-de", "eu-gb", "jp-tok", "us-south"], var.location)
    error_message = "The IBM Cloud location to use must be one of: eu-de, eu-gb, jp-tok or us-south"
  }
}
