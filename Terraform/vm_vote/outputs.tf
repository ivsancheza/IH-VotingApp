output "vm_id" {
  value = azurerm_linux_virtual_machine.vote.id
}

output "vote_nic_id" {
  value = azurerm_network_interface.vote.id
}