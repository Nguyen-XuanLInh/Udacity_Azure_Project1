provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-rg"
  location = var.location
}

# 1 Create Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/22"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    Name = "tagging-policy"
  }
}

# 2 Create Subet
resource "azurerm_subnet" "main" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

# 3 Create Network Security, Security Group, Security Rule
resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-security-group"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Web"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Name = "tagging-policy"
  }
}

# 4 Create Network Interface
resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-network_interface"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    Name = "tagging-policy"
  }
}

# 5 Create Public IP
resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-public-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"

  tags = {
    Name = "tagging-policy"
  }
}

# 6 Create Load Balancer
resource "azurerm_lb" "main" {
  name                = "${var.prefix}-load-balancer"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  frontend_ip_configuration {
    name                 = "${var.prefix}-frontend-ip"
    public_ip_address_id = azurerm_public_ip.main.id
  }

  tags = {
    Name = "tagging-policy"
  }
}

# 7 Create Load Balancer Rules
resource "azurerm_lb_rule" "main" {
  loadbalancer_id                = azurerm_lb.myLB.id
  name                           = "${var.prefix}-load-balancer-rule"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 80
  frontend_ip_configuration_name = "${var.prefix}-frontend-ip"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.main.id]

  depends_on = [
    azurerm_lb.main
  ]
}

# 8 Create Backend Adress Pool 
resource "azurerm_lb_backend_address_pool" "main" {
  loadbalancer_id = azurerm_lb.main.id
  name            = "${var.prefix}-backend-address-pool"
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_network_interface_backend_address_pool_association" "main" {
  count                   = var.vm_count
  network_interface_id    = element(azurerm_network_interface.myNI.*.id, count.index)
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = "${var.prefix}-vm"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_D2s_v3"
  admin_username                  = "${var.username}"
  admin_password                  = "${var.password}"
  network_interface_ids           = [element(azurerm_network_interface.myNI.*.id, count.index)]
  disable_password_authentication = false
  source_image_id                 = var.packerImageId
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
    Name = "tagging-policy"
  }
}