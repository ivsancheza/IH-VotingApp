output "vm_id" {
  value = azurerm_linux_virtual_machine.result.id
}

output "result_nic_id" {
  value = azurerm_network_interface.result.id
}