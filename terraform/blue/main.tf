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
  resource_group_name = "${data.azurerm_resource_group.spoke-rg.name}"
}

locals {
  run_date = formatdate("YYYY-MM-DD", timestamp())
  deployment_colour = "b"
}

resource "azurerm_resource_group" "vm-rg" {
  name     = "m-${var.AZDO_ORGANISATION}-${var.ENVIRONMENT}-${local.run_date}-${local.deployment_colour}-rg"
  location = var.AZURE_REGION
  tags     = merge(var.TAGS, { "ACCOUNT" = "${var.AZDO_ORGANISATION}", "RUN_DATE" = "${local.run_date}" })
}

module "ubuntu_01" {
    source                    = "../modules/azdo_ubuntuagent"
    vm_name = "MAZDO${upper(var.ENVIRONMENT)}AGT01-{local.deployment_colour}"
    vm_size = var.VM_SIZE
    VM_RG_NAME = azurerm_resource_group.vm-rg.name
    VM_REGION = var.AZURE_REGION
    ADMIN_SSHKEYPATH          = var.ADMIN_SSHKEYPATH
    ADMIN_SSHKEYDATA          = var.ADMIN_SSHKEYDATA
    ADMIN_USERNAME = var.ADMIN_USERNAME

    run_date = local.run_date
    SPOKE_NSG_ID = data.azurerm_network_security_group.spoke-nsg.id
    SPOKE_SUBNET_ID = data.azurerm_subnet.spoke-vnet-subnet.id

    AZDO_ORGANISATION  = var.AZDO_ORGANISATION
    AZDO_TOKEN         = var.AZDO_TOKEN
    BRANCH                    = var.BRANCH
    TAGS                      = var.TAGS
}