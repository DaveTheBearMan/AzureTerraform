// Create network, subnet, and IP
resource "azurerm_virtual_network" "main" {
  name                = "internal"
  address_space       = ["10.0.0.0/16"]
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.internal_ip_range]
}

// Establish a security group
resource "azurerm_network_security_group" "SSHSecurity" {
  name                = "sshAcceptanceSecurityGroup"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSHConnection"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.ip_accept_range
    destination_address_prefix = azurerm_subnet.internal.address_prefixes[0]
  }
}

resource "azurerm_network_security_group" "Authentik" {
  name                = "authentik"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "80", "443", "9000", "9443", "3389", "6636", "9300", "5432"]
    source_address_prefix      = var.accept_all_range
    destination_address_prefix = azurerm_subnet.internal.address_prefixes[0]
  }
}

resource "azurerm_network_security_group" "InternalSecurity" {
  name                = "interalSecurityGroup"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSHConnection"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.internal_ip_range
    destination_address_prefix = azurerm_subnet.internal.address_prefixes[0]
  }
}

resource "azurerm_network_security_group" "WindowsFirewall" {
  name                         = "windowsSecurityGroup"
  location                     = var.resource_group_location
  resource_group_name          = var.resource_group_name

  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.ip_accept_range
    destination_address_prefix = azurerm_subnet.internal.address_prefixes[0]

    description                = "RDP acceptance for administrators."
  }

  security_rule {
    name                       = "web"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "MailServer" {
  name                         = "mailSecurityGroup"
  location                     = var.resource_group_location
  resource_group_name          = var.resource_group_name

  # Accept only from the RIT network. 
  # SSH [Administrator Acceptance]
  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.ip_accept_range
    destination_address_prefix = azurerm_subnet.internal.address_prefixes[0]

    description = "SSH acceptance from administrators"     
  }

  # POP
  security_rule {
    name                       = "IMAP"
    priority                   = 160
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "993"
    source_address_prefix      = var.ip_accept_range
    destination_address_prefix = azurerm_subnet.internal.address_prefixes[0]

    description = "IMAP acceptance from administrators"     
  }

  # SIEVE
  security_rule {
    name                       = "Sieve"
    priority                   = 180
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "4190"
    source_address_prefix      = var.ip_accept_range
    destination_address_prefix = azurerm_subnet.internal.address_prefixes[0]

    description = "SIEVE acceptance from administrators"     
  }


  # Public acceptance (These will accept IPs from anywhere, not just RIT network where I preside.)
  # SMTP [Broad Acceptance]
  security_rule {
    name                       = "POP"
    priority                   = 170
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "995"
    source_address_prefix      = var.ip_accept_range
    destination_address_prefix = azurerm_subnet.internal.address_prefixes[0]

    description = "POP acceptance from administrators"
  }

  # SMTP [Broad Acceptance]
  security_rule {
    name                       = "HTTPS"
    priority                   = 140
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = var.accept_all_range
    destination_address_prefix = azurerm_subnet.internal.address_prefixes[0]

    description = "Allows for broad HTTPS acceptance."
  }

  # SMTP [Broad Acceptance]
  security_rule {
    name                       = "SMTP_Secure"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "587"
    source_address_prefix      = var.accept_all_range
    destination_address_prefix = azurerm_subnet.internal.address_prefixes[0]

    description = "Allows for broad SMTP acceptance."
  }

  # SMTP [Broad Acceptance]
  security_rule {
    name                       = "SMTP_Old"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "25"
    source_address_prefix      = var.accept_all_range
    destination_address_prefix = azurerm_subnet.internal.address_prefixes[0]

    description = "Allows for old versions SMTP acceptance."
  }

  # DNS [Broad Acceptance]
  security_rule {
    name                       = "DNS"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefix      = var.accept_all_range
    destination_address_prefix = azurerm_subnet.internal.address_prefixes[0]

    description = "Allows for broad DNS acceptance."
  }
}