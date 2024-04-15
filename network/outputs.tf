output "virtual_network" {
  value = azurerm_virtual_network.main.id
}

output "internal_subnet" {
  value = azurerm_subnet.internal.id
}

output "SSHSecurity" {
  value = azurerm_network_security_group.SSHSecurity.id
}

output "InternalSecurity" {
  value = azurerm_network_security_group.InternalSecurity.id
}

output "MailSecurity" {
  value = azurerm_network_security_group.MailServer.id
}

output "WindowsSecurity" {
  value = azurerm_network_security_group.WindowsFirewall.id
}