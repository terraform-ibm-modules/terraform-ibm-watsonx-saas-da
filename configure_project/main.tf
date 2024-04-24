data "ibm_iam_auth_token" "tokendata" {}

resource "restapi_object" "configure_project" {
  depends_on     = [data.ibm_iam_auth_token.tokendata]
  count          = var.watsonx_project_name == null ? 0 : 1
  path           = "//api.dataplatform.cloud.ibm.com"
  read_path      = "//api.dataplatform.cloud.ibm.com{id}"
  read_method    = "GET"
  create_path    = "//api.dataplatform.cloud.ibm.com/transactional/v2/projects?verify_unique_name=true"
  create_method  = "POST"
  id_attribute   = "location"
  destroy_method = "DELETE"
  destroy_path   = "//api.dataplatform.cloud.ibm.com/transactional{id}"
  data           = <<-EOT
                  {
                    "name": "${local.watsonx_project_name}",
                    "generator": "watsonx-saas-da",
                    "type": "wx",
                    "storage": {
                      "type": "bmcos_object_storage",
                      "guid": "${var.cos_guid}",
                      "resource_crn": "${var.cos_crn}"
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
  update_path    = "//api.dataplatform.cloud.ibm.com{id}"
  update_data    = <<-EOT
                  {
                    "name": "${local.watsonx_project_name}",
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

locals {
  watsonx_project_name      = var.watsonx_project_name_suffix != null ? "${var.watsonx_project_name}-${var.watsonx_project_name_suffix}" : var.watsonx_project_name
  watsonx_project_id_object = restapi_object.configure_project[0].id
  watsonx_project_id        = regex("^.+/([a-f0-9\\-]+)$", local.watsonx_project_id_object)[0]
}
