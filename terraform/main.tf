terraform {
  required_version = "~> 0.12.5"
}

data "azurerm_resource_group" "spoke-rg" {
  name = "m-spokeconfig-RG"
}

data "azurerm_virtual_network" "spoke-vnet" {
  name                = "AzDoLive-vnet"
  resource_group_name = data.azurerm_resource_group.spoke-rg.name
}

data "azurerm_subnet" "spoke-vnet-subnet" {
  name                 = "azdoagents-prd-subnet"
  resource_group_name  = data.azurerm_resource_group.spoke-rg.name
  virtual_network_name = data.azurerm_virtual_network.spoke-vnet.name
}

data "azurerm_network_security_group" "spoke-nsg" {
  name                = "AzDoLive-nsg"
  resource_group_name = data.azurerm_resource_group.spoke-rg.name
}

locals {
  run_date = formatdate("YYYY-MM-DD", timestamp())
}

resource "azurerm_resource_group" "vm-rg" {
  name     = "m-${var.VSTS_ACCOUNT}-agents-${var.ENVIRONMENT}-${local.run_date}-rg"
  location = var.AZURE_REGION
  tags     = merge(var.TAGS, { "ACCOUNT" = "${var.VSTS_ACCOUNT}", "RUN_DATE" = "${local.run_date}" })
}

module "pool_agent1-ubuntu" {
  source                                 = "./modules/azdo_ubuntuagent"
  VSTS_POOL_PREFIX                       = var.VSTS_POOL_PREFIX
  VSTS_ACCOUNT                           = var.VSTS_ACCOUNT
  VSTS_TOKEN                             = var.VSTS_TOKEN
  ADMIN_USERNAME                         = var.ADMIN_USERNAME
  ADMIN_PASSWORD                         = var.ADMIN_PASSWORD
  ADMIN_SSHKEYPATH                       = var.ADMIN_SSHKEYPATH
  ADMIN_SSHKEYDATA                       = var.ADMIN_SSHKEYDATA
  AZURE_REGION                           = var.AZURE_REGION
  AZURERM_RESOURCE_GROUP_MAIN_NAME       = azurerm_resource_group.vm-rg.name
  AZURERM_RESOURCE_GROUP_MAIN_LOCATION   = azurerm_resource_group.vm-rg.location
  AZURERM_VIRTUAL_NETWORK_MAIN_NAME      = data.azurerm_virtual_network.spoke-vnet.name
  AZURERM_SUBNET_ID                      = data.azurerm_subnet.spoke-vnet-subnet.id
  AZURERM_NETWORK_SECURITY_GROUP_MAIN_ID = data.azurerm_network_security_group.spoke-nsg.id
  VM                                     = element(var.SERVERNAMES, 0)
  BRANCH                                 = var.BRANCH
  TAGS                                   = var.TAGS
  vm_name                                = "MAZDO${upper(var.ENVIRONMENT)}${element(var.SERVERNAMES, 0)}"
  vm_size                                = var.VM_SIZE
  run_date                               = local.run_date
}

module "pool_agent2-ws2019-vs2019" {
  source                                 = "./modules/azdo_ws2019agent"
  VSTS_POOL_PREFIX                       = var.VSTS_POOL_PREFIX
  VSTS_ACCOUNT                           = var.VSTS_ACCOUNT
  VSTS_TOKEN                             = var.VSTS_TOKEN
  ADMIN_USERNAME                         = var.ADMIN_USERNAME
  ADMIN_PASSWORD                         = var.ADMIN_PASSWORD
  ADMIN_SSHKEYPATH                       = var.ADMIN_SSHKEYPATH
  ADMIN_SSHKEYDATA                       = var.ADMIN_SSHKEYDATA
  AZURE_REGION                           = var.AZURE_REGION
  AZURERM_RESOURCE_GROUP_MAIN_NAME       = azurerm_resource_group.vm-rg.name
  AZURERM_RESOURCE_GROUP_MAIN_LOCATION   = azurerm_resource_group.vm-rg.location
  AZURERM_VIRTUAL_NETWORK_MAIN_NAME      = data.azurerm_virtual_network.spoke-vnet.name
  AZURERM_SUBNET_ID                      = data.azurerm_subnet.spoke-vnet-subnet.id
  AZURERM_NETWORK_SECURITY_GROUP_MAIN_ID = data.azurerm_network_security_group.spoke-nsg.id
  VM                                     = element(var.SERVERNAMES, 1)
  BRANCH                                 = var.BRANCH
  TAGS                                   = var.TAGS
  vm_name                                = "MAZDO${upper(var.ENVIRONMENT)}${element(var.SERVERNAMES, 1)}"
  vm_size                                = var.VM_SIZE
  run_date                               = local.run_date
}

module "ubuntu_03" {
  source           = "./modules/azdo_single_ubuntuagent"
  vm_name          = "MAZDO${upper(var.ENVIRONMENT)}AGT03"
  vm_size          = var.VM_SIZE
  VM_RG_NAME       = azurerm_resource_group.vm-rg.name
  VM_REGION        = var.AZURE_REGION
  ADMIN_SSHKEYPATH = var.ADMIN_SSHKEYPATH
  ADMIN_SSHKEYDATA = var.ADMIN_SSHKEYDATA
  ADMIN_USERNAME   = var.ADMIN_USERNAME

  run_date        = local.run_date
  SPOKE_NSG_ID    = data.azurerm_network_security_group.spoke-nsg.id
  SPOKE_SUBNET_ID = data.azurerm_subnet.spoke-vnet-subnet.id

  AZDO_ORGANISATION = var.VSTS_ACCOUNT
  AZDO_TOKEN        = var.VSTS_TOKEN
  BRANCH            = var.BRANCH
  TAGS              = var.TAGS
}

module "ubuntu_04" {
  source           = "./modules/azdo_single_ubuntuagent"
  vm_name          = "MAZDO${upper(var.ENVIRONMENT)}AGT04"
  vm_size          = var.VM_SIZE
  VM_RG_NAME       = azurerm_resource_group.vm-rg.name
  VM_REGION        = var.AZURE_REGION
  ADMIN_SSHKEYPATH = var.ADMIN_SSHKEYPATH
  ADMIN_SSHKEYDATA = var.ADMIN_SSHKEYDATA
  ADMIN_USERNAME   = var.ADMIN_USERNAME

  run_date        = local.run_date
  SPOKE_NSG_ID    = data.azurerm_network_security_group.spoke-nsg.id
  SPOKE_SUBNET_ID = data.azurerm_subnet.spoke-vnet-subnet.id

  AZDO_ORGANISATION = var.VSTS_ACCOUNT
  AZDO_TOKEN        = var.VSTS_TOKEN
  BRANCH            = var.BRANCH
  TAGS              = var.TAGS
}

module "ubuntu_05" {
  source           = "./modules/azdo_single_ubuntuagent"
  vm_name          = "MAZDO${upper(var.ENVIRONMENT)}AGT05"
  vm_size          = var.VM_SIZE
  VM_RG_NAME       = azurerm_resource_group.vm-rg.name
  VM_REGION        = var.AZURE_REGION
  ADMIN_SSHKEYPATH = var.ADMIN_SSHKEYPATH
  ADMIN_SSHKEYDATA = var.ADMIN_SSHKEYDATA
  ADMIN_USERNAME   = var.ADMIN_USERNAME

  run_date        = local.run_date
  SPOKE_NSG_ID    = data.azurerm_network_security_group.spoke-nsg.id
  SPOKE_SUBNET_ID = data.azurerm_subnet.spoke-vnet-subnet.id

  AZDO_ORGANISATION = var.VSTS_ACCOUNT
  AZDO_TOKEN        = var.VSTS_TOKEN
  BRANCH            = var.BRANCH
  TAGS              = var.TAGS
}

module "ubuntu_06" {
  source           = "./modules/azdo_single_ubuntuagent"
  vm_name          = "MAZDO${upper(var.ENVIRONMENT)}AGT06"
  vm_size          = var.VM_SIZE
  VM_RG_NAME       = azurerm_resource_group.vm-rg.name
  VM_REGION        = var.AZURE_REGION
  ADMIN_SSHKEYPATH = var.ADMIN_SSHKEYPATH
  ADMIN_SSHKEYDATA = var.ADMIN_SSHKEYDATA
  ADMIN_USERNAME   = var.ADMIN_USERNAME

  run_date        = local.run_date
  SPOKE_NSG_ID    = data.azurerm_network_security_group.spoke-nsg.id
  SPOKE_SUBNET_ID = data.azurerm_subnet.spoke-vnet-subnet.id

  AZDO_ORGANISATION = var.VSTS_ACCOUNT
  AZDO_TOKEN        = var.VSTS_TOKEN
  BRANCH            = var.BRANCH
  TAGS              = var.TAGS
}