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
  description = "Key Protect service instance CRN used to encrypt the COS buckets used by the watsonx projects. Ensure the Key Protect instance is in one of these following regions: `eu-de`, `eu-gb`, `jp-tok`, `us-south`"
  type        = string

  validation {
    condition = anytrue([
      can(regex("^crn:v\\d:(.*:){2}kms:(.*:)([aos]\\/[\\w_\\-]+):[0-9a-fA-F]{8}(?:-[0-9a-fA-F]{4}){3}-[0-9a-fA-F]{12}::$", var.cos_kms_crn))
    ])
    error_message = "Key Protect CRN validation failed. Ensure the Key Protect instance is in one of these following regions: eu-de, eu-gb, jp-tok, us-south, au-syd, ca-tor"
  }
}

variable "cos_kms_key_crn" {
  description = "Key Protect key CRN used to encrypt the COS buckets used by the watsonx projects. If not set, then the cos_kms_new_key_name must be specified."
  type        = string
  default     = null

  validation {
    condition = anytrue([
      var.cos_kms_key_crn == null,
      can(regex("^crn:v\\d:(.*:){2}kms:(.*:)([aos]\\/[\\w_\\-]+):[0-9a-fA-F]{8}(?:-[0-9a-fA-F]{4}){3}-[0-9a-fA-F]{12}:key:[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.cos_kms_key_crn))
    ])
    error_message = "The value provided for 'cos_kms_key_crn' is not valid."
  }
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

variable "skip_iam_authorization_policy" {
  type        = bool
  description = "Whether to create an IAM authorization policy that permits the Object Storage instance to read the encryption key from the KMS instance. An authorization policy must exist before an encrypted bucket can be created. Set to `true` to avoid creating the policy. If set to `false`, specify a value for the KMS instance crn in `cos_kms_crn`."
  default     = false
}
