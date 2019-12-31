variable "AZURE_REGION" {
  type        = string
  default     = "uksouth"
  description = "The Azure region for the VMs and other resources to be created"
}
variable "AZDO_ORGANISATION" {
  type        = string
  default     = "ukhogov"
  description = "Name of the organisation where the agents will be added to"
}
variable "AZDO_TOKEN" {
  type        = string
  description = "Access token with permissions to added agents to the AzDo organisation"
}
variable "ADMIN_SSHKEYPATH" {
  type = string
}
variable "ADMIN_SSHKEYDATA" {
  type = string
}
variable "VM_SIZE" {
  type        = string
  default     = "Standard_F2s"
  description = "String of the VM size from https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes"
}
variable "BRANCH" {
  type        = string
  default     = "master"
  description = "Allows the install script to be run from a different branch, used when testing pull requests"
}
variable "ENVIRONMENT" {
  type        = string
  default     = "prd"
  description = "Addded to the resource group name creating a seperate resource group for each environment"
}
variable "TAGS" {
  type = map
}
