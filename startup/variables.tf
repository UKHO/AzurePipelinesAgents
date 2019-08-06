variable "SUBSCRIPTION_ID" {
}

variable "PROJECT_IDENTITY" {
}

variable "TENANT_ID" {
}

variable "CLIENT_ID" {
}

variable "CLIENT_SECRET" {

}

variable "ACCESS_KEY" {

}

variable "PIPELINE_SP" {
}

variable "TERRAFORM_SP" {

}

variable "AdminAccessObjectId" {  
}


variable "LOCATION" {
  default = "UKSOUTH"
}

variable "TAGS" {
  type = "map"
  default = {
    ENVIRONMENT      = ""
    SERVICE          = ""
    SERVICE_OWNER    = ""
    RESPONSIBLE_TEAM = ""
  }
}
