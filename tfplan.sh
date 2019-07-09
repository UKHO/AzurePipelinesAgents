export TF_VAR_PREFIX=$TF_VAR_PREFIX-$(date +%F)
export TF_VAR_VSTS_TOKEN=$(az keyvault secret show --vault-name "tpe-keyvault" --name "terraform-ukhogov-vsts-token"  --query value -o tsv)
export ARM_CLIENT_ID=$(az keyvault secret show --vault-name "tpe-keyvault" --name "terraform-ukhogov-clientid"  --query value -o tsv)
export ARM_CLIENT_SECRET=$(az keyvault secret show --vault-name "tpe-keyvault" --name "terraform-ukhogov-clientsecret"  --query value -o tsv)
export ARM_SUBSCRIPTION_ID=$(az keyvault secret show --vault-name "tpe-keyvault" --name "terraform-ukhogov-subscriptionid"  --query value -o tsv)
export ARM_TENANT_ID=$(az keyvault secret show --vault-name "tpe-keyvault" --name "terraform-ukhogov-tenantid"  --query value -o tsv)
echo "Execute Terraform plan"
terraform plan -out=tfplan -input=false

echo "Execute Terraform apply"
terraform apply "tfplan"
