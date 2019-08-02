#! /bin/bash

export vaultName="AzDOLive-keyvault"
export keyPrefix="terraform-azdolive"
export TF_VAR_PREFIX=$TF_VAR_PREFIX-$(date +%F)

export ARM_CLIENT_ID=$(az keyvault secret show --vault-name "$vaultName" --name "$keyPrefix-clientid"  --query value -o tsv)
export ARM_CLIENT_SECRET=$(az keyvault secret show --vault-name "$vaultName" --name "$keyPrefix-clientsecret"  --query value -o tsv)
export ARM_SUBSCRIPTION_ID=$(az keyvault secret show --vault-name "$vaultName" --name "$keyPrefix-subscriptionid"  --query value -o tsv)
export ARM_TENANT_ID=$(az keyvault secret show --vault-name "$vaultName" --name "$keyPrefix-tenantid"  --query value -o tsv)
export ARM_ACCESS_KEY=$(az keyvault secret show --vault-name "$vaultName" --name "$keyPrefix-accesskey"  --query value -o tsv)

chmod 755 ./secret


make init

echo "Execute Terraform plan"
#terraform plan -out=tfplan -input=false
make plan

echo "Execute Terraform apply"
#terraform apply "tfplan"
make apply

