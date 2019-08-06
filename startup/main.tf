terraform {
  backend "azurerm" {
    resource_group_name  = "AzDoLive-rg"
    storage_account_name = "azdolivestorageaccount"
    container_name       = "azdolivecontainer"
    key                  = "subscription.tfstate"
  }
}

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {

}

data "azurerm_resource_group" "main" {
  name = "${var.PROJECT_IDENTITY}-rg"
}

module "keyvault4tf" {
    source              = "github.com/ukho/terraform-modules/TerraformKeyVaultSecrets"
    ResourceGroupName   = "${data.azurerm_resource_group.main.name}"
    SubscriptionId      = "${var.SUBSCRIPTION_ID}"
    SubscriptionName    = "${var.PROJECT_IDENTITY}"
    AdminAccessObjectId = "${var.AdminAccessObjectId}"
    TenantId            = "${var.TENANT_ID}"
    ClientId            = "${var.CLIENT_ID}"
    ClientSecret        = "${var.CLIENT_SECRET}"
    AccessKey           = "${var.ACCESS_KEY}"
    PipelineSp          = "${var.PIPELINE_SP}"
    Location            = "${data.azurerm_resource_group.main.location}"
    tags                = "${var.TAGS}"
}

module "staticVNet" {
  source          = "github.com/UKHO/terraform-modules/vnet"
  rg              = "${data.azurerm_resource_group.main.name}"
  loc             = "${data.azurerm_resource_group.main.location}"
  tags            = "${var.TAGS}"
  name            = "${var.PROJECT_IDENTITY}-network"
  addressspace    = ["10.1.0.0/16"]
  dnsservers      = []
  subnet_names    = ["${var.PROJECT_IDENTITY}-internal"]
  subnet_prefixes = ["10.1.0.0/24"]
}

module "nsgAssignment" {
  source         = "github.com/UKHO/terraform-modules/networksecuritygroup"
  rg             = "${data.azurerm_resource_group.main.name}"
  loc            = "${data.azurerm_resource_group.main.location}"
  nsg_name       = "${var.PROJECT_IDENTITY}-nsg"
  vnet_subnet_id = "${module.staticVNet.vnet_subnet_id}"
}
