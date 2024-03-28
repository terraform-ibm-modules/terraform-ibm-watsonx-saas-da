resource "restapi_object" "configure_project" {
  count          = var.project_name == null ? 0 : 1
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
                    "name": "${var.project_name}",
                    "generator": "watsonx-saas-da",
                    "type": "wx",
                    "storage": {
                      "type": "bmcos_object_storage",
                      "guid": "${var.cos_guid}",
                      "resource_crn": "${var.cos_crn}"
                    },
                    "description": "${var.project_description}",
                    "public": true,
                    "tags": ${jsonencode(var.project_tags)},
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
                    "name": "${var.project_name}",
                    "type": "wx",
                    "description": "${var.project_description}",
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
