##############################################################################################################
# Input Variables
##############################################################################################################

variable "ibmcloud_api_key" {
  description = "The API key that is used with the IBM Cloud Terraform provider."
  sensitive   = true
  type        = string
}
variable "provider_visibility" {
  description = "Set the visibility value for the IBM terraform provider. [Learn more](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/guides/custom-service-endpoints)."
  type        = string
  default     = "private"

  validation {
    condition     = contains(["public", "private", "public-and-private"], var.provider_visibility)
    error_message = "Invalid visibility option. Allowed values are 'public', 'private', or 'public-and-private'."
  }
}

variable "region" {
  default     = "us-south"
  description = "The region to provision all resources in. [Learn more](https://terraform-ibm-modules.github.io/documentation/#/region) about how to select different regions for different services."
  type        = string
  validation {
    condition     = contains(["eu-de", "us-south", "eu-gb", "jp-tok", "au-syd", "ca-tor"], var.region)
    error_message = "You must specify `eu-de`, `eu-gb`, `jp-tok`, `au-syd`, `ca-tor` or `us-south` as the IBM Cloud region."
  }

  validation {
    condition     = local.kms_region == null || local.kms_region == var.region
    error_message = "If KMS encryption is enabled, the Key Management Service instance must be in the same region as the watsonx.ai instance."
  }

}

variable "existing_resource_group_name" {
  type        = string
  description = "The name of an existing resource group to provision the resources. [Learn more](https://cloud.ibm.com/docs/account?topic=account-rgs&interface=ui#create_rgs) about how to create a resource group."
  default     = "Default"
}

variable "prefix" {
  description = "The prefix to add to all resources that are created (e.g `prod`, `test`, `dev`). To skip using a prefix, set this value to `null` or an empty string. [Learn more](https://terraform-ibm-modules.github.io/documentation/#/prefix.md)."
  nullable    = true
  type        = string

  validation {
    # - null and empty string is allowed
    # - Must not contain consecutive hyphens (--): length(regexall("--", var.prefix)) == 0
    # - Starts with a lowercase letter: [a-z]
    # - Contains only lowercase letters (a–z), digits (0–9), and hyphens (-)
    # - Must not end with a hyphen (-): [a-z0-9]
    condition = (var.prefix == null || var.prefix == "" ? true :
      alltrue([
        can(regex("^[a-z][-a-z0-9]*[a-z0-9]$", var.prefix)),
        length(regexall("--", var.prefix)) == 0
      ])
    )
    error_message = "Prefix must begin with a lowercase letter and may contain only lowercase letters, digits, and hyphens '-'. It must not end with a hyphen('-'), and cannot contain consecutive hyphens ('--')."
  }

  validation {
    # must not exceed 16 characters in length
    condition     = var.prefix == null || var.prefix == "" ? true : length(var.prefix) <= 16
    error_message = "Prefix must not exceed 16 characters."
  }
}

##############################################################################################################
# watsonx Project Configuration
##############################################################################################################

variable "watsonx_admin_api_key" {
  default     = null
  description = "The API key of the IBM watsonx administrator in the target account. The API key is used to configure the user and the project."
  sensitive   = true
  type        = string
}

variable "watsonx_project_name" {
  description = "The name of the watson project. If a prefix input variable is specified, the prefix is added to the name in the `<prefix>-<watsonx_project_name>` format."
  type        = string
  default     = "demo"
}

variable "watsonx_project_description" {
  description = "A description of the watson project that's created by the WatsonX.ai SaaS Deployable Architecture."
  type        = string
  default     = "Watson project created by the watsonx-ai SaaS deployable architecture."
}

variable "watsonx_project_tags" {
  description = "A list of tags associated with the watsonx project. Each tag consists of a single string containing up to 255 characters. These tags can include spaces, letters, numbers, underscores, dashes, as well as the symbols # and @."
  type        = list(string)
  default     = ["watsonx-ai-SaaS"]
}

variable "watsonx_mark_as_sensitive" {
  description = "Set to true to allow the WatsonX project to be created with 'Mark as sensitive' flag."
  type        = bool
  default     = false
}

##############################################################################################################
# watsonx Machine Learning
##############################################################################################################

variable "existing_machine_learning_instance" {
  default     = null
  description = "CRN of an existing Watson Machine Learning instance."
  type        = string
}

variable "watson_machine_learning_plan" {
  default     = "v2-standard"
  description = "The plan that is used to provision the Watson Machine Learning instance."
  type        = string
  validation {
    condition     = contains(["lite", "v2-professional", "v2-standard"], var.watson_machine_learning_plan)
    error_message = "The plan must be lite, v2-professional, or v2-standard. [Learn more](https://cloud.ibm.com/catalog/services/watsonxai-runtime)."
  }
}

variable "watson_machine_learning_service_endpoints" {
  default     = "public"
  description = "The type of service endpoints. Possible values are 'public', 'private', 'public-and-private'."
  type        = string
  validation {
    condition     = contains(["public", "public-and-private", "private"], var.watson_machine_learning_service_endpoints)
    error_message = "The specified service endpoint is not valid. Supported options are public, public-and-private, or private."
  }
}

##############################################################################################################
# watsonx Studio
##############################################################################################################

variable "existing_studio_instance" {
  default     = null
  description = "CRN of an existing Watson Studio instance."
  type        = string
}

variable "watson_studio_plan" {
  default     = "professional-v1"
  description = "The plan that is used to provision the Watson Studio instance. The plan you choose for Watson Studio affects the features and capabilities that you can use."
  type        = string
  validation {
    condition     = contains(["free-v1", "professional-v1"], var.watson_studio_plan)
    error_message = "You must use a free-v1 or professional-v1 plan. [Learn more](https://cloud.ibm.com/catalog/services/watsonxai-studio)."
  }
}

##############################################################################################################
# Watson Discovery
##############################################################################################################

variable "existing_discovery_instance" {
  default     = null
  description = "CRN of an existing Watson Discovery instance."
  type        = string
}

variable "watson_discovery_plan" {
  default     = "do not install"
  description = "The plan that is used to provision the Watson Discovery instance."
  type        = string
  validation {
    condition = anytrue([
      var.watson_discovery_plan == local.skip_install,
      var.watson_discovery_plan == "plus",
      var.watson_discovery_plan == "enterprise",
    ])
    error_message = "You must use a plus or enterprise plan. [Learn more](https://cloud.ibm.com/docs/discovery-data?topic=discovery-data-pricing-plans)."
  }
}

variable "watson_discovery_service_endpoints" {
  default     = "public"
  description = "The type of service endpoints. Possible values are 'public', 'private', 'public-and-private'."
  type        = string
  validation {
    condition     = contains(["public", "public-and-private", "private"], var.watson_discovery_service_endpoints)
    error_message = "The specified service endpoint is not valid. Supported options are public, public-and-private, or private."
  }
}

##############################################################################################################
# watsonx Assistant
##############################################################################################################

variable "existing_assistant_instance" {
  default     = null
  description = "CRN of an existing watsonx Assistant instance."
  type        = string
}

variable "watsonx_assistant_plan" {
  default     = "do not install"
  description = "The plan that is used to provision the watsonx Assistant instance."
  type        = string
  validation {
    condition = anytrue([
      var.watsonx_assistant_plan == local.skip_install,
      var.watsonx_assistant_plan == "free",
      var.watsonx_assistant_plan == "plus",
      var.watsonx_assistant_plan == "enterprise",
    ])
    error_message = "You must use a free, plus or enterprise plan. [Learn more](https://cloud.ibm.com/docs/watson-assistant?topic=watson-assistant-admin-managing-plan)."
  }
}

variable "watsonx_assistant_service_endpoints" {
  default     = "public"
  description = "The type of service endpoints. Possible values are 'public', 'private', 'public-and-private'."
  type        = string
  validation {
    condition     = contains(["public", "public-and-private", "private"], var.watsonx_assistant_service_endpoints)
    error_message = "The specified service endpoint is not valid. Supported options are public, public-and-private, or private."
  }
}

##############################################################################################################
# watsonx Governance
##############################################################################################################

variable "existing_governance_instance" {
  default     = null
  description = "CRN of an existing watsonx.governance instance."
  type        = string
}

variable "watsonx_governance_plan" {
  default     = "do not install"
  description = "The plan used to provision the watsonx.governance instance. The available plans depend on the region where you are provisioning the service from the IBM Cloud catalog."
  type        = string
  validation {
    condition = anytrue([
      var.watsonx_governance_plan == local.skip_install,
      var.watsonx_governance_plan == "lite",
      var.watsonx_governance_plan == "essentials",
    ])
    error_message = "You must use a lite or essential plan. [Learn more](https://dataplatform.cloud.ibm.com/docs/content/wsj/model/wos-plan-options.html?context=wx&audience=wdp). "
  }
}

##############################################################################################################
# watsonx Data
##############################################################################################################

variable "existing_data_instance" {
  default     = null
  description = "CRN of an existing watsonx.data instance."
  type        = string
}

variable "watsonx_data_plan" {
  default     = "do not install"
  description = "The plan that is used to provision the watsonx.data instance."
  type        = string
  validation {
    condition = anytrue([
      var.watsonx_data_plan == local.skip_install,
      var.watsonx_data_plan == "lakehouse-enterprise",
      var.watsonx_data_plan == "lite",
    ])
    error_message = "You must use a lakehouse-enterprise or lite plan. [Learn more](https://cloud.ibm.com/docs/watsonxdata?topic=watsonxdata-getting-started)."
  }
}

##############################################################################################################
# watsonx Orchestrate
##############################################################################################################

variable "existing_orchestrate_instance" {
  default     = null
  description = "CRN of an existing watsonx Orchestrate instance."
  type        = string
}

variable "watsonx_orchestrate_plan" {
  default     = "do not install"
  description = "The plan that is used to provision the watsonx Orchestrate instance."
  type        = string
  validation {
    condition = anytrue([
      var.watsonx_orchestrate_plan == local.skip_install,
      var.watsonx_orchestrate_plan == "lite",
      var.watsonx_orchestrate_plan == "essentials-agentic-mau",
      var.watsonx_orchestrate_plan == "standard-agentic-mau",
    ])
    error_message = "You must use a lite, essentials-agentic-mau or standard-agentic-mau plan. [Learn more](https://cloud.ibm.com/catalog/services/watsonx-orchestrate)."
  }
}

##############################################################################################################
# COS
##############################################################################################################

variable "cos_plan" {
  default     = "standard"
  description = "The plan that's used to provision the Cloud Object Storage instance."
  type        = string
  validation {
    condition     = var.cos_plan == "standard"
    error_message = "You must use a standard plan. Standard plan instances are the most common and are recommended for most workloads."
  }
}

variable "existing_cos_instance_crn" {
  type        = string
  description = "The CRN of an existing Cloud Object Storage instance. If not specified, a new instance will be created."
  default     = null
}

##############################################################################################################
# KMS
##############################################################################################################

variable "enable_cos_kms_encryption" {
  description = "Flag to enable COS KMS encryption. If set to true, a value must be passed for `cos_kms_crn`."
  type        = bool
  default     = false
}

variable "cos_kms_crn" {
  description = "Key Protect service instance CRN used to encrypt the COS buckets used by the watsonx projects. Required if `enable_cos_kms_encryption` is true."
  type        = string
  default     = null

  validation {
    condition = anytrue([
      can(regex("^crn:(.*:){3}kms:(.*:){2}[0-9a-fA-F]{8}(?:-[0-9a-fA-F]{4}){3}-[0-9a-fA-F]{12}::$", var.cos_kms_crn)),
      var.cos_kms_crn == null,
    ])
    error_message = "Key Protect CRN validation failed."
  }

  validation {
    condition     = !var.enable_cos_kms_encryption || try(length(var.cos_kms_crn), 0) > 0
    error_message = "If 'enable_cos_kms_encryption' is true, you must provide 'cos_kms_crn'."
  }
}

variable "cos_kms_key_crn" {
  description = "Key Protect key CRN used to encrypt the COS buckets used by the watsonx projects. If not set, then the cos_kms_new_key_name must be specified."
  type        = string
  default     = null

  validation {
    condition     = !var.enable_cos_kms_encryption || (try(length(var.cos_kms_crn), 0) > 0 && (try(length(var.cos_kms_key_crn), 0) > 0 || try(length(var.cos_kms_new_key_name), 0) > 0))
    error_message = "If 'enable_cos_kms_encryption' is true, you must provide 'cos_kms_crn' and one of: 'cos_kms_key_crn' or 'cos_kms_new_key_name'."
  }
}

variable "cos_kms_new_key_name" {
  description = "Name of the Key Protect key to create for encrypting the COS buckets used by the watsonx projects. If a prefix input variable is specified, the prefix is added to the name in the `<prefix>-<cos_kms_new_key_name>` format."
  type        = string
  default     = "wx-saas-da-key"
}

##############################################################################################################
