// General Naming Schemes
variable "name" {
  type    = string
  default = "interal_vm"
}

// Instance id
variable "identifier" {
  type      = number
  default   = 0
}

// Resource variables
variable "prefix" {
  type      = string
  default   = "tfvmcp" // Terraform Virtual Machine Competition
}

variable "vm_size" {
  type    = string
  default = "Standard_DS1_v2"
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
      password = "IlpoFt13"
    }
}

// Configuration bullshit
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