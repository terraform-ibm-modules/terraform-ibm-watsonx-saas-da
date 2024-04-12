variable "ibmcloud_api_key" {
  description = "Used with the Terraform IBM-Cloud/ibm provider"
  sensitive   = true
  type        = string
}

variable "watsonx_admin_api_key" {
  default     = null
  description = "Used to call Watson APIs to configure the user and the project"
  sensitive   = true
  type        = string
}

variable "location" {
  default     = "us-south"
  description = "Used with the Terraform IBM-Cloud/ibm provider as well as resource creation."
  type        = string
  validation {
    condition     = contains(["eu-de", "us-south"], var.location)
    error_message = "The IBM Cloud location to use must be one of: eu-de or us-south"
  }
}
