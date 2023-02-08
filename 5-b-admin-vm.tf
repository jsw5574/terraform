
  
### admin1-nic create ##
resource "azurerm_network_interface" "admin1_nic" {
  name = "${var.prefix}-admin1-nic"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "admin1-nic-ip"
    subnet_id = azurerm_subnet.app_subnet.id
    private_ip_address_allocation = "Dynamic"
      }
}

locals {
  adminvm_custom_data = <<CUSTOM_DATA
  #!bin/bash
  sudo timedatectl set-timezone Asia/Seoul
  
  CUSTOM_DATA
  }


### admin1-vm + nic + disk attach ##
resource "azurerm_linux_virtual_machine" "admin1-vm" {
    name = "${var.prefix}-vm"
    resource_group_name = azurerm_resource_group.rg.name
    location = var.location
    zone = 1
    size = "Standard_D2sv5"
    admin_username = "wjadmin"
    admin_password = "${var.admin_password}"
    network_interface_ids = [ azurerm_network_interface.admin1_nic.id ]
    os_disk {
      caching = "ReadWrite"
      storage_account_type = "Premium_ZRS"
    }
    source_image_reference {
      publisher = "openlogic"
      offer = "centos"
      sku = "7_9"
      version = "latest"
    }
    custom_data = base64encode(local.adminvm_custom_data)
}


  
### admin2-nic create ##
resource "azurerm_network_interface" "admin2_nic" {
  name = "${var.prefix}-admin2-nic"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "admin2-nic-ip"
    subnet_id = azurerm_subnet.app_subnet.id
    private_ip_address_allocation = "Dynamic"
      }
}


### admin2-vm + nic + disk attach ##
resource "azurerm_linux_virtual_machine" "admin2-vm" {
    name = "${var.prefix}-vm"
    resource_group_name = azurerm_resource_group.rg.name
    location = var.location
    zone = 2
    size = "Standard_D2sv5"
    admin_username = "wjadmin"
    admin_password = "${var.admin_password}"
    network_interface_ids = [ azurerm_network_interface.admin2_nic.id ]
    os_disk {
      caching = "ReadWrite"
      storage_account_type = "Premium_ZRS"
    }
    source_image_reference {
      publisher = "openlogic"
      offer = "centos"
      sku = "7_9"
      version = "latest"
    }
    custom_data = base64encode(local.adminvm_custom_data)
}