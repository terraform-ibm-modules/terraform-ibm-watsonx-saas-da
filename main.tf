locals {
  unique_identifier = random_string.unique_identifier.result
}

# data "ibm_iam_auth_token" "tokendata" {}

# Access random string generated with random_string.unique_identifier.result
resource "random_string" "unique_identifier" {
  length  = 6
  special = false
  upper   = false
}

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.5"
  # If an existing resource group is not set (null), then create a new one
  resource_group_name          = var.resource_group_name == null ? local.unique_identifier : null
  existing_resource_group_name = var.resource_group_name
}

module "cos" {
  source            = "terraform-ibm-modules/cos/ibm//modules/fscloud"
  version           = "7.5.3"
  resource_group_id = module.resource_group.resource_group_id
  cos_instance_name = "${var.resource_prefix}-cos-instance"
  cos_plan          = var.cos_plan
}

resource "ibm_resource_instance" "studio_instance" {
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
  count             = var.watson_assistant_plan == "do not install" ? 0 : 1
  name              = "${var.resource_prefix}-watson-assistant-instance"
  service           = "conversation"
  plan              = var.watson_assistant_plan
  location          = var.location
  resource_group_id = module.resource_group.resource_group_id

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "ibm_resource_instance" "governance_instance" {
  count             = var.watson_governance_plan == "do not install" ? 0 : 1
  name              = "${var.resource_prefix}-watson-governance-instance"
  service           = "aiopenscale"
  plan              = var.watson_governance_plan
  location          = var.location
  resource_group_id = module.resource_group.resource_group_id

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "ibm_resource_instance" "discovery_instance" {
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
  depends_on        = [ibm_resource_instance.machine_learning_instance, ibm_resource_instance.studio_instance]
  source            = "./configure_user"
  location          = var.location
  ibmcloud_api_key  = var.ibmcloud_api_key
  resource_group_id = module.resource_group.resource_group_id
}

module "configure_project" {
  depends_on            = [module.configure_user]
  source                = "./configure_project"
  ibmcloud_api_key      = var.ibmcloud_api_key
  project_name          = var.project_name
  project_description   = var.project_description
  project_tags          = var.project_tags
  machine_learning_guid = ibm_resource_instance.machine_learning_instance.guid
  machine_learning_crn  = ibm_resource_instance.machine_learning_instance.crn
  machine_learning_name = ibm_resource_instance.machine_learning_instance.resource_name
  cos_guid              = module.cos.cos_instance_guid
  cos_crn               = module.cos.cos_instance_crn
}
