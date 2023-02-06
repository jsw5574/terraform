
resource "azurerm_subnet" "was_subnet" {
  name                 = "${var.prefix}-was-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = "${var.was_subnet_address}"
}


resource "azurerm_network_security_group" "was-subnet-nsg" {
    name                = "${azurerm_subnet.was_subnet.name}-nsg"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "was_subnet_nsg_associate" {
    depends_on = [ azurerm_network_security_rule.was_nsg_rule_inbound ]
    subnet_id   = azurerm_network_security_group.was_subnet_nsg.id
}

locals {
  was_inbound_ports_map = {
    "100" : "80",
    "110" : "443",
  }
}

resource "azurerm_network_security_rule" "was_nsg_rule_inbound" {
    for_each = local.was_inbound_ports_map
    name                         = "Allow-${each.value}"
    priority                     = each.key
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = each.value
    source_address_prefix        = "*"
    destination_address_prefix   = "*"
    resource_group_name          = azurerm_resource_group.rg.name
    network_security_group_name  = azurerm_network_security_group.was_subnet_nsg.name
      }   

