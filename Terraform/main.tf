terraform {
  backend "azurerm" {
    resource_group_name   = "terraformstate-rg"
    storage_account_name  = "tfstatevotingapp"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "445703eb-5438-48ba-b385-2a6b9fcbab5a"
}

module "vnet" {
  source = "./vnet"
  vnet_name = "votingapp-vnet"
  address_space = ["10.0.0.0/16"]
  resource_group_name = var.resource_group_name
  location = var.location
}

module "vm_vote" {
  source = "./vm_vote"
  vm_name = "vm-vote"
  vm_size = "Standard_B1s"
  admin_username = "adminuser"
  admin_password = "P@ssw0rd123"
  resource_group_name = var.resource_group_name
  location = var.location
  public_subnet_id = module.vnet.public_subnet_id
}

module "vm_result" {
  source = "./vm_result"
  vm_name = "vm-result"
  vm_size = "Standard_B1s"
  admin_username = "adminuser"
  admin_password = "P@ssw0rd123"
  resource_group_name = var.resource_group_name
  location = var.location
  public_subnet_id = module.vnet.public_subnet_id
}

module "vm_db" {
  source = "./vm_db"
  vm_name = "vm-db"
  vm_size = "Standard_B1s"
  admin_username = "adminuser"
  admin_password = "P@ssw0rd123"
  resource_group_name = var.resource_group_name
  location = var.location
  private_subnet_id = module.vnet.private_subnet_id
}

module "nsg" {
  source = "./nsg"
  resource_group_name = var.resource_group_name
  location = var.location
}

module "app_gateway" {
  source = "./app_gateway"
  ag_name = "app-gateway"
  resource_group_name = var.resource_group_name
  location = var.location
  public_subnet_id = module.vnet.public_subnet_id
  app_gateway_subnet_id = module.vnet.app_gateway_subnet_id
}