
resource "azurerm_network_interface" "VM" {
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

resource "azurerm_virtual_machine" "VM" {
  name                             = "${var.vm_name}"
  location                         = "${var.AZURERM_RESOURCE_GROUP_MAIN_LOCATION}"
  resource_group_name              = "${var.AZURERM_RESOURCE_GROUP_MAIN_NAME}"
  network_interface_ids            = ["${azurerm_network_interface.VM.id}"]
  vm_size                          = "${var.vm_size}"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.vm_name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = "128"
  }
  os_profile {
    computer_name  = "${var.vm_name}"
    admin_username = "${var.ADMIN_USERNAME}"
    admin_password = "${var.ADMIN_PASSWORD}"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/azureagent/.ssh/authorized_keys"
      key_data = "${var.ADMIN_SSHKEYDATA}"
    }
  }
  tags = "${merge(var.TAGS, { "ACCOUNT" = "${var.VSTS_ACCOUNT}", "OS" = "Ubuntu 1804", "RUN_DATE" = "${var.run_date}" })}"
}

resource "azurerm_virtual_machine_extension" "VMTeamServicesAgentLinux" {
  name                 = "${var.vm_name}-TeamServicesAgentLinux"
  location             = "${var.AZURERM_RESOURCE_GROUP_MAIN_LOCATION}"
  resource_group_name  = "${var.AZURERM_RESOURCE_GROUP_MAIN_NAME}"
  virtual_machine_name = "${azurerm_virtual_machine.VM.name}"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
  protected_settings   = <<SETTINGS
    {
        "fileUris": ["https://raw.githubusercontent.com/UKHO/AzurePipelinesAgents/${var.BRANCH}/scripts/agentinstall.sh"],
        "commandToExecute": "sh agentinstall.sh ${var.VSTS_ACCOUNT} ${var.VSTS_TOKEN} \"${var.VSTS_POOL_PREFIX}\" ${var.vm_name}-${var.run_date} ${var.VSTS_AGENT_COUNT}"
    }
SETTINGS
}
