variable "AZURE_REGION" {
  type = "string"
}

variable "PREFIX" {
  type = "string"
}
variable "VNET_NAME" {
  type = "string"
}
variable "VNET_RG" {
  type = "string"
}
variable "INTERNAL_NETWORK_NAME" {
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

variable "SERVERNAMES" {
  type = "list"
}
variable "BRANCH" {
  type = "string"
}

variable "TAGS" {
  type="map"
}
