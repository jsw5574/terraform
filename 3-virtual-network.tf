resource "azurerm_virtual_network" "vnet" {
    name = "${var.prefix}-vnet"
    resource_group_name = azurerm_resource_group.rg
    location = azurerm_resource_group.rg
    address_space = "${var.address_space}"
}

