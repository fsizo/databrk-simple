resource "azurerm_public_ip" "brk-ip" {
  name                = "brk-ip"
  resource_group_name = azurerm_resource_group.fsi-rg.name
  location            = var.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "vmsubnet" {
  name                 = "${local.prefix}-vmprivatelink"
  resource_group_name  = azurerm_resource_group.fsi-rg.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [cidrsubnet(var.cidr, 3, 5)]
}

resource "azurerm_network_interface" "brk-nic" {
  name                = "brk-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.fsi-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vmsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.brk-ip.id
  }

  tags = {
    environment = "dev"
  }
}


resource "azurerm_windows_virtual_machine" "brk-vm" {
  name                = "brk-vm"
  resource_group_name = azurerm_resource_group.fsi-rg.name
  location            = var.location
  size                = "Standard_DS1_v2"
  admin_username      = "fsizo"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.brk-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-10"
    sku       = "19h2-ent"
    version   = "latest"
  }
}


resource "azurerm_network_security_group" "nsg-vm" {
  name                = "nsg-vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.fsi-rg.name
  tags                = local.tags
}

resource "azurerm_network_security_rule" "nsg-rule" {
  name                        = "rdp"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.fsi-rg.name
  network_security_group_name = azurerm_network_security_group.nsg-vm.name
}

resource "azurerm_subnet_network_security_group_association" "vm" {
  subnet_id                 = azurerm_subnet.vmsubnet.id
  network_security_group_id = azurerm_network_security_group.nsg-vm.id
}