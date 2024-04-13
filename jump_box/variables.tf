// Resource variables
variable "prefix" {
  type      = string
  default   = "tfvmcp" // Terraform Virtual Machine Competition
}

// Infastructure
variable "ubuntu_image_properties" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

variable "admin_credentials" {
    type = object({
      username  = string
      password  = string
    })
    default = {
      username = "DTBM"
      password = "AreWeSureWeCantUseAzure?"
    }
}

// General configuration ID's that have to be passed through because fucking global variables dont fucking exist because some fucking cuck wrote terraform and not a chad
variable "internal_subnet_id" {
  type    = string
}

variable "network_security_group_id" {
  type    = string
}

variable "network_interface_id" {
  type    = string
}

variable "resource_group_name" {
  type    = string
}

variable "resource_group_location" {
  type    = string
}