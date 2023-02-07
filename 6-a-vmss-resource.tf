locals {
  vmss_custom_data = <<CUSTOM_DATA
  #!/bin/bash
  sudo timedatectl set-timezone Asia/Seoul

  CUSTOM_DATA
}


## VMSS Create
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
    name = "${var.prefix}-vmss"
    computer_name_prefix = "${var.prefix}-vmss"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    sku = "Standard_D2sv5"
    instances = 2
    admin_username = "wjadmin"
    admin_password = "${var.admin_password}"
    


source_image_reference {
      publisher = "openlogic"
      offer = "centos"
      sku = "7_9"
      version = "latest"
    }

os_disk {
    storage_account_type   = "Premium_ZRS"
    caching                = "ReadWrite"
}

upgrade_mode = "Automatic"

network_interface {
    name = "${var.prefix}-vmss-nic"
    primary = true
    network_security_group_id = azurerm_network_security_group.vmss_subnet_nsg.id
    ip_configuration {
      name = "internal"
      primary = true
      subnet_id = azurerm_subnet.vmss_subnet.id
      #load_balancer_inbound_nat_rules_ids = [ azurerm_lb_backend_address_pool.app_lb_backend_address_pool.id ]
    }
}
custom_data = base64encode(local.vmss_custom_data)
}
