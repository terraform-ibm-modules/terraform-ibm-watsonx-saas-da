data "ibm_iam_auth_token" "tokendata" {}

locals {
  sensitive_tokendata = sensitive(data.ibm_iam_auth_token.tokendata.iam_access_token)
  binaries_path = "/tmp"
}

resource "terraform_data" "install_required_binaries" {
  count = var.install_required_binaries ? 1 : 0
  triggers_replace    = {
    iam_token         = local.sensitive_tokendata
    resource_group_id = var.resource_group_id
    location          = var.region
    
  }
  provisioner "local-exec" {
    command     = "${path.module}/scripts/install-binaries.sh ${local.binaries_path}"
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "terraform_data" "configure_user" {
  depends_on = [data.ibm_iam_auth_token.tokendata,terraform_data.install_required_binaries]
  triggers_replace = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command     = "${path.module}/scripts/add_user.sh ${local.binaries_path}"
    interpreter = ["/bin/bash", "-c"]
    environment = {
      iam_token         = local.sensitive_tokendata
      resource_group_id = var.resource_group_id
      location          = var.region
    }
  }
}

resource "terraform_data" "restrict_access" {
  depends_on = [data.ibm_iam_auth_token.tokendata,terraform_data.install_required_binaries]
  triggers_replace = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command     = "${path.module}/scripts/enforce_account_restriction.sh ${local.binaries_path}"
    interpreter = ["/bin/bash", "-c"]
    environment = {
      iam_token = local.sensitive_tokendata
      location  = var.region
    }
  }
}
