variable "ag_name" {
  description = "The name of the Application Gateway"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the Application Gateway"
  type        = string
}

variable "public_subnet_id" {
  description = "The ID of the public subnet"
  type        = string
}

variable "app_gateway_subnet_id" {
  description = "The ID of the Application Gateway subnet"
  type        = string
}