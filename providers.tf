provider "azurerm" {
  version         = "~> 1.21"
  client_id       = "${var.AZURE_CLIENT_ID}"
  subscription_id = "${var.AZURE_SUBSCRIPTION_ID}"
  client_secret   = "${var.AZURE_CLIENT_SECRET}"
  tenant_id       = "${var.AZURE_TENANT_ID}"
}