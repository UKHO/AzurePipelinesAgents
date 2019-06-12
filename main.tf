terraform {
  required_version = "~> 0.12.1"

  #  backend "azurerm" {}
}

resource "azurerm_resource_group" "main" {
  name     = "${var.PREFIX}"
  location = "${var.AZURE_REGION}"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.PREFIX}-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_subnet" "main" {
  name                 = "${var.PREFIX}-internal"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "10.0.2.0/24"
}

module "ubuntupool_agent1" {
  source                               = "./modules/azdo_ubuntuagent"
  PREFIX                               = "${var.PREFIX}"
  VSTS_POOL                            = "${var.VSTS_POOL}"
  VSTS_ACCOUNT                         = "${var.VSTS_ACCOUNT}"
  VSTS_TOKEN                           = "${var.VSTS_TOKEN}"
  ADMIN_USERNAME                       = "${var.ADMIN_USERNAME}"
  ADMIN_PASSWORD                       = "${var.ADMIN_PASSWORD}"
  ADMIN_SSHKEYPATH                     = "${var.ADMIN_SSHKEYPATH}"
  ADMIN_SSHKEYDATA                     = "${var.ADMIN_SSHKEYDATA}"
  AZURE_CLIENT_ID                      = "${var.AZURE_CLIENT_ID}"
  AZURE_CLIENT_SECRET                  = "${var.AZURE_CLIENT_SECRET}"
  AZURE_TENANT_ID                      = "${var.AZURE_TENANT_ID}"
  AZURE_SUBSCRIPTION_ID                = "${var.AZURE_SUBSCRIPTION_ID}"
  AZURE_REGION                         = "${var.AZURE_REGION}"
  AZURERM_RESOURCE_GROUP_MAIN_NAME     = "${azurerm_resource_group.main.name}"
  AZURERM_RESOURCE_GROUP_MAIN_LOCATION = "${azurerm_resource_group.main.location}"
  AZURERM_VIRTUAL_NETWORK_MAIN_NAME    = "${azurerm_virtual_network.main.name}"
  AZURERM_SUBNET_ID                    = "${azurerm_subnet.main.id}"
  VM                                   = "${var.VM}01"
}

module "ubuntupool_agent2" {
  source                               = "./modules/azdo_ubuntuagent"
  PREFIX                               = "${var.PREFIX}"
  VSTS_POOL                            = "${var.VSTS_POOL}"
  VSTS_ACCOUNT                         = "${var.VSTS_ACCOUNT}"
  VSTS_TOKEN                           = "${var.VSTS_TOKEN}"
  ADMIN_USERNAME                       = "${var.ADMIN_USERNAME}"
  ADMIN_PASSWORD                       = "${var.ADMIN_PASSWORD}"
  ADMIN_SSHKEYPATH                     = "${var.ADMIN_SSHKEYPATH}"
  ADMIN_SSHKEYDATA                     = "${var.ADMIN_SSHKEYDATA}"
  AZURE_CLIENT_ID                      = "${var.AZURE_CLIENT_ID}"
  AZURE_CLIENT_SECRET                  = "${var.AZURE_CLIENT_SECRET}"
  AZURE_TENANT_ID                      = "${var.AZURE_TENANT_ID}"
  AZURE_SUBSCRIPTION_ID                = "${var.AZURE_SUBSCRIPTION_ID}"
  AZURE_REGION                         = "${var.AZURE_REGION}"
  AZURERM_RESOURCE_GROUP_MAIN_NAME     = "${azurerm_resource_group.main.name}"
  AZURERM_RESOURCE_GROUP_MAIN_LOCATION = "${azurerm_resource_group.main.location}"
  AZURERM_VIRTUAL_NETWORK_MAIN_NAME    = "${azurerm_virtual_network.main.name}"
  AZURERM_SUBNET_ID                    = "${azurerm_subnet.main.id}"
  VM                                   = "${var.VM}02"
}
