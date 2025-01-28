output "public_subnet_id" {
  value = module.vnet.public_subnet_id
}

output "private_subnet_id" {
  value = module.vnet.private_subnet_id
}

output "vm_vote_id" {
  value = module.vm_vote.vm_id
}

output "vm_result_id" {
  value = module.vm_result.vm_id
}

output "vm_db_id" {
  value = module.vm_db.vm_id
}

output "app_gateway_id" {
  value = module.app_gateway.app_gateway_id
}