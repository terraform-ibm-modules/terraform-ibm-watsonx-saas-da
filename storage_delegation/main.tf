locals {
  location = split(":", var.cos_kms_crn)[5]
  dataplatform_ui_mapping = {
    "us-south" = "dataplatform.cloud.ibm.com",
    "eu-gb"    = "eu-gb.dataplatform.cloud.ibm.com",
    "eu-de"    = "eu-de.dataplatform.cloud.ibm.com",
    "jp-tok"   = "jp-tok.dataplatform.cloud.ibm.com"
  }
  dataplatform_ui             = local.dataplatform_ui_mapping[local.location]
  parsed_kms_key_crn          = var.cos_kms_key_crn != null ? split(":", var.cos_kms_key_crn) : []
  kms_service                 = length(local.parsed_kms_key_crn) > 0 ? local.parsed_kms_key_crn[4] : null
  kms_scope                   = length(local.parsed_kms_key_crn) > 0 ? local.parsed_kms_key_crn[6] : null
  kms_account_id              = length(local.parsed_kms_key_crn) > 0 ? split("/", local.kms_scope)[1] : null
  kms_key_id                  = length(local.parsed_kms_key_crn) > 0 ? local.parsed_kms_key_crn[9] : null
  target_resource_instance_id = split(":", var.cos_kms_crn)[7]
}

resource "ibm_iam_authorization_policy" "cos_s2s_keyprotect" {
  provider                    = ibm.deployer
  source_service_name         = "cloud-object-storage"
  source_resource_instance_id = var.cos_guid
  resource_attributes {
    name     = "serviceName"
    operator = "stringEquals"
    value    = local.kms_service
  }
  resource_attributes {
    name     = "accountId"
    operator = "stringEquals"
    value    = local.kms_account_id
  }
  resource_attributes {
    name     = "serviceInstance"
    operator = "stringEquals"
    value    = local.target_resource_instance_id
  }
  resource_attributes {
    name     = "resourceType"
    operator = "stringEquals"
    value    = "key"
  }
  resource_attributes {
    name     = "resource"
    operator = "stringEquals"
    value    = local.kms_key_id
  }
  # Scope of policy now includes the key, so ensure to create new policy before
  # destroying old one to prevent any disruption to every day services.
  lifecycle {
    create_before_destroy = true
  }
  roles = ["Reader"]
}

resource "time_sleep" "wait_for_authorization_policy" {
  depends_on = [ibm_iam_authorization_policy.cos_s2s_keyprotect]
  # workaround for https://github.com/IBM-Cloud/terraform-provider-ibm/issues/4478
  create_duration = "30s"
  # workaround for https://github.com/terraform-ibm-modules/terraform-ibm-cos/issues/672
  destroy_duration = "30s"
}

data "ibm_resource_instance" "kms_instance" {
  provider   = ibm.deployer
  identifier = var.cos_kms_crn
}

resource "ibm_kms_key" "kms_key" {
  provider      = ibm.deployer
  count         = var.cos_kms_key_crn == null || var.cos_kms_key_crn == "" ? 1 : 0
  instance_id   = var.cos_kms_crn
  key_name      = var.cos_kms_new_key_name
  standard_key  = false
  force_delete  = true
  endpoint_type = try(jsondecode(data.ibm_resource_instance.kms_instance.parameters_json).allowed_network, "{}") == "private-only" ? "private" : "public"
  key_ring_id   = var.cos_kms_ring_id == null || var.cos_kms_ring_id == "" ? "default" : var.cos_kms_ring_id
}

data "ibm_kms_key" "kms_key" {
  provider      = ibm.deployer
  depends_on    = [resource.ibm_kms_key.kms_key]
  endpoint_type = try(jsondecode(data.ibm_resource_instance.kms_instance.parameters_json).allowed_network, "{}") == "private-only" ? "private" : "public"
  instance_id   = var.cos_kms_crn
  key_id        = var.cos_kms_key_crn == null || var.cos_kms_key_crn == "" ? resource.ibm_kms_key.kms_key[0].key_id : split(":", var.cos_kms_key_crn)[9]
}

resource "restapi_object" "storage_delegation" {
  provider       = restapi.restapi_watsonx_admin
  depends_on     = [time_sleep.wait_for_authorization_policy, data.ibm_kms_key.kms_key]
  path           = "//${local.dataplatform_ui}/api/rest/v1/storage-delegations"
  read_path      = "//${local.dataplatform_ui}/api/rest/v1/storage-delegations/{id}"
  read_method    = "GET"
  create_path    = "//${local.dataplatform_ui}/api/rest/v1/storage-delegations"
  create_method  = "POST"
  id_attribute   = var.cos_guid
  object_id      = var.cos_guid
  destroy_method = "DELETE"
  destroy_path   = "//${local.dataplatform_ui}/api/rest/v1/storage-delegations/{id}"
  data           = <<-EOT
                  {
                    "cos_instance_id": "${var.cos_guid}",
                    "kms_key_crn": "${data.ibm_kms_key.kms_key.keys[0].crn}",
                    "catalogs": true,
                    "projects": true
                  }
                  EOT
}
