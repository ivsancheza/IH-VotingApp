output "public_subnet_id" {
  value = azurerm_subnet.public.id
}

output "private_subnet_id" {
  value = azurerm_subnet.private.id
}

# output "app_gateway_subnet_id" {
#   value = azurerm_subnet.app_gateway.id
# }