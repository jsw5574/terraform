
  
### search1-nic create ##
resource "azurerm_network_interface" "search1_nic" {
  name = "${var.prefix}-search1-nic"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "search1-nic-ip"
    subnet_id = azurerm_subnet.app_subnet.id
    private_ip_address_allocation = "Dynamic"
      }
}

locals {
  searchvm_custom_data = <<CUSTOM_DATA
  #!bin/bash
  sudo timedatectl set-timezone Asia/Seoul
  
  CUSTOM_DATA
  }


### search1-vm + nic + disk attach ##
resource "azurerm_linux_virtual_machine" "search1-vm" {
    name = "${var.prefix}-vm"
    resource_group_name = azurerm_resource_group.rg.name
    location = var.location
    zone = 1
    size = "Standard_D2sv5"
    admin_username = "wjadmin"
    admin_password = "${var.admin_password}"
    network_interface_ids = [ azurerm_network_interface.search1_nic.id ]
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
    custom_data = base64encode(local.searchvm_custom_data)
}


  
### search2-nic create ##
resource "azurerm_network_interface" "search2_nic" {
  name = "${var.prefix}-search2-nic"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "search2-nic-ip"
    subnet_id = azurerm_subnet.app_subnet.id
    private_ip_address_allocation = "Dynamic"
      }
}


### search2-vm + nic + disk attach ##
resource "azurerm_linux_virtual_machine" "search2-vm" {
    name = "${var.prefix}-vm"
    resource_group_name = azurerm_resource_group.rg.name
    zone = 2
    location = var.location
    size = "Standard_D2sv5"
    admin_username = "wjadmin"
    admin_password = "${var.admin_password}"
    network_interface_ids = [ azurerm_network_interface.search2_nic.id ]
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
    custom_data = base64encode(local.searchvm_custom_data)
}