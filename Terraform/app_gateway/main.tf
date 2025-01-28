resource "azurerm_public_ip" "example" {
  name                = "public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "example" {
  name                = var.ag_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.app_gateway_subnet_id
  }

  frontend_port {
    name = "frontendPort"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontendIpConfig"
    public_ip_address_id = azurerm_public_ip.example.id
  }

  backend_address_pool {
    name = "votePool"
  }

  backend_address_pool {
    name = "resultPool"
  }

  http_listener {
    name                           = "listener_vote"
    frontend_ip_configuration_name = "frontendIpConfig"
    frontend_port_name             = "frontendPort"
    protocol                       = "Http"
  }

  http_listener {
    name                           = "listener_result"
    frontend_ip_configuration_name = "frontendIpConfig"
    frontend_port_name             = "frontendPort"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "voteRule"
    rule_type                  = "Basic"
    http_listener_name         = "listener_vote"
    backend_address_pool_name  = "votePool"
    backend_http_settings_name = "backendHttpSettings_vote"
    priority                   = 100
  }

  request_routing_rule {
    name                       = "resultRule"
    rule_type                  = "Basic"
    http_listener_name         = "listener_result"
    backend_address_pool_name  = "resultPool"
    backend_http_settings_name = "backendHttpSettings_result"
    priority                   = 200
  }

  backend_http_settings {
    name                  = "backendHttpSettings_vote"
    cookie_based_affinity = "Disabled"
    port                  = 80
    path                  = "/vote/"
    protocol              = "Http"
    request_timeout       = 60
  }

  backend_http_settings {
    name                  = "backendHttpSettings_result"
    cookie_based_affinity = "Disabled"
    port                  = 80
    path                  = "/result/"
    protocol              = "Http"
    request_timeout       = 60
  }
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "result_backend_association" {
  network_interface_id    = var.result_nic_id
  ip_configuration_name   = "internal"
  backend_address_pool_id = tolist(azurerm_application_gateway.example.backend_address_pool).0.id
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "vote_backend_association" {
  network_interface_id    = var.vote_nic_id
  ip_configuration_name   = "internal"
  backend_address_pool_id = tolist(azurerm_application_gateway.example.backend_address_pool).1.id
}