terraform {
  required_version = "~> 0.12.5"

  #  backend "azurerm" {}
}

resource "azurerm_resource_group" "main" {
  name     = "m-${var.VSTS_ACCOUNT}-agents-${var.ENVIRONMENT}-${var.RUN_DATE}-rg"
  location = "${var.AZURE_REGION}"
  tags     = "${merge(var.TAGS, { "ACCOUNT" = "${var.VSTS_ACCOUNT}", "RUN_DATE" = "${var.RUN_DATE}" })}"
}

data "azurerm_resource_group" "data" {
  name = "${var.ProjectIdentity}-RG"
}

data "azurerm_virtual_network" "data" {
  name                = "${var.ProjectIdentity}-vnet"
  resource_group_name = "${data.azurerm_resource_group.data.name}"
}

data "azurerm_subnet" "data" {
  name                 = "azdoagents-prd-subnet"
  resource_group_name  = "${data.azurerm_resource_group.data.name}"
  virtual_network_name = "${data.azurerm_virtual_network.data.name}"
}

data "azurerm_network_security_group" "data" {
  name                = "${var.ProjectIdentity}-nsg"
  resource_group_name = "${data.azurerm_resource_group.data.name}"
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
  AZURERM_VIRTUAL_NETWORK_MAIN_NAME      = "${data.azurerm_virtual_network.data.name}"
  AZURERM_SUBNET_ID                      = "${data.azurerm_subnet.data.id}"
  AZURERM_NETWORK_SECURITY_GROUP_MAIN_ID = "${data.azurerm_network_security_group.data.id}"
  VM                                     = "${element(var.SERVERNAMES, 0)}"
  BRANCH                                 = "${var.BRANCH}"
  TAGS                                   = "${var.TAGS}"
  vm_name                                = "MAZDO${upper(var.ENVIRONMENT)}${element(var.SERVERNAMES, 0)}"
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
  AZURERM_VIRTUAL_NETWORK_MAIN_NAME      = "${data.azurerm_virtual_network.data.name}"
  AZURERM_SUBNET_ID                      = "${data.azurerm_subnet.data.id}"
  AZURERM_NETWORK_SECURITY_GROUP_MAIN_ID = "${data.azurerm_network_security_group.data.id}"
  VM                                     = "${element(var.SERVERNAMES, 1)}"
  BRANCH                                 = "${var.BRANCH}"
  TAGS                                   = "${var.TAGS}"
  vm_name                                = "MAZDO${upper(var.ENVIRONMENT)}${element(var.SERVERNAMES, 1)}"
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
  AZURERM_VIRTUAL_NETWORK_MAIN_NAME      = "${data.azurerm_virtual_network.data.name}"
  AZURERM_SUBNET_ID                      = "${data.azurerm_subnet.data.id}"
  AZURERM_NETWORK_SECURITY_GROUP_MAIN_ID = "${data.azurerm_network_security_group.data.id}"
  VM                                     = "${element(var.SERVERNAMES, 2)}"  
  BRANCH                                 = "${var.BRANCH}"
  TAGS                                   = "${var.TAGS}"
  vm_name                                = "MAZDO${upper(var.ENVIRONMENT)}${element(var.SERVERNAMES, 2)}"
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
  AZURERM_VIRTUAL_NETWORK_MAIN_NAME      = "${data.azurerm_virtual_network.data.name}"
  AZURERM_SUBNET_ID                      = "${data.azurerm_subnet.data.id}"
  AZURERM_NETWORK_SECURITY_GROUP_MAIN_ID = "${data.azurerm_network_security_group.data.id}"
  VM                                     = "${element(var.SERVERNAMES, 3)}"
  BRANCH                                 = "${var.BRANCH}"
  TAGS                                   = "${var.TAGS}"
  vm_name                                = "MAZDO${upper(var.ENVIRONMENT)}${element(var.SERVERNAMES, 3)}"
  run_date                               = "${var.RUN_DATE}"
}
