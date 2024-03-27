data "ibm_iam_auth_token" "tokendata" {}

locals {
  sensitive_tokendata = sensitive(data.ibm_iam_auth_token.tokendata.iam_access_token)
}

resource "null_resource" "configure_user" {

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOF
      #!/bin/bash
      token="$(echo "${local.sensitive_tokendata}" | awk '{print $2}')"

      # decode the iam token
      jwt_decode(){
        jq -R 'split(".") | .[1] | @base64d | fromjson' <<< "$1"
      }
      token_decoded="$(jwt_decode "$token")"
      email="$(echo "$token_decoded" | jq -r .email)"
      iam_id="$(echo "$token_decoded" | jq -r .iam_id)"
      display_name="$(echo "$token_decoded" | jq -r .name)"
      bss_account_id="$(echo "$token_decoded" | jq -r .account.bss)"

      # check if user is already configured
      # API returns an error 500 if the user is not configured, otherwise it returns the user details
      user_details="$(curl -X GET --location "https://api.dataplatform.cloud.ibm.com/v2/user_profiles/$iam_id" \
        --header 'Content-Type: application/json' \
        --header "Authorization: Bearer $token")"

      # exit if the user is already configured
      echo "$user_details" | jq -e .entity && exit 0

      # configure the user
      curl -X POST --location "https://api.dataplatform.cloud.ibm.com/v2/user_profiles" \
      --header 'Content-Type: application/json' \
      --header "Authorization: Bearer $token" \
      --data-raw "{
              \"name\": \"$email\",
              \"iam_id\": \"$iam_id\",
              \"display_name\": \"$display_name\",
              \"email\": \"$email\",
              \"state\": \"ACTIVE\",
              \"bluemix\": {
                  \"active\": true,
                  \"bss_account_id\": \"$bss_account_id\",
                  \"resource_group_guid\": \"${var.resource_group_id}\"
              },
              \"campaign\": {
                  \"uucid\": \"0b526de8c1c419db\",
                  \"utm_content\": \"WXAWW\",
                  \"content_campaign_code\": \"WXAWW\"
              }
      }"
    EOF
  }
}

resource "null_resource" "restrict_access" {

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOF
      #!/bin/bash
      token="$(echo "${local.sensitive_tokendata}" | awk '{print $2}')"

      # decode the iam token
      jwt_decode(){
        jq -R 'split(".") | .[1] | @base64d | fromjson' <<< "$1"
      }

      token_decoded="$(jwt_decode "$token")"
      bss_account_id="$(echo "$token_decoded" | jq -r .account.bss)"

      # check if force_account_scope setting is already configured
      # API returns an error if the force_account_scope setting is already configured
      account_details="$(curl -X GET --location "https://api.dataplatform.cloud.ibm.com/v2/account_settings/$bss_account_id" \
        --header 'Content-Type: application/json' \
        --header "Authorization: Bearer $token")"

      force_account_scope="$(echo "$account_details" | jq -r .entity.settings.force_account_scope)"

      if [ "$force_account_scope" = true ]; then
        echo "do nothing, account is already configured"
      elif [ "$force_account_scope" = false ]; then
        echo "patching the setting!"
        curl -X PATCH --location "https://api.dataplatform.cloud.ibm.com/v2/account_settings/$bss_account_id" \
        --header 'Content-Type: application/json' \
        --header "Authorization: Bearer $token" \
        --data-raw "{
          \"settings\": {
              \"force_account_scope\": true
          }
        }"
      else
        echo "configuring the setting"
        curl -X POST --location "https://api.dataplatform.cloud.ibm.com/v2/account_settings/$bss_account_id" \
        --header 'Content-Type: application/json' \
        --header "Authorization: Bearer $token" \
        --data-raw "{
          \"settings\": {
              \"force_account_scope\": true
          }
        }"
      fi
    EOF
  }
}
