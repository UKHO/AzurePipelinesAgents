variable "vm_name" {
  type = string
  description = "Name of the VM to be created. Must fulfill UKHO standards"
}
variable "vm_size" {
  type = string 
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
}
variable "AZDO_TOKEN"{
  type = string
}
variable "AZDO_POOL_PREFIX"{
  type = string
  default = "UKHO"
}
variable "BRANCH" {
  type = string
}
variable "TAGS" {
  type = map
}