
resource "azurerm_network_interface" "VM-nic" {
  name                      = "${var.vm_name}-nic"
  location                  = var.VM_REGION
  resource_group_name       = var.VM_RG_NAME
  network_security_group_id = var.SPOKE_NSG_ID

  ip_configuration {
    name                          = "configuration"
    subnet_id                     = var.SPOKE_SUBNET_ID
    private_ip_address_allocation = "Dynamic"
  }
  tags = merge(var.TAGS, { "ACCOUNT" = "${var.AZDO_ORGANISATION}", "RUN_DATE" = "${var.run_date}" })
}

resource "azurerm_virtual_machine" "VM" {
  name                             = var.vm_name
  location                         = var.VM_REGION
  resource_group_name              = var.VM_RG_NAME
  network_interface_ids            = ["${azurerm_network_interface.VM-nic.id}"]
  vm_size                          = var.vm_size
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
    computer_name  = var.vm_name
    admin_username = var.ADMIN_USERNAME    
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = var.ADMIN_SSHKEYPATH
      key_data = var.ADMIN_SSHKEYDATA
    }
  }
  tags = merge(var.TAGS, { "ACCOUNT" = "${var.AZDO_ORGANISATION}", "OS" = "Ubuntu 1804", "RUN_DATE" = "${var.run_date}" })
}

resource "azurerm_virtual_machine_extension" "VMTeamServicesAgentLinux" {
  name                 = "${var.vm_name}-TeamServicesAgentLinux"
  location             = azurerm_virtual_machine.VM.location
  virtual_machine_name = azurerm_virtual_machine.VM.name
  resource_group_name  = azurerm_virtual_machine.VM.resource_group_name
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
  protected_settings   = <<SETTINGS
    {
        "fileUris": ["https://raw.githubusercontent.com/UKHO/AzurePipelinesAgents/${var.BRANCH}/scripts/agentinstall.sh"],
        "commandToExecute": "sh agentinstall.sh ${var.AZDO_ORGANISATION} ${var.AZDO_TOKEN} \"${var.AZDO_POOL_PREFIX}\" ${var.vm_name}-${var.run_date} 0"
    }
SETTINGS
}
