terraform {
  required_version = "~> 0.12.1"

  #  backend "azurerm" {}
}

resource "azurerm_resource_group" "main" {
  name     = "ms-${var.VSTS_ACCOUNT}-agents-${var.ENVIRONMENT}-${var.RUN_DATE}-rg"
  location = "${var.AZURE_REGION}"
  tags     = "${merge(var.TAGS, { "ACCOUNT" = "${var.VSTS_ACCOUNT}", "RUN_DATE" = "${var.RUN_DATE}" })}"
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
  name                = "ms-${var.VSTS_ACCOUNT}-agents-${var.ENVIRONMENT}-networksecurity"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  tags                = "${merge(var.TAGS, { "ACCOUNT" = "${var.VSTS_ACCOUNT}", "RUN_DATE" = "${var.RUN_DATE}" })}"
}

module "pool_agent1-ubuntu" {
  source                                 = "./modules/azdo_ubuntuagent"
  VSTS_POOL_PREFIX                       = "${var.VSTS_POOL_PREFIX}"
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
  BRANCH                                 = "${var.BRANCH}"
  TAGS                                   = "${var.TAGS}"
  vm_name                                = "MSAGT${upper(var.ENVIRONMENT)}${element(var.SERVERNAMES, 0)}"
  run_date                               = "${var.RUN_DATE}"
}

module "pool_agent2-ubuntu" {
  source                                 = "./modules/azdo_ubuntuagent"
  VSTS_POOL_PREFIX                       = "${var.VSTS_POOL_PREFIX}"
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
  BRANCH                                 = "${var.BRANCH}"
  TAGS                                   = "${var.TAGS}"
  vm_name                                = "MSAGT${upper(var.ENVIRONMENT)}${element(var.SERVERNAMES, 1)}"
  run_date                               = "${var.RUN_DATE}"
}

module "pool_agent3-ws2019-vs2019" {
  source                                 = "./modules/azdo_ws2019agent"
  VSTS_POOL_PREFIX                       = "${var.VSTS_POOL_PREFIX}"
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
  VM                                     = "${element(var.SERVERNAMES, 2)}"
  BRANCH                                 = "${var.BRANCH}"
  TAGS                                   = "${var.TAGS}"
  vm_name                                = "MSAGT${upper(var.ENVIRONMENT)}${element(var.SERVERNAMES, 2)}"
  run_date                               = "${var.RUN_DATE}"
}

module "pool_agent4-ws2019-vs2019" {
  source                                 = "./modules/azdo_ws2019agent"
  VSTS_POOL_PREFIX                       = "${var.VSTS_POOL_PREFIX}"
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
  VM                                     = "${element(var.SERVERNAMES, 3)}"
  BRANCH                                 = "${var.BRANCH}"
  TAGS                                   = "${var.TAGS}"
  vm_name                                = "MSAGT${upper(var.ENVIRONMENT)}${element(var.SERVERNAMES, 3)}"
  run_date                               = "${var.RUN_DATE}"
}


