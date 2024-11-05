locals {

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
  watsonx_data_datacenter    = local.watsonx_data_datacenter_mapping[var.location]
  watsonx_data_crn           = var.existing_data_instance != null ? data.ibm_resource_instance.existing_data_instance[0].crn : var.watsonx_data_plan != "do not install" ? resource.ibm_resource_instance.data_instance[0].crn : null
  watsonx_data_guid          = var.existing_data_instance != null ? data.ibm_resource_instance.existing_data_instance[0].guid : var.watsonx_data_plan != "do not install" ? resource.ibm_resource_instance.data_instance[0].guid : null
  watsonx_data_name          = var.existing_data_instance != null ? data.ibm_resource_instance.existing_data_instance[0].resource_name : var.watsonx_data_plan != "do not install" ? resource.ibm_resource_instance.data_instance[0].resource_name : null
  watsonx_data_plan_id       = var.existing_data_instance != null ? null : var.watsonx_data_plan != "do not install" ? resource.ibm_resource_instance.data_instance[0].resource_plan_id : null
  watsonx_data_dashboard_url = var.existing_data_instance != null ? null : var.watsonx_data_plan != "do not install" ? resource.ibm_resource_instance.data_instance[0].dashboard_url : null
}

module "resource_group" {
  source                       = "terraform-ibm-modules/resource-group/ibm"
  version                      = "1.1.6"
  resource_group_name          = var.use_existing_resource_group == false ? var.resource_group_name : null
  existing_resource_group_name = var.use_existing_resource_group == true ? var.resource_group_name : null
}

data "ibm_resource_instance" "existing_data_instance" {
  count      = var.existing_data_instance != null ? 1 : 0
  identifier = var.existing_data_instance
}

resource "ibm_resource_instance" "data_instance" {
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
    use_case : "ai"
  }
}
