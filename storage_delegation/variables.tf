############################################################
# Watson variables
############################################################

variable "watsonx_admin_api_key" {
  description = "The Watson API key that's needed to call Watson APIs for configuring projects."
  sensitive   = true
  type        = string
}

############################################################
# COS variables
############################################################

variable "cos_guid" {
  description = "This GUID is the globally unique identifier for the Cloud Object Storage instance."
  type        = string
}

############################################################
# Key Protect variables
############################################################

variable "cos_kms_crn" {
  description = "Key Protect CRN used to encrypt the COS bucket used by the Watson project."
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
  description = "Key Protect key CRN used to encrypt the COS bucket used by the Watson project."
  type        = string
  default     = null
}

variable "cos_kms_new_key_name" {
  description = "Name of the Key Protect key to create to encrypt the COS bucket used by the Watson project."
  type        = string
  default     = ""
}

variable "cos_kms_ring_id" {
  description = "The ID of the KMS ring to create the cos_kms_new_key_name into. The parameter will only be used if the DA has to create the KMS key. If it is not set, then the new key will be created in the default ring."
  type        = string
  default     = null
}
