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
    name = "frontendPortVote"
    port = 80
  }

  frontend_port {
    name = "frontendPortResult"
    port = 8080
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
    frontend_port_name             = "frontendPortVote"
    protocol                       = "Http"
  }

  http_listener {
    name                           = "listener_result"
    frontend_ip_configuration_name = "frontendIpConfig"
    frontend_port_name             = "frontendPortResult"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "voteRule"
    rule_type                  = "Basic"
    http_listener_name         = "listener_vote"
    backend_address_pool_name  = "votePool"
    backend_http_settings_name = "backendHttpSettings"
    priority                   = 100
  }

  request_routing_rule {
    name                       = "resultRule"
    rule_type                  = "Basic"
    http_listener_name         = "listener_result"
    backend_address_pool_name  = "resultPool"
    backend_http_settings_name = "backendHttpSettings"
    priority                   = 200
  }

  backend_http_settings {
    name                  = "backendHttpSettings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }
}