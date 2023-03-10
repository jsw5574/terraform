
### create sec subnet ###

resource "azurerm_subnet" "sec_subnet" {
  name                 = "${var.prefix}-sec-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = "${var.sec_subnet_address}"
}


resource "azurerm_network_security_group" "sec_subnet_nsg" {
    name                = "${azurerm_subnet.sec_subnet.name}-nsg"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "sec_subnet_nsg_associate" {
  depends_on = [ azurerm_network_security_rule.sec_nsg_rule_inbound] # Every NSG Rule Association will disassociate NSG from Subnet and Associate it, so we associate it only after NSG is completely created - Azure Provider Bug https://github.com/terraform-providers/terraform-provider-azurerm/issues/354  
  subnet_id                 = azurerm_subnet.sec_subnet.id
  network_security_group_id = azurerm_network_security_group.sec_subnet_nsg.id
}

locals {
  sec_inbound_ports_map = {
    "100" : "80",
    "110" : "443",
  }
}

resource "azurerm_network_security_rule" "sec_nsg_rule_inbound" {
    for_each = local.sec_inbound_ports_map
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
    network_security_group_name  = azurerm_network_security_group.sec_subnet_nsg.name
      }   

