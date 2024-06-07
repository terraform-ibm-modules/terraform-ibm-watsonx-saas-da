resource "ibm_iam_authorization_policy" "cos_s2s_keyprotect" {
  provider                    = ibm.deployer
  count                       = var.cos_kms_crn == null || var.cos_kms_crn == "" ? 0 : 1
  source_service_name         = "cloud-object-storage"
  source_resource_instance_id = var.cos_guid
  target_service_name         = "kms"
  target_resource_instance_id = split(":", var.cos_kms_crn)[7]
  roles                       = ["Reader"]
}

resource "ibm_kms_key" "kms_key" {
  provider     = ibm.deployer
  count        = var.cos_kms_key_crn == null || var.cos_kms_key_crn == "" ? 1 : 0
  instance_id  = var.cos_kms_crn
  key_name     = var.cos_kms_new_key_name
  standard_key = false
  force_delete = true
  key_ring_id  = var.cos_kms_ring_id == null || var.cos_kms_ring_id == "" ? "default" : var.cos_kms_ring_id
}

data "ibm_kms_key" "kms_key" {
  provider    = ibm.deployer
  depends_on  = [resource.ibm_kms_key.kms_key]
  instance_id = var.cos_kms_crn
  key_id      = var.cos_kms_key_crn == null || var.cos_kms_key_crn == "" ? resource.ibm_kms_key.kms_key[0].key_id : split(":", var.cos_kms_key_crn)[9]
}

resource "restapi_object" "storage_delegation" {
  provider       = restapi.restapi_watsonx_admin
  count          = var.cos_kms_crn == null || var.cos_kms_crn == "" ? 0 : 1
  depends_on     = [resource.ibm_iam_authorization_policy.cos_s2s_keyprotect, data.ibm_kms_key.kms_key]
  path           = "//dataplatform.cloud.ibm.com/api/rest/v1/storage-delegations"
  read_path      = "//dataplatform.cloud.ibm.com/api/rest/v1/storage-delegations/{id}"
  read_method    = "GET"
  create_path    = "//dataplatform.cloud.ibm.com/api/rest/v1/storage-delegations"
  create_method  = "POST"
  id_attribute   = var.cos_guid
  object_id      = var.cos_guid
  destroy_method = "DELETE"
  destroy_path   = "//dataplatform.cloud.ibm.com/api/rest/v1/storage-delegations/{id}"
  data           = <<-EOT
                  {
                    "cos_instance_id": "${var.cos_guid}",
                    "kms_key_crn": "${data.ibm_kms_key.kms_key.keys[0].crn}",
                    "catalogs": true,
                    "projects": true
                  }
                  EOT
}
