resource "azurerm_network_interface" "main" {
  name                = "vm-nic-${local.name_prefix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = module.network.subnet_ids[module.network.private_subnet_key]
    primary = true
    private_ip_address_version = "IPv4"
    private_ip_address_allocation = "Dynamic"

  }
}

resource "tls_private_key" "vm_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "main" {
  name                  = "vm-${local.name_prefix}"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  size                = "Standard_B2ats_v2"
  admin_username      = "sa"
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  admin_ssh_key {
    username   = "sa"
    public_key = tls_private_key.vm_ssh.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"  #az vm image list -o table --publisher canonical
    sku       = "server"
    version   = "latest"
  }

  tags = local.common_tags
}

