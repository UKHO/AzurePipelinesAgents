variable "AZURE_REGION" {
  type = "string"
}

variable "ProjectIdentity" {}

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
  default = "master"
}

variable "TAGS" {
  type="map"
}

variable "RUN_DATE" {
  type="string"
}

variable "ENVIRONMENT" {
  default = "prd"
}
