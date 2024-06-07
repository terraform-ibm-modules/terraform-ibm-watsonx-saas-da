############################################################
# Watson variables
############################################################

variable "ibmcloud_api_key" {
  description = "The API key that's used with the IBM Cloud Terraform IBM provider."
  sensitive   = true
  type        = string
}

############################################################
# COS variables
############################################################

variable "cos_guid" {
  description = "The globally unique identifier of the Cloud Object Storage instance."
  type        = string
}

############################################################
# Key Protect variables
############################################################

variable "cos_kms_crn" {
  description = "Key Protect service instance CRN used to encrypt the COS buckets used by the watsonx projects."
  type        = string
  default     = null

  validation {
    condition = anytrue([
      can(regex("^crn:(.*:){3}kms:(.*:){2}[0-9a-fA-F]{8}(?:-[0-9a-fA-F]{4}){3}-[0-9a-fA-F]{12}::$", var.cos_kms_crn)),
      var.cos_kms_crn == null,
    ])
    error_message = "Key Protect CRN validation failed."
  }
}

variable "cos_kms_key_crn" {
  description = "Key Protect key CRN used to encrypt the COS buckets used by the watsonx projects. If not set, then the cos_kms_new_key_name must be specified."
  type        = string
  default     = null
}

variable "cos_kms_new_key_name" {
  description = "Name of the Key Protect key to create for encrypting the COS buckets used by the watsonx projects."
  type        = string
  default     = ""
}

variable "cos_kms_ring_id" {
  description = "The identifier of the Key Protect ring to create the cos_kms_new_key_name into. If it is not set, then the new key will be created in the default ring."
  type        = string
  default     = null
}
