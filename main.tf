terraform {
  required_version = "~> 0.12.1"

  #  backend "azurerm" {}
}

resource "azurerm_resource_group" "main" {
  name     = "${var.PREFIX}"
  location = "${var.AZURE_REGION}"
}

data "azurerm_virtual_network" "main" {
  name                = "${var.VNET_NAME}"
  resource_group_name = "${var.VNET_RG}"
}

data "azurerm_subnet" "main" {
  name                 = "${var.INTERNAL_NETWORK_NAME}"
  resource_group_name  = "${var.VNET_RG}"
  virtual_network_name = "${data.azurerm_virtual_network.main.name}"  
}

resource "azurerm_network_security_group" "main" {
  name                = "${var.PREFIX}-networksecurity"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

module "ubuntupool_agent1" {
  source                                 = "./modules/azdo_ubuntuagent"
  PREFIX                                 = "${var.PREFIX}"
  VSTS_POOL                              = "${var.VSTS_POOL}"
  VSTS_ACCOUNT                           = "${var.VSTS_ACCOUNT}"
  VSTS_TOKEN                             = "${var.VSTS_TOKEN}"
  ADMIN_USERNAME                         = "${var.ADMIN_USERNAME}"
  ADMIN_PASSWORD                         = "${var.ADMIN_PASSWORD}"
  ADMIN_SSHKEYPATH                       = "${var.ADMIN_SSHKEYPATH}"
  ADMIN_SSHKEYDATA                       = "${var.ADMIN_SSHKEYDATA}"
  AZURE_REGION                           = "${var.AZURE_REGION}"
  AZURERM_RESOURCE_GROUP_MAIN_NAME       = "${azurerm_resource_group.main.name}"
  AZURERM_RESOURCE_GROUP_MAIN_LOCATION   = "${azurerm_resource_group.main.location}"
  AZURERM_VIRTUAL_NETWORK_MAIN_NAME      = "${data.azurerm_virtual_network.main.name}"
  AZURERM_SUBNET_ID                      = "${data.azurerm_subnet.main.id}"
  AZURERM_NETWORK_SECURITY_GROUP_MAIN_ID = "${azurerm_network_security_group.main.id}"
  VM                                     = "${element(var.SERVERNAMES, 0)}"
}

module "ubuntupool_agent2" {
  source                                 = "./modules/azdo_ubuntuagent"
  PREFIX                                 = "${var.PREFIX}"
  VSTS_POOL                              = "${var.VSTS_POOL}"
  VSTS_ACCOUNT                           = "${var.VSTS_ACCOUNT}"
  VSTS_TOKEN                             = "${var.VSTS_TOKEN}"
  ADMIN_USERNAME                         = "${var.ADMIN_USERNAME}"
  ADMIN_PASSWORD                         = "${var.ADMIN_PASSWORD}"
  ADMIN_SSHKEYPATH                       = "${var.ADMIN_SSHKEYPATH}"
  ADMIN_SSHKEYDATA                       = "${var.ADMIN_SSHKEYDATA}"
  AZURE_REGION                           = "${var.AZURE_REGION}"
  AZURERM_RESOURCE_GROUP_MAIN_NAME       = "${azurerm_resource_group.main.name}"
  AZURERM_RESOURCE_GROUP_MAIN_LOCATION   = "${azurerm_resource_group.main.location}"
  AZURERM_VIRTUAL_NETWORK_MAIN_NAME      = "${data.azurerm_virtual_network.main.name}"
  AZURERM_SUBNET_ID                      = "${data.azurerm_subnet.main.id}"
  AZURERM_NETWORK_SECURITY_GROUP_MAIN_ID = "${azurerm_network_security_group.main.id}"
  VM                                     = "${element(var.SERVERNAMES, 1)}"
}
