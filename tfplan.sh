#! /bin/bash

export vaultName="AzDOLive-keyvault"
export keyPrefix="TERRAFORM"
export TF_VAR_RUN_DATE=$(date +%F)

export ARM_CLIENT_ID=$(az keyvault secret show --vault-name "$vaultName" --name "$keyPrefix-client-id"  --query value -o tsv)
export ARM_CLIENT_SECRET=$(az keyvault secret show --vault-name "$vaultName" --name "$keyPrefix-client-secret"  --query value -o tsv)
export ARM_SUBSCRIPTION_ID=$(az keyvault secret show --vault-name "$vaultName" --name "$keyPrefix-subscription-id"  --query value -o tsv)
export ARM_TENANT_ID=$(az keyvault secret show --vault-name "$vaultName" --name "$keyPrefix-tenant-id"  --query value -o tsv)
export ARM_ACCESS_KEY=$(az keyvault secret show --vault-name "$vaultName" --name "$keyPrefix-access-key"  --query value -o tsv)

# ./secret is a bash script, but does not get execution rights when recieved by the build agent.
chmod 755 ./secret


make init

echo "Execute Terraform plan"
make plan

echo "Execute Terraform apply"
make apply

