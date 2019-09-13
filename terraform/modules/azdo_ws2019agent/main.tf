data "azurerm_shared_image_version" "existing" {
  name                = "0.154.3"
  gallery_name        = "UKHOSharedImageGallery"
  image_name          = "azure-pipelines-image-vs2019-ws2019"
  resource_group_name = "AzDOLive-SharedImageGallery"
}

resource "azurerm_network_interface" "WSVM" {
  name                      = "${var.vm_name}-nic"
  location                  = "${var.AZURERM_RESOURCE_GROUP_MAIN_LOCATION}"
  resource_group_name       = "${var.AZURERM_RESOURCE_GROUP_MAIN_NAME}"
  network_security_group_id = "${var.AZURERM_NETWORK_SECURITY_GROUP_MAIN_ID}"

  ip_configuration {
    name                          = "configuration"
    subnet_id                     = "${var.AZURERM_SUBNET_ID}"
    private_ip_address_allocation = "Dynamic"
  }
  tags = "${merge(var.TAGS, { "ACCOUNT" = "${var.VSTS_ACCOUNT}", "RUN_DATE" = "${var.run_date}" })}"
}

resource "azurerm_virtual_machine" "WSVM" {
  name                             = "${var.vm_name}"
  location                         = "${var.AZURERM_RESOURCE_GROUP_MAIN_LOCATION}"
  resource_group_name              = "${var.AZURERM_RESOURCE_GROUP_MAIN_NAME}"
  network_interface_ids            = ["${azurerm_network_interface.WSVM.id}"]
  vm_size                          = "${var.vm_size}"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    id = "${data.azurerm_shared_image_version.existing.id}"
  }
  storage_os_disk {
    name              = "${var.vm_name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"

  }
  os_profile {
    computer_name  = "${var.vm_name}"
    admin_username = "${var.ADMIN_USERNAME}"
    admin_password = "${var.ADMIN_PASSWORD}"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true

    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "AutoLogon"
      content      = "<AutoLogon><Password><Value>${var.ADMIN_PASSWORD}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.ADMIN_USERNAME}</Username></AutoLogon>"
    }
  }
  tags = "${merge(var.TAGS, { "ACCOUNT" = "${var.VSTS_ACCOUNT}", "OS" = "ws2019", "RUN_DATE" = "${var.run_date}" })}"
}

resource "azurerm_virtual_machine_extension" "VMTeamServicesAgentWindows" {
  name                 = "${var.vm_name}-TeamServicesAgentWindows"
  location             = "${var.AZURERM_RESOURCE_GROUP_MAIN_LOCATION}"
  resource_group_name  = "${var.AZURERM_RESOURCE_GROUP_MAIN_NAME}"
  virtual_machine_name = "${azurerm_virtual_machine.WSVM.name}"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  protected_settings   = <<SETTINGS
    {
        "fileUris": ["https://raw.githubusercontent.com/UKHO/AzurePipelinesAgents/${var.BRANCH}/scripts/agentinstall.ps1"],
        "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -File agentinstall.ps1 -account \"${var.VSTS_ACCOUNT}\" -PAT \"${var.VSTS_TOKEN}\" -PoolNamePrefix \"${var.VSTS_POOL_PREFIX}\" -ComputerName \"${var.vm_name}-${var.run_date}\" -AdminAccount \"${var.ADMIN_USERNAME}\" -AdminPassword \"${var.ADMIN_PASSWORD}\" -count \"${var.VSTS_AGENT_COUNT}\""
    }
SETTINGS
}
