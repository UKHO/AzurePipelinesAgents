variable "vm_name" {
  type = string
  description = "Name of the VM to be created. Must fulfill UKHO standards"
}
variable "vm_size" {
  type = string
  default     = "Standard_F4s"
  description = "String of the VM size from https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes"
}
variable "VM_RG_NAME"{
  type = string
}
variable "VM_REGION" {
  type        = string
  default     = "uksouth"
  description = "The Azure region for the VMs and other resources to be created"
}
variable "ADMIN_SSHKEYPATH" {
  type = string
}
variable "ADMIN_SSHKEYDATA" {
  type = string
}
variable "ADMIN_USERNAME" {	
  type = string	
}
variable "run_date" {
  type = string
}
variable "SPOKE_NSG_ID" {
  type = string
}
variable "SPOKE_SUBNET_ID" {
  type = string
}
variable "AZDO_ORGANISATION"{
  type = string
  description = "Name of the organisation where the agents will be added to"
}
variable "AZDO_TOKEN"{
  type = string
  description = "Access token with permissions to added agents to the AzDo organisation"
}
variable "AZDO_POOL_PREFIX"{
  type = string
  default = "UKHO"
  description = "String to be prefixed to the pool name"
}
variable "BRANCH" {
  type = string
  default     = "master"
  description = "Allows the install script to be run from a different branch, used when testing pull requests"
}
variable "TAGS" {
  type = map
}