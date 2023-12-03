# Configure the Azure provider
provider "azurerm" {
  features {}
}

provider "http" {}

data "http" "my_ip" {
  url = "https://api.ipify.org?format=json"
}

locals {
  my_ip = jsondecode(data.http.my_ip.body).ip
}

variable "admin_username" {
  type    = string
  default = "ubuntu"
}

variable "admin_password" {
  type    = string
  default = "ContainerEssentialsTTI!"
}

# Create a resource group
resource "azurerm_resource_group" "rg-ce" {
  name     = "rg-ce"
  location = "West US 2"
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet-ce" {
  name                = "vnet-ce"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg-ce.location
  resource_group_name = azurerm_resource_group.rg-ce.name
}

# Create a subnet
resource "azurerm_subnet" "subnet-ce" {
  name                 = "subnet-ce"
  resource_group_name  = azurerm_resource_group.rg-ce.name
  virtual_network_name = azurerm_virtual_network.vnet-ce.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a public IP address
resource "azurerm_public_ip" "pip-ce-docker-manager" {
  name                = "pip-ce-docker-manager"
  location            = azurerm_resource_group.rg-ce.location
  resource_group_name = azurerm_resource_group.rg-ce.name
  allocation_method   = "Static"
}

# Create a network interface
resource "azurerm_network_interface" "nic-ce-docker-manager" {
  name                = "nic-ce-docker-manager"
  location            = azurerm_resource_group.rg-ce.location
  resource_group_name = azurerm_resource_group.rg-ce.name

  ip_configuration {
    name                          = "ipconf-ce-docker-manager"
    subnet_id                     = azurerm_subnet.subnet-ce.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-ce-docker-manager.id
  }

}

# Create a network security group
resource "azurerm_network_security_group" "nsg-ce" {
  name                = "nsg-ce"
  location            = azurerm_resource_group.rg-ce.location
  resource_group_name = azurerm_resource_group.rg-ce.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = local.my_ip
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = local.my_ip
    destination_address_prefix = "*"
  }

}

# NSG -> Subnet Assoc
resource "azurerm_subnet_network_security_group_association" "nsg-sub-ass-ce" {
  subnet_id                 = azurerm_subnet.subnet-ce.id
  network_security_group_id = azurerm_network_security_group.nsg-ce.id
}

# Create a virtual machine
resource "azurerm_linux_virtual_machine" "vm-ce-docker-manager" {
  name                            = "vm-ce-docker-manager"
  location                        = azurerm_resource_group.rg-ce.location
  resource_group_name             = azurerm_resource_group.rg-ce.name
  network_interface_ids           = [azurerm_network_interface.nic-ce-docker-manager.id]
  size                            = "Standard_DS2_v2"
  computer_name                   = "docker-manager"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }


  os_disk {
    name                 = "osdisk-ce-docker-manager"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 50
  }

}


output "docker-manager-public-ip" {
  value = azurerm_public_ip.pip-ce-docker-manager.ip_address
}
