# Create lb pip #
resource "azurerm_public_ip" "ext_lb_pip" {
    name = "${var.prefix}-ext-lb-pip"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    allocation_method = "Static"
    sku = "Standard"
    
}

# create LB #
resource "azurerm_lb" "ext_lb" {
    name = "${var.prefix}-ext-lb"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    sku = "Standard"
    frontend_ip_configuration {
      name  = "${var.prefix}-ext-lb-frontend"
      public_ip_address_id = azurerm_public_ip.ext_lb_pip.id
     }
}

# backend Pool #

resource "azurerm_lb_backend_address_pool" "ext_lb" {
    name = "ext-lb-bandendpool"
    loadbalancer_id = azurerm_lb.ext_lb.id
}

# Heatl Probe #

resource "azurerm_lb_probe" "ext_probe" {
    name = "ext-lb-probe-222"
    protocol = "TCP"
    port = 222
    loadbalancer_id = azurerm_lb.ext_lb.id
    resource_group_name = azurerm_resource_group.rg.name
}


## Rule Create ##

resource "azurerm_lb_rule" "rule_80" {
    name = "ext-lb-rule-80"
    protocol = "tcp"
    frontend_port = 80
    backend_port = 80
    frontend_ip_configuration_name = azurerm_lb.ext_lb.frontend_ip_configuration[0].name
    backend_address_pool_ids = [ azurerm_lb_backend_address_pool.ext_lb.id ]
    probe_id = azurerm_lb_probe.ext_probe.id
    loadbalancer_id = azurerm_lb.ext_lb.id
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_lb_rule" "rule_443" {
    name = "ext-lb-rule-443"
    protocol = "tcp"
    frontend_port = 443
    backend_port = 443
    frontend_ip_configuration_name = azurerm_lb.ext_lb.frontend_ip_configuration[0].name
    backend_address_pool_ids = [ azurerm_lb_backend_address_pool.ext_lb.id ]
    probe_id = azurerm_lb_probe.ext_probe.id
    loadbalancer_id = azurerm_lb.ext_lb.id
    resource_group_name = azurerm_resource_group.rg.name
}


/*
# Resource-6: Associate Network Interface and Standard Load Balancer
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association
resource "azurerm_network_interface_backend_address_pool_association" "waf1_nic_associate" {
  network_interface_id    = azurerm_network_interface.waf1_nic.id
  ip_configuration_name   = azurerm_network_interface.waf1_nic.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.ext_lb.id
}

resource "azurerm_network_interface_backend_address_pool_association" "waf2_nic_associate" {
  network_interface_id    = azurerm_network_interface.waf2_nic.id
  ip_configuration_name   = azurerm_network_interface.waf2_nic.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.ext_lb.id
}
*/


