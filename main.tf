data "ibm_iam_auth_token" "restapi" {
  provider = ibm.watsonx_admin
}

##############################################################################################################
# Resource Group
##############################################################################################################

module "resource_group" {
  providers = {
    ibm = ibm.deployer
  }
  source                       = "terraform-ibm-modules/resource-group/ibm"
  version                      = "1.4.7"
  existing_resource_group_name = var.existing_resource_group_name
}

##############################################################################################################
# Locals Block
##############################################################################################################

locals {
  prefix       = var.prefix != null ? trimspace(var.prefix) != "" ? "${var.prefix}-" : "" : ""
  skip_install = "do not install"
  dataplatform_ui_mapping = {
    "us-south" = "https://dataplatform.cloud.ibm.com",
    "eu-gb"    = "https://eu-gb.dataplatform.cloud.ibm.com",
    "eu-de"    = "https://eu-de.dataplatform.cloud.ibm.com",
    "jp-tok"   = "https://jp-tok.dataplatform.cloud.ibm.com",
    "au-syd"   = "https://au-syd.dai.cloud.ibm.com",
    "ca-tor"   = "https://ca-tor.dai.cloud.ibm.com"
  }
  dataplatform_ui = local.dataplatform_ui_mapping[var.region]
  watsonx_data_datacenter_mapping = {
    "us-south" = "ibm:us-south:dal",
    "eu-gb"    = "ibm:eu-gb:lon",
    "eu-de"    = "ibm:eu-de:fra",
    "jp-tok"   = "ibm:jp-tok:tok",
    "au-syd"   = "ibm:au-syd:syd",
    "ca-tor"   = "ibm:ca-tor:tor"
  }
  watsonx_data_datacenter = local.watsonx_data_datacenter_mapping[var.region]
}

# Configuring outputs
locals {
  watsonx_assistant_crn           = var.existing_assistant_instance != null ? data.ibm_resource_instance.existing_assistant_instance[0].crn : var.watsonx_assistant_plan != local.skip_install ? resource.ibm_resource_instance.assistant_instance[0].crn : null
  watsonx_assistant_guid          = var.existing_assistant_instance != null ? data.ibm_resource_instance.existing_assistant_instance[0].guid : var.watsonx_assistant_plan != local.skip_install ? resource.ibm_resource_instance.assistant_instance[0].guid : null
  watsonx_assistant_name          = var.existing_assistant_instance != null ? data.ibm_resource_instance.existing_assistant_instance[0].resource_name : var.watsonx_assistant_plan != local.skip_install ? ibm_resource_instance.assistant_instance[0].resource_name : null
  watsonx_assistant_plan_id       = var.existing_assistant_instance != null ? null : var.watsonx_assistant_plan != local.skip_install ? resource.ibm_resource_instance.assistant_instance[0].resource_plan_id : null
  watsonx_assistant_dashboard_url = var.existing_assistant_instance != null ? null : var.watsonx_assistant_plan != local.skip_install ? resource.ibm_resource_instance.assistant_instance[0].dashboard_url : null

  watson_discovery_crn           = var.existing_discovery_instance != null ? data.ibm_resource_instance.existing_discovery_instance[0].crn : var.watson_discovery_plan != local.skip_install ? ibm_resource_instance.discovery_instance[0].crn : null
  watson_discovery_guid          = var.existing_discovery_instance != null ? data.ibm_resource_instance.existing_discovery_instance[0].guid : var.watson_discovery_plan != local.skip_install ? ibm_resource_instance.discovery_instance[0].guid : null
  watson_discovery_name          = var.existing_discovery_instance != null ? data.ibm_resource_instance.existing_discovery_instance[0].resource_name : var.watson_discovery_plan != local.skip_install ? ibm_resource_instance.discovery_instance[0].resource_name : null
  watson_discovery_plan_id       = var.existing_discovery_instance != null ? null : var.watson_discovery_plan != local.skip_install ? ibm_resource_instance.discovery_instance[0].resource_plan_id : null
  watson_discovery_dashboard_url = var.existing_discovery_instance != null ? null : var.watson_discovery_plan != local.skip_install ? ibm_resource_instance.discovery_instance[0].dashboard_url : null

  watson_machine_learning_crn           = var.existing_machine_learning_instance != null ? data.ibm_resource_instance.existing_machine_learning_instance[0].crn : resource.ibm_resource_instance.machine_learning_instance[0].crn
  watson_machine_learning_guid          = var.existing_machine_learning_instance != null ? data.ibm_resource_instance.existing_machine_learning_instance[0].guid : resource.ibm_resource_instance.machine_learning_instance[0].guid
  watson_machine_learning_name          = var.existing_machine_learning_instance != null ? data.ibm_resource_instance.existing_machine_learning_instance[0].resource_name : resource.ibm_resource_instance.machine_learning_instance[0].resource_name
  watson_machine_learning_plan_id       = var.existing_machine_learning_instance != null ? null : resource.ibm_resource_instance.machine_learning_instance[0].resource_plan_id
  watson_machine_learning_dashboard_url = var.existing_machine_learning_instance != null ? null : resource.ibm_resource_instance.machine_learning_instance[0].dashboard_url

  watson_studio_crn           = var.existing_studio_instance != null ? data.ibm_resource_instance.existing_studio_instance[0].crn : resource.ibm_resource_instance.studio_instance[0].crn
  watson_studio_guid          = var.existing_studio_instance != null ? data.ibm_resource_instance.existing_studio_instance[0].guid : resource.ibm_resource_instance.studio_instance[0].guid
  watson_studio_name          = var.existing_studio_instance != null ? data.ibm_resource_instance.existing_studio_instance[0].resource_name : resource.ibm_resource_instance.studio_instance[0].resource_name
  watson_studio_plan_id       = var.existing_studio_instance != null ? null : resource.ibm_resource_instance.studio_instance[0].resource_plan_id
  watson_studio_dashboard_url = var.existing_studio_instance != null ? null : resource.ibm_resource_instance.studio_instance[0].dashboard_url

  watsonx_governance_crn           = var.existing_governance_instance != null ? data.ibm_resource_instance.existing_governance_instance[0].crn : var.watsonx_governance_plan != local.skip_install ? resource.ibm_resource_instance.governance_instance[0].crn : null
  watsonx_governance_guid          = var.existing_governance_instance != null ? data.ibm_resource_instance.existing_governance_instance[0].guid : var.watsonx_governance_plan != local.skip_install ? resource.ibm_resource_instance.governance_instance[0].guid : null
  watsonx_governance_name          = var.existing_governance_instance != null ? data.ibm_resource_instance.existing_governance_instance[0].resource_name : var.watsonx_governance_plan != local.skip_install ? resource.ibm_resource_instance.governance_instance[0].resource_name : null
  watsonx_governance_plan_id       = var.existing_governance_instance != null ? null : var.watsonx_governance_plan != local.skip_install ? resource.ibm_resource_instance.governance_instance[0].resource_plan_id : null
  watsonx_governance_dashboard_url = var.existing_governance_instance != null ? null : var.watsonx_governance_plan != local.skip_install ? resource.ibm_resource_instance.governance_instance[0].dashboard_url : null

  watsonx_data_crn           = var.existing_data_instance != null ? data.ibm_resource_instance.existing_data_instance[0].crn : var.watsonx_data_plan != local.skip_install ? resource.ibm_resource_instance.data_instance[0].crn : null
  watsonx_data_guid          = var.existing_data_instance != null ? data.ibm_resource_instance.existing_data_instance[0].guid : var.watsonx_data_plan != local.skip_install ? resource.ibm_resource_instance.data_instance[0].guid : null
  watsonx_data_name          = var.existing_data_instance != null ? data.ibm_resource_instance.existing_data_instance[0].resource_name : var.watsonx_data_plan != local.skip_install ? resource.ibm_resource_instance.data_instance[0].resource_name : null
  watsonx_data_plan_id       = var.existing_data_instance != null ? null : var.watsonx_data_plan != local.skip_install ? resource.ibm_resource_instance.data_instance[0].resource_plan_id : null
  watsonx_data_dashboard_url = var.existing_data_instance != null ? null : var.watsonx_data_plan != local.skip_install ? resource.ibm_resource_instance.data_instance[0].dashboard_url : null

  watsonx_orchestrate_crn           = var.existing_orchestrate_instance != null ? data.ibm_resource_instance.existing_orchestrate_instance[0].crn : var.watsonx_orchestrate_plan != local.skip_install ? resource.ibm_resource_instance.orchestrate_instance[0].crn : null
  watsonx_orchestrate_guid          = var.existing_orchestrate_instance != null ? data.ibm_resource_instance.existing_orchestrate_instance[0].guid : var.watsonx_orchestrate_plan != local.skip_install ? resource.ibm_resource_instance.orchestrate_instance[0].guid : null
  watsonx_orchestrate_name          = var.existing_orchestrate_instance != null ? data.ibm_resource_instance.existing_orchestrate_instance[0].resource_name : var.watsonx_orchestrate_plan != local.skip_install ? resource.ibm_resource_instance.orchestrate_instance[0].resource_name : null
  watsonx_orchestrate_plan_id       = var.existing_orchestrate_instance != null ? null : var.watsonx_orchestrate_plan != local.skip_install ? resource.ibm_resource_instance.orchestrate_instance[0].resource_plan_id : null
  watsonx_orchestrate_dashboard_url = var.existing_orchestrate_instance != null ? null : var.watsonx_orchestrate_plan != local.skip_install ? resource.ibm_resource_instance.orchestrate_instance[0].dashboard_url : null
}

##############################################################################################################
# CRN PARSERS
##############################################################################################################

module "existing_cos_crn_parser" {
  count   = var.existing_cos_instance_crn != null ? 1 : 0
  source  = "terraform-ibm-modules/common-utilities/ibm//modules/crn-parser"
  version = "1.3.7"
  crn     = var.existing_cos_instance_crn
}

module "cos_kms_key_crn_parser" {
  count   = var.enable_cos_kms_encryption && var.cos_kms_key_crn != null ? 1 : 0
  source  = "terraform-ibm-modules/common-utilities/ibm//modules/crn-parser"
  version = "1.3.7"
  crn     = var.cos_kms_key_crn
}

##############################################################################################################
# Cloud Object Storage
##############################################################################################################

locals {

  is_storage_delegated = var.enable_cos_kms_encryption ? true : false

  cos_instance_crn  = var.existing_cos_instance_crn == null ? module.cos[0].cos_instance_crn : var.existing_cos_instance_crn
  cos_instance_guid = var.existing_cos_instance_crn == null ? module.cos[0].cos_instance_guid : module.existing_cos_crn_parser[0].service_instance

  # fetch KMS region from cos_kms_key_crn
  kms_region           = var.enable_cos_kms_encryption && var.cos_kms_key_crn != null ? module.cos_kms_key_crn_parser[0].region : null
  cos_kms_new_key_name = var.enable_cos_kms_encryption && var.cos_kms_key_crn == null ? "${local.prefix}${var.cos_kms_new_key_name}" : null
}

module "cos" {
  providers = {
    ibm = ibm.deployer
  }
  count             = var.existing_cos_instance_crn == null ? 1 : 0
  source            = "terraform-ibm-modules/cos/ibm//modules/fscloud"
  version           = "10.8.5"
  resource_group_id = module.resource_group.resource_group_id
  cos_instance_name = "${local.prefix}cos-instance"
  cos_plan          = var.cos_plan
}

moved {
  from = module.cos
  to   = module.cos[0]
}

##############################################################################################################
# Watson Studio
##############################################################################################################

data "ibm_resource_instance" "existing_studio_instance" {
  provider   = ibm.deployer
  count      = var.existing_studio_instance != null ? 1 : 0
  identifier = var.existing_studio_instance
}

resource "ibm_resource_instance" "studio_instance" {
  provider          = ibm.deployer
  count             = var.existing_studio_instance != null ? 0 : 1
  name              = "${local.prefix}watson-studio-instance"
  service           = "data-science-experience"
  plan              = var.watson_studio_plan
  location          = var.region
  resource_group_id = module.resource_group.resource_group_id

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

moved {
  from = ibm_resource_instance.studio_instance
  to   = ibm_resource_instance.studio_instance[0]
}

##############################################################################################################
# Watson Machine Learning
##############################################################################################################

data "ibm_resource_instance" "existing_machine_learning_instance" {
  provider   = ibm.deployer
  count      = var.existing_machine_learning_instance != null ? 1 : 0
  identifier = var.existing_machine_learning_instance
}

resource "ibm_resource_instance" "machine_learning_instance" {
  provider          = ibm.deployer
  count             = var.existing_machine_learning_instance != null ? 0 : 1
  name              = "${local.prefix}watson-machine-learning-instance"
  service           = "pm-20"
  plan              = var.watson_machine_learning_plan
  location          = var.region
  resource_group_id = module.resource_group.resource_group_id

  parameters = {
    service-endpoints = var.watson_machine_learning_service_endpoints
  }

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }

  lifecycle {
    precondition {
      condition     = var.watson_machine_learning_plan == "lite" ? var.watson_machine_learning_service_endpoints == "public" : true
      error_message = "The lite plan only supports public endpoints."
    }
  }
}

moved {
  from = ibm_resource_instance.machine_learning_instance
  to   = ibm_resource_instance.machine_learning_instance[0]
}

##############################################################################################################
# watsonx Assistant
##############################################################################################################

data "ibm_resource_instance" "existing_assistant_instance" {
  provider   = ibm.deployer
  count      = var.existing_assistant_instance != null ? 1 : 0
  identifier = var.existing_assistant_instance
}

resource "ibm_resource_instance" "assistant_instance" {
  provider          = ibm.deployer
  count             = var.existing_assistant_instance != null ? 0 : var.watsonx_assistant_plan == local.skip_install ? 0 : 1
  name              = "${local.prefix}watsonx-assistant-instance"
  service           = "conversation"
  plan              = var.watsonx_assistant_plan
  location          = var.region
  resource_group_id = module.resource_group.resource_group_id

  parameters = {
    service-endpoints = var.watsonx_assistant_service_endpoints
  }

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }

  lifecycle {
    precondition {
      condition     = var.watsonx_assistant_plan == "free" ? var.watsonx_assistant_service_endpoints == "public" : true
      error_message = "The lite plan only supports public endpoints."
    }
  }
}

##############################################################################################################
# watsonx.governance
##############################################################################################################

data "ibm_resource_instance" "existing_governance_instance" {
  provider   = ibm.deployer
  count      = var.existing_governance_instance != null ? 1 : 0
  identifier = var.existing_governance_instance
}

resource "ibm_resource_instance" "governance_instance" {
  provider          = ibm.deployer
  count             = var.existing_governance_instance != null || var.watsonx_governance_plan == local.skip_install ? 0 : 1
  name              = "${local.prefix}watsonx-governance-instance"
  service           = "aiopenscale"
  plan              = var.watsonx_governance_plan
  location          = var.region
  resource_group_id = module.resource_group.resource_group_id

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

##############################################################################################################
# watson Discovery
##############################################################################################################

data "ibm_resource_instance" "existing_discovery_instance" {
  provider   = ibm.deployer
  count      = var.existing_discovery_instance != null ? 1 : 0
  identifier = var.existing_discovery_instance
}

resource "ibm_resource_instance" "discovery_instance" {
  provider          = ibm.deployer
  count             = var.existing_discovery_instance != null || var.watson_discovery_plan == local.skip_install ? 0 : 1
  name              = "${local.prefix}watson-discovery-instance"
  service           = "discovery"
  plan              = var.watson_discovery_plan
  location          = var.region
  resource_group_id = module.resource_group.resource_group_id

  parameters = {
    service-endpoints = var.watson_discovery_service_endpoints
  }

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

##############################################################################################################
# watsonx.data
##############################################################################################################

data "ibm_resource_instance" "existing_data_instance" {
  provider   = ibm.deployer
  count      = var.existing_data_instance != null ? 1 : 0
  identifier = var.existing_data_instance
}

resource "ibm_resource_instance" "data_instance" {
  provider          = ibm.deployer
  count             = var.existing_data_instance != null || var.watsonx_data_plan == local.skip_install ? 0 : 1
  name              = "${local.prefix}watsonx-data-instance"
  service           = "lakehouse"
  plan              = var.watsonx_data_plan
  location          = var.region
  resource_group_id = module.resource_group.resource_group_id

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }

  parameters = {
    datacenter : local.watsonx_data_datacenter
    cloud_type : "ibm"
    region : var.region
  }
}

##############################################################################################################
# watsonx Orchestrate
##############################################################################################################

data "ibm_resource_instance" "existing_orchestrate_instance" {
  provider   = ibm.deployer
  count      = var.existing_orchestrate_instance != null ? 1 : 0
  identifier = var.existing_orchestrate_instance
}

resource "ibm_resource_instance" "orchestrate_instance" {
  provider          = ibm.deployer
  count             = var.existing_orchestrate_instance != null || var.watsonx_orchestrate_plan == local.skip_install ? 0 : 1
  name              = "${local.prefix}watsonx-orchestrate-instance"
  service           = "watsonx-orchestrate"
  plan              = var.watsonx_orchestrate_plan
  location          = var.region
  resource_group_id = module.resource_group.resource_group_id

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

##############################################################################################################
# Configure User
##############################################################################################################

module "configure_user" {
  providers = {
    ibm.deployer = ibm.deployer
  }
  source            = "git::https://github.com/terraform-ibm-modules/terraform-ibm-watsonx-saas-da.git//configure_user?ref=issue-16994"
  resource_group_id = module.resource_group.resource_group_id
  region            = var.region
}

##############################################################################################################
# Storage Delegation
##############################################################################################################

module "storage_delegation" {
  source = "git::https://github.com/terraform-ibm-modules/terraform-ibm-watsonx-saas-da.git//storage_delegation?ref=issue-16994"
  count  = var.enable_cos_kms_encryption ? 1 : 0
  providers = {
    ibm.deployer                  = ibm.deployer
    restapi.restapi_watsonx_admin = restapi.restapi_watsonx_admin
  }
  cos_guid = local.cos_instance_guid

  # KMS fields
  cos_kms_ring_id      = var.cos_kms_ring_id
  cos_kms_crn          = var.cos_kms_crn
  cos_kms_key_crn      = var.cos_kms_key_crn
  cos_kms_new_key_name = local.cos_kms_new_key_name
}

##############################################################################################################
# Configure Project
##############################################################################################################

module "configure_project" {
  source = "git::https://github.com/terraform-ibm-modules/terraform-ibm-watsonx-saas-da.git//configure_project?ref=issue-16994"
  providers = {
    restapi.restapi_watsonx_admin = restapi.restapi_watsonx_admin
  }
  depends_on = [module.storage_delegation]
  count      = var.watsonx_project_name == null || var.watsonx_project_name == "" ? 0 : 1
  region     = var.region

  # watsonx Project
  watsonx_project_name        = "${local.prefix}${var.watsonx_project_name}"
  watsonx_project_description = var.watsonx_project_description
  watsonx_project_tags        = var.watsonx_project_tags
  watsonx_mark_as_sensitive   = var.watsonx_mark_as_sensitive

  # Machine Learning
  machine_learning_guid = local.watson_machine_learning_guid
  machine_learning_crn  = local.watson_machine_learning_crn
  machine_learning_name = local.watson_machine_learning_name

  # COS / Storage delegation
  watsonx_project_delegated = local.is_storage_delegated
  cos_guid                  = local.cos_instance_guid
  cos_crn                   = local.cos_instance_crn
}
