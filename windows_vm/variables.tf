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
variable "windows_image_properties" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "win10-22h2-pron-g2"
    version   = "latest"
  }
}

variable "admin_credentials" {
    type = object({
      username  = string
      password  = string
    })
    default = {
      username = "WindowsAdmin"
      password = "EasierPasswordToType"
    }
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