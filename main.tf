terraform {
  required_version = "~> 0.11.10"

#  backend "azurerm" {}
}

resource "azurerm_resource_group" "main" {
        name = "${var.PREFIX}"
        location = "${var.AZURE_REGION}"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.PREFIX}-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "10.0.2.0/24"

}

resource "azurerm_public_ip" "VM01publicip" {
    name = "${var.PREFIX}-${var.VM01}-ip"
    location = "${azurerm_resource_group.main.location}"  
    resource_group_name = "${azurerm_resource_group.main.name}"   
    allocation_method = "Dynamic" 
  }


resource "azurerm_network_interface" "VM01nic" {
  name                = "${var.PREFIX}-${var.VM01}-nic"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  ip_configuration {
    name                          = "${var.PREFIX}-${var.VM01}-ipconfig"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = "${azurerm_public_ip.public.id}"
  }
}
resource "azurerm_virtual_machine" "VM01" {
  name                  = "${var.PREFIX}-${var.VM01}"
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${azurerm_network_interface.main.id}"]
  vm_size               = "Standard_DS1_v2"
  
  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.PREFIX}-${var.VM01}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.VM01}"
    admin_username = "${var.ADMIN_USERNAME}"
    admin_password = "${var.ADMIN_PASSWORD}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys = "${var.ADMIN_SSHKEY}"
  }
    tags = {
    environment = "agent"
  }
}
  resource "azurerm_virtual_machine_extension" "VM01extensions" {
  name                 = "docker"
  location             = "${azurerm_resource_group.main.location}"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_machine_name = "${azurerm_virtual_machine.main.name}"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "sudo snap install docker"
    }
SETTINGS
}
