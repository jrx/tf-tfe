#!/usr/bin/env bash
set -euo pipefail

echo "INFO: Generating /opt/tfe-installer/settings.conf file."
mkdir -p /opt/tfe-installer/
cat <<EOF > /opt/tfe-installer/settings.conf
{
    "aws_access_key_id": {},
    "aws_instance_profile": {
        "value": "1"
    },
    "aws_secret_access_key": {},
    "azure_account_key": {},
    "azure_account_name": {},
    "azure_container": {},
    "azure_endpoint": {},
    "ca_certs": {},
    "capacity_concurrency": {
        "value": "10"
    },
    "capacity_memory": {
        "value": "512"
    },
    "custom_image_tag": {
        "value": "hashicorp/build-worker:now"
    },
    "disk_path": {},
    "enable_active_active": {
        "value": "1"
    },
    "enable_metrics_collection": {
        "value": "1"
    },
    "enc_password": {
        "value": "${enc_password}"
    },
    "extern_vault_addr": {},
    "extern_vault_enable": {
        "value": "0"
    },
    "extern_vault_path": {},
    "extern_vault_propagate": {},
    "extern_vault_role_id": {},
    "extern_vault_secret_id": {},
    "extern_vault_token_renew": {},
    "extra_no_proxy": {},
    "gcs_bucket": {},
    "gcs_credentials": {
        "value": "{}"
    },
    "gcs_project": {},
    "hostname": {
        "value": "${tfe_hostname}"
    },
    "iact_subnet_list": {},
    "iact_subnet_time_limit": {
        "value": "60"
    },
    "installation_type": {
        "value": "production"
    },
    "pg_dbname": {
        "value": "${database_name}"
    },
    "pg_extra_params": {
        "value": "sslmode=disable"
    },
    "pg_netloc": {
        "value": "${database_endpoint}"
    },
    "pg_password": {
        "value": "${database_password}"
    },
    "pg_user": {
        "value": "${database_username}"
    },
    "placement": {
        "value": "placement_s3"
    },
    "production_type": {
        "value": "external"
    },
    "redis_host" : {
        "value": "${redis_host}"
    },
    "redis_port" : {
        "value": "${redis_port}"
    },
    "redis_use_password_auth" : {
        "value": "1"
    },
    "redis_pass" : {
        "value": "${redis_pass}"
    },
    "redis_use_tls" : {
        "value": "1"
    },
    "s3_bucket": {
        "value": "${s3_bucket}"
    },
    "s3_endpoint": {},
    "s3_region": {
        "value": "${s3_region}"
    },
    "s3_sse": {},
    "s3_sse_kms_key_id": {},
    "tbw_image": {
        "value": "default_image"
    },
    "tls_vers": {
        "value": "tls_1_2_tls_1_3"
    },
   "install_id":{
      "value":"${tfe_hostname}"
   },   
   "root_secret":{
      "value":"c459ff2cd1346ef4c6da4b950ac59423"
   },
   "user_token":{
      "value":"6c403112981d0ae2ce6b4b2c7a1b1997"
   },
   "archivist_token":{
      "value":"8019fe7227d1de1029ad7c1bf6f9e676"
   },
   "cookie_hash":{
      "value":"c8b3227dbb93d73a0cbaa294172aba80"
   },
   "internal_api_token":{
      "value":"da25f5700fc28639334040c3418939db"
   },
   "registry_session_encryption_key":{
      "value":"4d579751597b3bdf6dd7b3eaab3067f5"
   },
   "registry_session_secret_key":{
      "value":"6c1c4d73cc0a6cccbbb61284b0c32b35"
   }
}
EOF
