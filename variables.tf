// Resource variables
variable "prefix" {
  type      = string
  default   = "tfvmcp" // Terraform Virtual Machine Competition
}

// How many internal boxes to make
variable "competition_images" {
    type    = number
    default = 0
}

// VM Settings
variable "resource_group_name" {
  type      = string
  default   = "competition-resources"
}

variable "resource_group_location" {
  type      = string
  default   = "East US"
}

variable "tenant_id" {
  type      = string
}

variable "subscription_id" {
  type      = string
}