resource "restapi_object" "configure_project" {
  provider       = restapi.restapi_watsonx_admin
  path           = local.dataplatform_api
  read_path      = "${local.dataplatform_api}{id}"
  read_method    = "GET"
  create_path    = "${local.dataplatform_api}/transactional/v2/projects?verify_unique_name=true"
  create_method  = "POST"
  id_attribute   = "location"
  destroy_method = "DELETE"
  destroy_path   = "${local.dataplatform_api}/transactional{id}"
  data           = <<-EOT
                  {
                    "name": "${var.watsonx_project_name}",
                    "generator": "watsonx-saas-da",
                    "type": "wx",
                    "storage": {
                      "type": "bmcos_object_storage",
                      "guid": "${var.cos_guid}",
                      "resource_crn": "${var.cos_crn}",
                      "delegated": ${var.watsonx_project_delegated}
                    },
                    "description": "${var.watsonx_project_description}",
                    "public": true,
                    "tags": ${jsonencode(var.watsonx_project_tags)},
                    "compute": [
                      {
                        "name": "${var.machine_learning_name}",
                        "guid": "${var.machine_learning_guid}",
                        "type": "machine_learning",
                        "crn": "${var.machine_learning_crn}"
                      }
                    ]
                  }
                  EOT
  update_method  = "PATCH"
  update_path    = "${local.dataplatform_api}{id}"
  update_data    = <<-EOT
                  {
                    "name": "${var.watsonx_project_name}",
                    "type": "wx",
                    "description": "${var.watsonx_project_description}",
                    "public": true,
                    "compute": [
                      {
                        "name": "${var.machine_learning_name}",
                        "guid": "${var.machine_learning_guid}",
                        "type": "machine_learning",
                        "crn": "${var.machine_learning_crn}",
                        "credentials": {}
                      }
                    ]
                  }
                  EOT
}

resource "time_sleep" "wait_10_seconds" {
  depends_on      = [restapi_object.configure_project]
  create_duration = "10s"
}

data "restapi_object" "get_project" {
  depends_on   = [resource.restapi_object.configure_project, resource.time_sleep.wait_10_seconds]
  provider     = restapi.restapi_watsonx_admin
  path         = "${local.dataplatform_api}/v2/projects"
  results_key  = "resources"
  search_key   = "metadata/guid"
  search_value = local.watsonx_project_id
  id_attribute = "metadata/guid"
}

locals {
  dataplatform_api_mapping = {
    "us-south" = "//api.dataplatform.cloud.ibm.com",
    "eu-gb"    = "//api.eu-uk.dataplatform.cloud.ibm.com",
    "eu-de"    = "//api.eu-de.dataplatform.cloud.ibm.com",
    "jp-tok"   = "//api.jp-tok.dataplatform.cloud.ibm.com"
  }
  dataplatform_api          = local.dataplatform_api_mapping[var.location]
  watsonx_project_id_object = restapi_object.configure_project.id
  watsonx_project_id        = regex("^.+/([a-f0-9\\-]+)$", local.watsonx_project_id_object)[0]
  watsonx_project_data      = jsondecode(data.restapi_object.get_project.api_response)
}
