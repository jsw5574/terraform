resource "azurerm_public_ip" "nat-ip" {
  name = "${var.prefix}-natgw-pip"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method = "Static"
  sku = "Standard"
}


resource "azurerm_nat_gateway" "natgw" {
  name = "${var.prefix}-natgw"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name = "Standard"
}


resource "azurerm_nat_gateway_public_ip_association" "natgw-ip-associate" {
    nat_gateway_id = azurerm_nat_gateway.natgw.id
    public_ip_address_id = azurerm_public_ip.nat-ip.id
}



resource "azurerm_subnet_nat_gateway_association" "natgw-subnet-associate" {
    subnet_id = azurerm_subnet.vmss_subnet.id
    natnat_gateway_id = azurerm_nat_gateway.natgw.probe_id  
}
