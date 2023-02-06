
/*
resource "azurerm_virtual_machine" "waf1" {
  name                    = "${var.prefix}-waf1-vm"
  location                = var.location
  resource_group_name     = azurerm_resource_group.rg.name
  vm_size                 = var.waf_vm_size
  network_interface_ids   = [azurerm_network_interface]
} 
*/  

resource "azurerm_network_interface" "waf1_nic" {
  name = "${var.prefix}-waf1-nic"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "waf-nic"
    subnet_id = azurerm_subnet.sec_subnet.id
    private_ip_address_allocation = "Dynamic"
      }
}
