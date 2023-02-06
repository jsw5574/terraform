
  
### dev-nic create ##
resource "azurerm_network_interface" "dev_nic" {
  name = "${var.prefix}-dev-nic"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "dev-nic-ip"
    subnet_id = azurerm_subnet.vmss_subnet.id
    private_ip_address_allocation = "Dynamic"
      }
}

locals {
  devvm_custom_data = <<CUSTOM_DATA
  #!bin/bash
  sudo timedatectl set-timezone Asia/Seoul
  
  CUSTOM_DATA
  }


### dev-vm + nic + disk attach ##
resource "azurerm_linux_virtual_machine" "dev-vm" {
    name = "${var.prefix}-vm"
    resource_group_name = azurerm_resource_group.rg.name
    location = var.location
    size = "Standard_D2sv5"
    admin_username = "wjadmin"
    admin_password = "${var.admin_password}"
    network_interface_ids = [ azurerm_network_interface.dev_nic.id ]
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
    custom_data = base64encode(local.devvm_custom_data)
}
