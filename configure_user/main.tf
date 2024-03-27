data "ibm_iam_auth_token" "tokendata" {}

locals {
  sensitive_tokendata = sensitive(data.ibm_iam_auth_token.tokendata.iam_access_token)
}

resource "null_resource" "configure_user" {

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command     = "${path.module}/scripts/add_user.sh \"${local.sensitive_tokendata}\" \"${var.resource_group_id}\""
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "null_resource" "restrict_access" {

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command     = "${path.module}/scripts/enforce_account_restriction.sh \"${local.sensitive_tokendata}\""
    interpreter = ["/bin/bash", "-c"]
  }
}
