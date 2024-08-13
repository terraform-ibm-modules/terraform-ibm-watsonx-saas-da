#!/usr/bin/env bash

set -e

# shellcheck disable=SC2154
token="$(echo "$iam_token" | awk '{print $2}')"

# decode the iam token
jwt_decode(){
    jq -R 'split(".") | .[1] | @base64d | fromjson' <<< "$1"
}

token_decoded="$(jwt_decode "$token")"
bss_account_id="$(echo "$token_decoded" | jq -r .account.bss)"

# shellcheck disable=SC2154
if [ "$location" == "us-south" ]; then
    dataplatform_api="https://api.dataplatform.cloud.ibm.com"
elif [ "$location" == "eu-gb" ]; then
    dataplatform_api="https://api.eu-uk.dataplatform.cloud.ibm.com"
elif [ "$location" == "eu-de" ]; then
    dataplatform_api="https://api.eu-de.dataplatform.cloud.ibm.com"
elif [ "$location" == "jp-tok" ]; then
    dataplatform_api="https://api.jp-tok.dataplatform.cloud.ibm.com"
else
    echo "Unknown region" && exit 1
fi

# check if force_account_scope setting is already configured
# API returns an error if the force_account_scope setting is already configured
account_details="$(curl -s -X GET --location "$dataplatform_api/v2/account_settings/$bss_account_id" \
    --header 'Content-Type: application/json' \
    --header "Authorization: Bearer $token")"

force_account_scope="$(echo "$account_details" | jq -r .entity.settings.force_account_scope)"

if [ "$force_account_scope" = true ]; then
    echo "Account $bss_account_id is already configured"
elif [ "$force_account_scope" = false ]; then
    echo "patching the setting!"
    curl -s -X PATCH --location "$dataplatform_api/v2/account_settings/$bss_account_id" \
        --header 'Content-Type: application/json' \
        --header "Authorization: Bearer $token" \
        --data-raw "{
            \"settings\": {
                \"force_account_scope\": true
            }
        }"
else
    echo "configuring the setting"
    curl -s -X POST --location "$dataplatform_api/v2/account_settings/$bss_account_id" \
        --header 'Content-Type: application/json' \
        --header "Authorization: Bearer $token" \
        --data-raw "{
            \"settings\": {
                \"force_account_scope\": true
            }
        }"
fi
