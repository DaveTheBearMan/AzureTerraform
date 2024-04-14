// Resource variables
variable "prefix" {
  type      = string
  default   = "tfvmcp" // Terraform Virtual Machine Competition
}

variable "uid" {
  type      = number
  default   = 12345
}

// Infastructure configuration
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
      username = "MailAdmin"
      password = "This is a great password hash"
    }
}

variable "vm_size" {
  type    = string
  default = "Standard_B1ms"
}

// Network configuration
variable "internal_subnet_id" {
  type    = string
}

variable "network_security_group_id" {
  type    = string
}

variable "network_interface_id" {
  type    = string
}

// Resource group configuration
variable "resource_group_name" {
  type    = string
}

variable "resource_group_location" {
  type    = string
}