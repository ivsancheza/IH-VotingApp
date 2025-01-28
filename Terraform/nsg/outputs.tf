output "nsg_vote_id" {
  value = azurerm_network_security_group.nsg_vote.id
}

output "nsg_result_id" {
  value = azurerm_network_security_group.nsg_result.id
}

output "nsg_db_id" {
  value = azurerm_network_security_group.nsg_db.id
}