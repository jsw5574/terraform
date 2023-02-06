

##### 2-resource-group ####

variable "prefix" {
  type = string
  default = "swjeong"
  description = "This is prefix name"
}

variable "location" {
    type = string
    default = "KoreaCentral"
    description = "This is Location Name"
}


#### 3-virtual-network ###
variable "address_space" {
    type = list(string)
    default = "[22.23.0.0/16]"
}
