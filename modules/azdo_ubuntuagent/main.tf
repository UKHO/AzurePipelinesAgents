
resource "azurerm_network_interface" "VM" {
  name                      = "${var.PREFIX}-${var.VM}-nic"
  location                  = "${var.AZURERM_RESOURCE_GROUP_MAIN_LOCATION}"
  resource_group_name       = "${var.AZURERM_RESOURCE_GROUP_MAIN_NAME}"
  network_security_group_id = "${var.AZURERM_NETWORK_SECURITY_GROUP_MAIN_ID}"

  ip_configuration {
    name                          = "configuration"
    subnet_id                     = "${var.AZURERM_SUBNET_ID}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "VM" {
  name                  = "${var.PREFIX}-${var.VM}-u1804"
  location              = "${var.AZURERM_RESOURCE_GROUP_MAIN_LOCATION}"
  resource_group_name   = "${var.AZURERM_RESOURCE_GROUP_MAIN_NAME}"
  network_interface_ids = ["${azurerm_network_interface.VM.id}"]
  vm_size               = "Standard_D2s_v3"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.PREFIX}-${var.VM}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.VM}"
    admin_username = "${var.ADMIN_USERNAME}"
    admin_password = "${var.ADMIN_PASSWORD}"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "${var.ADMIN_SSHKEYPATH}"
      key_data = "${var.ADMIN_SSHKEYDATA}"
    }
  }

  tags = {
    environment = "agent"
    os = "Ubuntu 1804"
  }
}

resource "azurerm_virtual_machine_extension" "VMTeamServicesAgentLinux" {
  name                 = "${var.PREFIX}-${var.VM}-TeamServicesAgentLinux"
  location             = "${var.AZURERM_RESOURCE_GROUP_MAIN_LOCATION}"
  resource_group_name  = "${var.AZURERM_RESOURCE_GROUP_MAIN_NAME}"
  virtual_machine_name = "${azurerm_virtual_machine.VM.name}"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
  protected_settings   = <<SETTINGS
    {
        "fileUris": ["https://raw.githubusercontent.com/UKHO/AzurePipelinesAgents/${var.BRANCH}/agentinstall.sh"],
        "commandToExecute": "sh agentinstall.sh ${var.VSTS_ACCOUNT} ${var.VSTS_TOKEN} \"${var.VSTS_POOL_PREFIX}\" ${var.PREFIX}-${var.VM} 2"
    }
SETTINGS
}
