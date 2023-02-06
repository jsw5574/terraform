resource "azurerm_subnet" "web_subnet" {
    name                 = "${var.prefix}-subnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixs      = ["22.23.10.0/24"]
}
