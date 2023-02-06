

##### 2-resource-group ####

variable "prefix" {
  type = string
  default = "swjeong"
  description = "This is prefix name"
}

variable "location" {
    type = string
    default = "KoreaCentral"
    dedescription = "This is Location Name"
}


#### 3-virtual-network ###
variable "address_space" {
    type = string
    default = "22.23.0.0/16"
}

variable "subnet_names" {
  
}