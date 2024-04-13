resource "azurerm_public_ip" "general_vm_public_ip" {
  name                = "Win-PublicIpAddress-${var.uid}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Dynamic"
}

// Establish a NIC
resource "azurerm_network_interface" "generic_nic" {
  name                = "windows-nic-${var.uid}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.internal_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.general_vm_public_ip.id
  }
}

// Attach security group to the nic
resource "azurerm_network_interface_security_group_association" "nic_sec_association" {
  network_interface_id      = azurerm_network_interface.generic_nic.id
  network_security_group_id = var.network_security_group_id
}

// Virtual Machine
resource "azurerm_virtual_machine" "main" {
  name                  = "windows-${var.prefix}-vm-${var.uid}"
  location              = var.resource_group_location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.generic_nic.id]
  vm_size               = "Standard_B2s"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.windows_image_properties.publisher
    offer     = var.windows_image_properties.offer
    sku       = var.windows_image_properties.sku
    version   = var.windows_image_properties.version
  }
  storage_os_disk {
    name              = "windows-vm-${var.uid}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = var.admin_credentials.username
    admin_password = var.admin_credentials.password
  }
  os_profile_windows_config {
    
  }
}