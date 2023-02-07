resource "azurerm_lb" "vmss_lb" {
    name                             = "${var.prefix}-vmss-lb"
    resource_group_name              = azurerm_resource_group.rg.name
    location                         = azurerm_resource_group.rg.location
    sku                              = "Standard"
    frontend_ip_configuration {
      name                           = "bv-vmss-lb-nic"
      subnet_id                      = azurerm_subnet.vmss_subnet.id
      private_ip_address_allocation  = "static"
      private_ip_address_version     = "IPv4"
      private_ip_address             = "22.23.30.10" 
    }           
}

## backend Pool ##
resource "azurerm_lb_backend_address_pool" "backendpool" {
    name                    = "vmss-backend"
    loadbalancer_id         = azurerm_lb.vmss_lb.id
     
}

## Health Probe ##
resource "azurerm_lb_probe" "vmss_probe" {
  name                      = "vmss-probe"
  protocol                  = "tcp"
  port                      = 80
  loadbalancer_id           = azurerm_lb.vmss_lb.id
  resource_group_name       = azurerm_resource_group.rg.name
   
}

## LB RULE ##

resource "azurerm_lb_rule" "vmss_rule" {
    name                           = "vmss-rule"
    protocol                       = "tcp"
    frontend_port                  = 8010
    backend_port                   = 8010
    frontend_ip_configuration_name = azurerm_lb.vmss_lb.frontend_ip_configuration[0].name
    backend_address_pool_ids       = azurerm_lb_backend_address_pool.backendpool.id
    probe_id                       = azurerm_lb_probe.vmss_probe.id
    loadbalancer_id                = azurerm_lb.vmss_lb.id
    resource_group_name            = azurerm_resource_group.rg.name   
}


# Resource-6: Associate Network Interface and Standard Load Balancer
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association
resource "azurerm_network_interface_backend_address_pool_association" "vmss_associate" {
  network_interface_id    = azurerm_network_interface.app_linuxvm_nic.id
  ip_configuration_name   = azurerm_network_interface.app_linuxvm_nic.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.app_lb_backend_address_pool[*].id
}
