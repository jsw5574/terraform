resource "azurerm_monitor_autoscale_setting" "vmss" {
    name = "${var.prefix}-vmss-autoscale-profiles"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    target_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id

    notification {
      email {
        send_to_subscription_administrator      = true
        send_to_subscription_co_administrator   = true
        custom_emails                           = "${var.custom_email}"
      }

    }
    profile {
      name = "default"
      capacity {
        default = 2
        minimum = 2
        maximum = 6
      }

    ################################ Start CPU RULE ################################
    ### Scale_OUT  RULE ###
    rule {
      scale_action {
        direction   = "Increase"
        type        = "ChangeCount"
        value       = 1
        cooldown    = "PT5M"
      }
      metric_trigger {
        metric_name            = "Percentage CPU"
        metric_resource_id     = azurerm_linux_virtual_machine_scale_set.vmss.id
        metric_namespace       = "microsoft.compute/virtualmachinescalesets" 
        time_grain             = "PT1M"
        statistic              = "Average"
        time_window            = "PT5M"
        time_aggregation       = "Average"
        operator               = "GreaterThan"
        threshold              = 75

      } 
    }
    ### Scale-In Rule ####
    rule {
      scale_action {
        direction   = "Decrease"
        type        = "ChangeCount"
        value       = 1
        cooldown    = "PT5M"
      }
      metric_trigger {
        metric_name            = "Percentage CPU"
        metric_resource_id     = azurerm_linux_virtual_machine_scale_set.vmss.id
        metric_namespace       = "microsoft.compute/virtualmachinescalesets" 
        time_grain             = "PT1M"
        statistic              = "Average"
        time_window            = "PT5M"
        time_aggregation       = "Average"
        operator               = "LessThan"
        threshold              = 25 
    
         }
      }

    ################################ END CPU RULE ################################

    ################################ Start Memory RULE ################################
    ### Scale_OUT  RULE ###
    rule {
      scale_action {
        direction   = "Increase"
        type        = "ChangeCount"
        value       = 1
        cooldown    = "PT5M"
      }
      metric_trigger {
        metric_name            = "Available Memory Bytes"
        metric_resource_id     = azurerm_linux_virtual_machine_scale_set.vmss.id
        metric_namespace       = "microsoft.compute/virtualmachinescalesets" 
        time_grain             = "PT1M"
        statistic              = "Average"
        time_window            = "PT5M"
        time_aggregation       = "Average"
        operator               = "LessThan"
        threshold              = 1073741824

      } 
    }
    ### Scale-In Rule ####
    rule {
      scale_action {
        direction   = "Decrease"
        type        = "ChangeCount"
        value       = 1
        cooldown    = "PT5M"
      }
      metric_trigger {
        metric_name            = "Available Memory Bytes"
        metric_resource_id     = azurerm_linux_virtual_machine_scale_set.vmss.id
        metric_namespace       = "microsoft.compute/virtualmachinescalesets" 
        time_grain             = "PT1M"
        statistic              = "Average"
        time_window            = "PT5M"
        time_aggregation       = "Average"
        operator               = "GreaterThan"
        threshold              = 2147483648 
    
         }
      }

    ################################ END Memory RULE ################################


    } # end Profile
}