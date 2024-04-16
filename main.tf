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

module "authentik" {
  source                        = "./generic_vm"

  // Crazy
  internal_subnet_id            = module.network.internal_subnet
  network_security_group_id     = module.network.SSOSecurity
  network_interface_id          = module.network.virtual_network

  // Resource Group
  resource_group_name           = module.storage.resource_group_name
  resource_group_location       = module.storage.resource_group_location
}