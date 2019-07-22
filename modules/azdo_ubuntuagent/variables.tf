variable "AZURE_REGION" {
  type = "string"
}

variable "PREFIX" {
  type = "string"
}
variable "VSTS_ACCOUNT" {
  type = "string"
}
variable "VSTS_TOKEN" {
  type = "string"
}
variable "VSTS_POOL_PREFIX" {
  type = "string"
}
variable "VM" {
  type = "string"
}
variable "ADMIN_USERNAME" {
  type = "string"
}
variable "ADMIN_PASSWORD" {
  type = "string"
}

variable "ADMIN_SSHKEYPATH" {
  type = "string"
}

variable "ADMIN_SSHKEYDATA" {
  type = "string"
}

variable "AZURERM_RESOURCE_GROUP_MAIN_NAME" {
  type = "string"
}

variable "AZURERM_RESOURCE_GROUP_MAIN_LOCATION" {
  type = "string"
}

variable "AZURERM_VIRTUAL_NETWORK_MAIN_NAME" {
  type = "string"
}

variable "AZURERM_SUBNET_ID" {
  type = "string"
}

variable "AZURERM_NETWORK_SECURITY_GROUP_MAIN_ID" {
  type = "string"
}
variable "BRANCH" {
  type = "string"
}
variable "VSTS_AGENT_COUNT" {
  type        = number
  description = "The number of Azure DevOps agents to install on the VM"
  default     = 2
}
variable "TAGS" {
  type = "map"
}
