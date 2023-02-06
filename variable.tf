

##### 2-resource-group ####

variable "prefix" {
  type = string
  default = "bv"
  description = "This is prefix name"
}

variable "location" {
    type = string
    default = "KoreaCentral"
    description = "This is Location Name"
}


#### 3-virtual-network ###
variable "vnet_address_space" {
    type = list(string)
    default = ["22.23.0.0/16"]
}


#### 4-subnet address ###
variable "sec_subnet_address" {
    type = list(string)
    default = ["22.23.3.0/24"]
}
variable "endpoint_subnet_address" {
    type = list(string)
    default = ["22.23.5.0/24"]
}
variable "vmss_subnet_address" {
    type = list(string)
    default = ["22.23.30.0/24"]
}
variable "app_subnet_address" {
    type = list(string)
    default = ["22.23.100.0/24"]
}