data "ibm_iam_auth_token" "tokendata" {}

resource "null_resource" "configure_user" {
  depends_on = [data.ibm_iam_auth_token.tokendata]
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command     = "${path.module}/scripts/add_user.sh"
    interpreter = ["/bin/bash", "-c"]
    environment = {
      iam_token         = data.ibm_iam_auth_token.tokendata.iam_access_token
      resource_group_id = var.resource_group_id
      location          = var.region
    }
  }
}

resource "null_resource" "restrict_access" {
  depends_on = [data.ibm_iam_auth_token.tokendata]
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command     = "${path.module}/scripts/enforce_account_restriction.sh"
    interpreter = ["/bin/bash", "-c"]
    environment = {
      iam_token = data.ibm_iam_auth_token.tokendata.iam_access_token
      location  = var.region
    }
  }
}
