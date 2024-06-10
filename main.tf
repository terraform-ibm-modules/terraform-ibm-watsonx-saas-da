locals {
  is_storage_delegated = var.cos_kms_crn == null || var.cos_kms_crn == "" ? false : true
}

data "ibm_iam_auth_token" "restapi" {
  provider = ibm.watsonx_admin
}

module "resource_group" {
  providers = {
    ibm = ibm.deployer
  }
  source                       = "terraform-ibm-modules/resource-group/ibm"
  version                      = "1.1.5"
  resource_group_name          = var.use_existing_resource_group == false ? var.resource_group_name : null
  existing_resource_group_name = var.use_existing_resource_group == true ? var.resource_group_name : null
}

module "cos" {
  providers = {
    ibm = ibm.deployer
  }
  source            = "terraform-ibm-modules/cos/ibm//modules/fscloud"
  version           = "8.3.2"
  resource_group_id = module.resource_group.resource_group_id
  cos_instance_name = "${var.resource_prefix}-cos-instance"
  cos_plan          = var.cos_plan
}

resource "ibm_resource_instance" "studio_instance" {
  provider          = ibm.deployer
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

resource "ibm_resource_instance" "machine_learning_instance" {
  provider          = ibm.deployer
  name              = "${var.resource_prefix}-watson-machine-learning-instance"
  service           = "pm-20"
  plan              = var.watson_machine_learning_plan
  location          = var.location
  resource_group_id = module.resource_group.resource_group_id

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "ibm_resource_instance" "assistant_instance" {
  provider          = ibm.deployer
  count             = var.watsonx_assistant_plan == "do not install" ? 0 : 1
  name              = "${var.resource_prefix}-watsonx-assistant-instance"
  service           = "conversation"
  plan              = var.watsonx_assistant_plan
  location          = var.location
  resource_group_id = module.resource_group.resource_group_id

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "ibm_resource_instance" "governance_instance" {
  provider          = ibm.deployer
  count             = var.watsonx_governance_plan == "do not install" ? 0 : 1
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
}

resource "ibm_resource_instance" "discovery_instance" {
  provider          = ibm.deployer
  count             = var.watson_discovery_plan == "do not install" ? 0 : 1
  name              = "${var.resource_prefix}-watson-discovery-instance"
  service           = "discovery"
  plan              = var.watson_discovery_plan
  location          = var.location
  resource_group_id = module.resource_group.resource_group_id

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

module "configure_user" {
  source                = "./configure_user"
  watsonx_admin_api_key = var.watsonx_admin_api_key == null || var.watsonx_admin_api_key == "" ? var.ibmcloud_api_key : var.watsonx_admin_api_key
  resource_group_id     = module.resource_group.resource_group_id
}

module "storage_delegation" {
  source     = "./storage_delegation"
  depends_on = [module.cos]
  providers = {
    ibm.deployer                  = ibm.deployer
    restapi.restapi_watsonx_admin = restapi.restapi_watsonx_admin
  }
  count                = var.cos_kms_crn == null || var.cos_kms_crn == "" ? 0 : 1
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
  machine_learning_guid       = ibm_resource_instance.machine_learning_instance.guid
  machine_learning_crn        = ibm_resource_instance.machine_learning_instance.crn
  machine_learning_name       = ibm_resource_instance.machine_learning_instance.resource_name
  cos_guid                    = module.cos.cos_instance_guid
  cos_crn                     = module.cos.cos_instance_crn
  watsonx_project_delegated   = local.is_storage_delegated
}
