# Data blocks
data "azurerm_client_config" "current" {}

# Local Blocks
locals {
  current_user_id = data.azurerm_client_config.current.object_id
}


# Module blocks
module "storage" {
  source                        = "./storage"

  // Resource Group
  resource_group_name           = var.resource_group_name
  resource_group_location       = var.resource_group_location
}

module "network" {
  source                        = "./network"

  // Resource Group
  resource_group_name           = module.storage.resource_group_name
  resource_group_location       = module.storage.resource_group_location
}

module "jump_box" {
  source                        = "./jump_box"

  // Resource group
  resource_group_name           = module.storage.resource_group_name
  resource_group_location       = module.storage.resource_group_location

  // Network
  network_interface_id          = module.network.virtual_network
  internal_subnet_id            = module.network.internal_subnet
  network_security_group_id     = module.network.SSHSecurity
}

module "internal_vm" {
  source                        = "./internal_vm"
  count                         = 1

  // Resource group
  resource_group_name           = module.storage.resource_group_name
  resource_group_location       = module.storage.resource_group_location

  // Network
  network_interface_id          = module.network.virtual_network
  internal_subnet_id            = module.network.internal_subnet
  network_security_group_id     = module.network.InternalSecurity
}