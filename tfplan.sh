export TF_VAR_PREFIX=$TF_VAR_PREFIX-$(date +%F)
export TF_VAR_VSTS_TOKEN=$(az keyvault secret show --vault-name "$1" --name "$2-vsts-token"  --query value -o tsv)

export ARM_CLIENT_ID=$(az keyvault secret show --vault-name "$1" --name "$2-clientid"  --query value -o tsv)
export ARM_CLIENT_SECRET=$(az keyvault secret show --vault-name "$1" --name "$2-clientsecret"  --query value -o tsv)
export ARM_SUBSCRIPTION_ID=$(az keyvault secret show --vault-name "$1" --name "$2-subscriptionid"  --query value -o tsv)
export ARM_TENANT_ID=$(az keyvault secret show --vault-name "$1" --name "$2-tenantid"  --query value -o tsv)

terraform init

echo "Execute Terraform plan"
terraform plan -out=tfplan -input=false

echo "Execute Terraform apply"
terraform apply "tfplan"
