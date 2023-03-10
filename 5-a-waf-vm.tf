
  
### waf1-nic create ##
resource "azurerm_network_interface" "waf1_nic" {
  name = "${var.prefix}-waf1-nic"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "waf1-nic-ip"
    subnet_id = azurerm_subnet.sec_subnet.id
    private_ip_address_allocation = "Dynamic"
      }
}

locals {
  wafvm_custom_data = <<CUSTOM_DATA
  #!bin/bash
  sudo timedatectl set-timezone Asia/Seoul
  
  CUSTOM_DATA
  }


### waf1-vm + nic + disk attach ##
resource "azurerm_linux_virtual_machine" "waf1-vm" {
    name = "${var.prefix}-vm"
    resource_group_name = azurerm_resource_group.rg.name
    location = var.location
    size = "Standard_D2sv5"
    zone = 1
    admin_username = "wjadmin"
    admin_password = "${var.admin_password}"
    network_interface_ids = [ azurerm_network_interface.waf1_nic.id ]
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
    custom_data = base64encode(local.wafvm_custom_data)
}


  
### waf2-nic create ##
resource "azurerm_network_interface" "waf2_nic" {
  name = "${var.prefix}-waf2-nic"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "waf2-nic-ip"
    subnet_id = azurerm_subnet.sec_subnet.id
    private_ip_address_allocation = "Dynamic"
      }
}


### waf2-vm + nic + disk attach ##
resource "azurerm_linux_virtual_machine" "waf2-vm" {
    name = "${var.prefix}-vm"
    resource_group_name = azurerm_resource_group.rg.name
    location = var.location
    zone = 2
    size = "Standard_D2sv5"
    admin_username = "wjadmin"
    admin_password = "${var.admin_password}"
    network_interface_ids = [ azurerm_network_interface.waf2_nic.id ]
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
    custom_data = base64encode(local.wafvm_custom_data)
}