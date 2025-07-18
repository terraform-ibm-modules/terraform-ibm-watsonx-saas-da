locals {
  is_storage_delegated = var.cos_kms_crn == null || var.cos_kms_crn == "" ? false : true
  dataplatform_ui_mapping = {
    "us-south" = "https://dataplatform.cloud.ibm.com",
    "eu-gb"    = "https://eu-gb.dataplatform.cloud.ibm.com",
    "eu-de"    = "https://eu-de.dataplatform.cloud.ibm.com",
    "jp-tok"   = "https://jp-tok.dataplatform.cloud.ibm.com"
  }
  dataplatform_ui = local.dataplatform_ui_mapping[var.location]
  watsonx_data_datacenter_mapping = {
    "us-south" = "ibm:us-south:dal",
    "eu-gb"    = "ibm:eu-gb:lon",
    "eu-de"    = "ibm:eu-de:fra",
    "jp-tok"   = "ibm:jp-tok:tok"
  }
  watsonx_data_datacenter = local.watsonx_data_datacenter_mapping[var.location]

  # configuring outputs
  watsonx_assistant_crn           = var.existing_assistant_instance != null ? data.ibm_resource_instance.existing_assistant_instance[0].crn : var.watsonx_assistant_plan != "do not install" ? resource.ibm_resource_instance.assistant_instance[0].crn : null
  watsonx_assistant_guid          = var.existing_assistant_instance != null ? data.ibm_resource_instance.existing_assistant_instance[0].guid : var.watsonx_assistant_plan != "do not install" ? resource.ibm_resource_instance.assistant_instance[0].guid : null
  watsonx_assistant_name          = var.existing_assistant_instance != null ? data.ibm_resource_instance.existing_assistant_instance[0].resource_name : var.watsonx_assistant_plan != "do not install" ? ibm_resource_instance.assistant_instance[0].resource_name : null
  watsonx_assistant_plan_id       = var.existing_assistant_instance != null ? null : var.watsonx_assistant_plan != "do not install" ? resource.ibm_resource_instance.assistant_instance[0].resource_plan_id : null
  watsonx_assistant_dashboard_url = var.existing_assistant_instance != null ? null : var.watsonx_assistant_plan != "do not install" ? resource.ibm_resource_instance.assistant_instance[0].dashboard_url : null

  watson_discovery_crn           = var.existing_discovery_instance != null ? data.ibm_resource_instance.existing_discovery_instance[0].crn : var.watson_discovery_plan != "do not install" ? ibm_resource_instance.discovery_instance[0].crn : null
  watson_discovery_guid          = var.existing_discovery_instance != null ? data.ibm_resource_instance.existing_discovery_instance[0].guid : var.watson_discovery_plan != "do not install" ? ibm_resource_instance.discovery_instance[0].guid : null
  watson_discovery_name          = var.existing_discovery_instance != null ? data.ibm_resource_instance.existing_discovery_instance[0].resource_name : var.watson_discovery_plan != "do not install" ? ibm_resource_instance.discovery_instance[0].resource_name : null
  watson_discovery_plan_id       = var.existing_discovery_instance != null ? null : var.watson_discovery_plan != "do not install" ? ibm_resource_instance.discovery_instance[0].resource_plan_id : null
  watson_discovery_dashboard_url = var.existing_discovery_instance != null ? null : var.watson_discovery_plan != "do not install" ? ibm_resource_instance.discovery_instance[0].dashboard_url : null

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

  watsonx_governance_crn           = var.existing_governance_instance != null ? data.ibm_resource_instance.existing_governance_instance[0].crn : var.watsonx_governance_plan != "do not install" ? resource.ibm_resource_instance.governance_instance[0].crn : null
  watsonx_governance_guid          = var.existing_governance_instance != null ? data.ibm_resource_instance.existing_governance_instance[0].guid : var.watsonx_governance_plan != "do not install" ? resource.ibm_resource_instance.governance_instance[0].guid : null
  watsonx_governance_name          = var.existing_governance_instance != null ? data.ibm_resource_instance.existing_governance_instance[0].resource_name : var.watsonx_governance_plan != "do not install" ? resource.ibm_resource_instance.governance_instance[0].resource_name : null
  watsonx_governance_plan_id       = var.existing_governance_instance != null ? null : var.watsonx_governance_plan != "do not install" ? resource.ibm_resource_instance.governance_instance[0].resource_plan_id : null
  watsonx_governance_dashboard_url = var.existing_governance_instance != null ? null : var.watsonx_governance_plan != "do not install" ? resource.ibm_resource_instance.governance_instance[0].dashboard_url : null

  watsonx_data_crn           = var.existing_data_instance != null ? data.ibm_resource_instance.existing_data_instance[0].crn : var.watsonx_data_plan != "do not install" ? resource.ibm_resource_instance.data_instance[0].crn : null
  watsonx_data_guid          = var.existing_data_instance != null ? data.ibm_resource_instance.existing_data_instance[0].guid : var.watsonx_data_plan != "do not install" ? resource.ibm_resource_instance.data_instance[0].guid : null
  watsonx_data_name          = var.existing_data_instance != null ? data.ibm_resource_instance.existing_data_instance[0].resource_name : var.watsonx_data_plan != "do not install" ? resource.ibm_resource_instance.data_instance[0].resource_name : null
  watsonx_data_plan_id       = var.existing_data_instance != null ? null : var.watsonx_data_plan != "do not install" ? resource.ibm_resource_instance.data_instance[0].resource_plan_id : null
  watsonx_data_dashboard_url = var.existing_data_instance != null ? null : var.watsonx_data_plan != "do not install" ? resource.ibm_resource_instance.data_instance[0].dashboard_url : null

  watsonx_orchestrate_crn           = var.existing_orchestrate_instance != null ? data.ibm_resource_instance.existing_orchestrate_instance[0].crn : var.watsonx_orchestrate_plan != "do not install" ? resource.ibm_resource_instance.orchestrate_instance[0].crn : null
  watsonx_orchestrate_guid          = var.existing_orchestrate_instance != null ? data.ibm_resource_instance.existing_orchestrate_instance[0].guid : var.watsonx_orchestrate_plan != "do not install" ? resource.ibm_resource_instance.orchestrate_instance[0].guid : null
  watsonx_orchestrate_name          = var.existing_orchestrate_instance != null ? data.ibm_resource_instance.existing_orchestrate_instance[0].resource_name : var.watsonx_orchestrate_plan != "do not install" ? resource.ibm_resource_instance.orchestrate_instance[0].resource_name : null
  watsonx_orchestrate_plan_id       = var.existing_orchestrate_instance != null ? null : var.watsonx_orchestrate_plan != "do not install" ? resource.ibm_resource_instance.orchestrate_instance[0].resource_plan_id : null
  watsonx_orchestrate_dashboard_url = var.existing_orchestrate_instance != null ? null : var.watsonx_orchestrate_plan != "do not install" ? resource.ibm_resource_instance.orchestrate_instance[0].dashboard_url : null

  # input variable validation
  # tflint-ignore: terraform_unused_declarations
  validate_encryption_inputs = var.enable_cos_kms_encryption && (var.cos_kms_crn == null || var.cos_kms_crn == "") ? tobool("A value must be passed for 'cos_kms_crn' when 'enable_cos_kms_encryption' is set to true") : true

  # tflint-ignore: terraform_unused_declarations
  validate_enable_cos_kms_encryption = (var.cos_kms_crn != null || var.cos_kms_key_crn != null) && var.enable_cos_kms_encryption == false ? tobool("If a value for 'cos_kms_crn' or 'cos_kms_key_crn' is passed then 'enable_cos_kms_encryption' must be set to true") : true
}

data "ibm_iam_auth_token" "restapi" {
  provider = ibm.watsonx_admin
}

module "resource_group" {
  providers = {
    ibm = ibm.deployer
  }
  source                       = "terraform-ibm-modules/resource-group/ibm"
  version                      = "1.2.0"
  resource_group_name          = var.use_existing_resource_group == false ? var.resource_group_name : null
  existing_resource_group_name = var.use_existing_resource_group == true ? var.resource_group_name : null
}

module "cos" {
  providers = {
    ibm = ibm.deployer
  }
  source            = "terraform-ibm-modules/cos/ibm//modules/fscloud"
  version           = "10.1.2"
  resource_group_id = module.resource_group.resource_group_id
  cos_instance_name = "${var.resource_prefix}-cos-instance"
  cos_plan          = var.cos_plan
}

data "ibm_resource_instance" "existing_studio_instance" {
  provider   = ibm.deployer
  count      = var.existing_studio_instance != null ? 1 : 0
  identifier = var.existing_studio_instance
}

resource "ibm_resource_instance" "studio_instance" {
  provider          = ibm.deployer
  count             = var.existing_studio_instance != null ? 0 : 1
  name              = "${var.resource_prefix}-watson-studio-instance"
  service           = "data-science-experience"
  plan              = var.watson_studio_plan
  location          = var.location
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

data "ibm_resource_instance" "existing_machine_learning_instance" {
  provider   = ibm.deployer
  count      = var.existing_machine_learning_instance != null ? 1 : 0
  identifier = var.existing_machine_learning_instance
}

resource "ibm_resource_instance" "machine_learning_instance" {
  provider          = ibm.deployer
  count             = var.existing_machine_learning_instance != null ? 0 : 1
  name              = "${var.resource_prefix}-watson-machine-learning-instance"
  service           = "pm-20"
  plan              = var.watson_machine_learning_plan
  location          = var.location
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
      condition     = contains(["lite"], var.watson_machine_learning_plan) ? var.watson_machine_learning_service_endpoints == "public" : true
      error_message = "The lite plan only supports public endpoints."
    }
  }
}

moved {
  from = ibm_resource_instance.machine_learning_instance
  to   = ibm_resource_instance.machine_learning_instance[0]
}

data "ibm_resource_instance" "existing_assistant_instance" {
  provider   = ibm.deployer
  count      = var.existing_assistant_instance != null ? 1 : 0
  identifier = var.existing_assistant_instance
}

resource "ibm_resource_instance" "assistant_instance" {
  provider          = ibm.deployer
  count             = var.existing_assistant_instance != null ? 0 : var.watsonx_assistant_plan == "do not install" ? 0 : 1
  name              = "${var.resource_prefix}-watsonx-assistant-instance"
  service           = "conversation"
  plan              = var.watsonx_assistant_plan
  location          = var.location
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
      condition     = contains(["free", "plus-trial"], var.watsonx_assistant_plan) ? var.watsonx_assistant_service_endpoints == "public" : true
      error_message = "The lite and trial plans only support public endpoints."
    }
  }
}

data "ibm_resource_instance" "existing_governance_instance" {
  provider   = ibm.deployer
  count      = var.existing_governance_instance != null ? 1 : 0
  identifier = var.existing_governance_instance
}

resource "ibm_resource_instance" "governance_instance" {
  provider          = ibm.deployer
  count             = var.existing_governance_instance != null ? 0 : var.watsonx_governance_plan == "do not install" ? 0 : 1
  name              = "${var.resource_prefix}-watsonx-governance-instance"
  service           = "aiopenscale"
  plan              = var.watsonx_governance_plan
  location          = var.location
  resource_group_id = module.resource_group.resource_group_id

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }

  lifecycle {
    precondition {
      condition     = contains(["eu-de", "us-south"], var.location)
      error_message = "watsonx.governance is only available in eu-de and us-south regions."
    }
  }
}

data "ibm_resource_instance" "existing_discovery_instance" {
  provider   = ibm.deployer
  count      = var.existing_discovery_instance != null ? 1 : 0
  identifier = var.existing_discovery_instance
}

resource "ibm_resource_instance" "discovery_instance" {
  provider          = ibm.deployer
  count             = var.existing_discovery_instance != null ? 0 : var.watson_discovery_plan == "do not install" ? 0 : 1
  name              = "${var.resource_prefix}-watson-discovery-instance"
  service           = "discovery"
  plan              = var.watson_discovery_plan
  location          = var.location
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

data "ibm_resource_instance" "existing_data_instance" {
  provider   = ibm.deployer
  count      = var.existing_data_instance != null ? 1 : 0
  identifier = var.existing_data_instance
}

resource "ibm_resource_instance" "data_instance" {
  provider          = ibm.deployer
  count             = var.existing_data_instance != null ? 0 : var.watsonx_data_plan == "do not install" ? 0 : 1
  name              = "${var.resource_prefix}-watsonx-data-instance"
  service           = "lakehouse"
  plan              = var.watsonx_data_plan
  location          = var.location
  resource_group_id = module.resource_group.resource_group_id

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }

  parameters = {
    datacenter : local.watsonx_data_datacenter
    cloud_type : "ibm"
    region : var.location
  }
}

data "ibm_resource_instance" "existing_orchestrate_instance" {
  provider   = ibm.deployer
  count      = var.existing_orchestrate_instance != null ? 1 : 0
  identifier = var.existing_orchestrate_instance
}

resource "ibm_resource_instance" "orchestrate_instance" {
  provider          = ibm.deployer
  count             = var.existing_orchestrate_instance != null ? 0 : var.watsonx_orchestrate_plan == "do not install" ? 0 : 1
  name              = "${var.resource_prefix}-watsonx-orchestrate-instance"
  service           = "watsonx-orchestrate"
  plan              = var.watsonx_orchestrate_plan
  location          = var.location
  resource_group_id = module.resource_group.resource_group_id

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }

  lifecycle {
    precondition {
      condition     = contains(["us-south"], var.location)
      error_message = "watsonx Orchestrate is only available in us-south region."
    }
  }
}

module "configure_user" {
  source                = "./configure_user"
  watsonx_admin_api_key = var.watsonx_admin_api_key == null || var.watsonx_admin_api_key == "" ? var.ibmcloud_api_key : var.watsonx_admin_api_key
  resource_group_id     = module.resource_group.resource_group_id
  location              = var.location
}

module "storage_delegation" {
  source     = "./storage_delegation"
  depends_on = [module.cos]
  providers = {
    ibm.deployer                  = ibm.deployer
    restapi.restapi_watsonx_admin = restapi.restapi_watsonx_admin
  }
  count                = var.enable_cos_kms_encryption ? 1 : 0
  cos_kms_crn          = var.cos_kms_crn
  cos_kms_key_crn      = var.cos_kms_key_crn
  cos_kms_new_key_name = "${var.resource_prefix}-${var.cos_kms_new_key_name}"
  cos_kms_ring_id      = var.cos_kms_ring_id
  cos_guid             = module.cos.cos_instance_guid
}

module "configure_project" {
  source = "./configure_project"
  providers = {
    restapi.restapi_watsonx_admin = restapi.restapi_watsonx_admin
  }
  depends_on                  = [module.storage_delegation]
  count                       = var.watsonx_project_name == null || var.watsonx_project_name == "" ? 0 : 1
  watsonx_project_name        = "${var.resource_prefix}-${var.watsonx_project_name}"
  watsonx_project_description = var.watsonx_project_description
  watsonx_project_tags        = var.watsonx_project_tags
  watsonx_mark_as_sensitive   = var.watsonx_mark_as_sensitive
  machine_learning_guid       = local.watson_machine_learning_guid
  machine_learning_crn        = local.watson_machine_learning_crn
  machine_learning_name       = local.watson_machine_learning_name
  cos_guid                    = module.cos.cos_instance_guid
  cos_crn                     = module.cos.cos_instance_crn
  watsonx_project_delegated   = local.is_storage_delegated
  location                    = var.location
}
