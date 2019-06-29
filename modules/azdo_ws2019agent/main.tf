
resource "azurerm_network_interface" "WSVM" {
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

resource "azurerm_virtual_machine" "WSVM" {
  name                  = "${var.PREFIX}-${var.VM}"
  location              = "${var.AZURERM_RESOURCE_GROUP_MAIN_LOCATION}"
  resource_group_name   = "${var.AZURERM_RESOURCE_GROUP_MAIN_NAME}"
  network_interface_ids = ["${azurerm_network_interface.WSVM.id}"]
  vm_size               = "Standard_D2s_v3"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftVisualStudio"
    offer     = "visualstudio2019"
    sku       = "vs-2019-ent-ws2019"
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

  tags = {
    environment = "agent"
  }
}

resource "azurerm_virtual_machine_extension" "VMTeamServicesAgentWindows" {
  name                 = "${var.PREFIX}-${var.VM}-TeamServicesAgentWindows"
  location             = "${var.AZURERM_RESOURCE_GROUP_MAIN_LOCATION}"
  resource_group_name  = "${var.AZURERM_RESOURCE_GROUP_MAIN_NAME}"
  virtual_machine_name = "${azurerm_virtual_machine.WSVM.name}"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  settings   = <<SETTINGS
    {
        "fileUris": ["https://gist.githubusercontent.com/elduddz/7e1cd1c89482b30b9ea96ea57c38cfe9/raw/902dd7cc6a54c7021b4457c79e19fe33db44e319/agentinstall.ps1"],
        "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -File agentinstall.ps1 -account \"${var.VSTS_ACCOUNT}\" -PAT \"${var.VSTS_TOKEN}\" -pool \"${var.VSTS_POOL}\" -ComputerName \"${var.PREFIX}-${var.VM}\" -count 2"
    }
SETTINGS
}
