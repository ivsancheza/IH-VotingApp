resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "public" {
  name                 = "public"
  resource_group_name  = azurerm_virtual_network.main.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "private" {
  name                 = "private"
  resource_group_name  = azurerm_virtual_network.main.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_route_table" "main" {
  name                = "mainRouteTable"
  location            = azurerm_virtual_network.main.location
  resource_group_name = azurerm_virtual_network.main.resource_group_name
}

resource "azurerm_route" "public_to_private" {
  name                   = "publicToPrivate"
  resource_group_name    = azurerm_virtual_network.main.resource_group_name
  route_table_name       = azurerm_route_table.main.name
  address_prefix         = "10.0.2.0/24"
  next_hop_type          = "VnetLocal"
}

resource "azurerm_route" "private_to_public" {
  name                   = "privateToPublic"
  resource_group_name    = azurerm_virtual_network.main.resource_group_name
  route_table_name       = azurerm_route_table.main.name
  address_prefix         = "10.0.1.0/24"
  next_hop_type          = "VnetLocal"
}

resource "azurerm_subnet_route_table_association" "public" {
  subnet_id      = azurerm_subnet.public.id
  route_table_id = azurerm_route_table.main.id
}

resource "azurerm_subnet_route_table_association" "private" {
  subnet_id      = azurerm_subnet.private.id
  route_table_id = azurerm_route_table.main.id
}

# resource "azurerm_subnet" "app_gateway" {
#   name                 = "app-gateway"
#   resource_group_name  = azurerm_virtual_network.main.resource_group_name
#   virtual_network_name = azurerm_virtual_network.main.name
#   address_prefixes     = ["10.0.3.0/24"]
# }

