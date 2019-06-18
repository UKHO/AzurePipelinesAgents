# Azure Pipelines Agents1

## via terraform

This project is aimed at quickly getting vms setup and initialised with docker and an azure devops agent.

## To create a new VM

Copy the module and paste in a different module name and VM number. this might be developed to instances of a module, just working things out. may be VM could be an array of VM names.

```shell
module "ubuntupool_agent00" {
  source                               = "./modules/azdo_ubuntuagent"
  PREFIX                               = "${var.PREFIX}"
  VSTS_POOL                            = "${var.VSTS_POOL}"
  VSTS_ACCOUNT                         = "${var.VSTS_ACCOUNT}"
  VSTS_TOKEN                           = "${var.VSTS_TOKEN}"
  ADMIN_USERNAME                       = "${var.ADMIN_USERNAME}"
  ADMIN_PASSWORD                       = "${var.ADMIN_PASSWORD}"
  ADMIN_SSHKEYPATH                     = "${var.ADMIN_SSHKEYPATH}"
  ADMIN_SSHKEYDATA                     = "${var.ADMIN_SSHKEYDATA}"
  AZURE_CLIENT_ID                      = "${var.AZURE_CLIENT_ID}"
  AZURE_CLIENT_SECRET                  = "${var.AZURE_CLIENT_SECRET}"
  AZURE_TENANT_ID                      = "${var.AZURE_TENANT_ID}"
  AZURE_SUBSCRIPTION_ID                = "${var.AZURE_SUBSCRIPTION_ID}"
  AZURE_REGION                         = "${var.AZURE_REGION}"
  AZURERM_RESOURCE_GROUP_MAIN_NAME     = "${azurerm_resource_group.main.name}"
  AZURERM_RESOURCE_GROUP_MAIN_LOCATION = "${azurerm_resource_group.main.location}"
  AZURERM_VIRTUAL_NETWORK_MAIN_NAME    = "${azurerm_virtual_network.main.name}"
  AZURERM_SUBNET_ID                    = "${azurerm_subnet.main.id}"
  VM                                   = "${var.VM}00"
}
```

Any  terraform variables can be defined as an environmental, but will need the prefix of `TF_VAR_`

you will also notice in the pipeline.yml that the plan step is being passed some `env:` values, these are secret values that are not available by default so need to be opted in.

## initialise terraform

```shell
teraform init
```

## test what it might do

```shell
terraform plan
```

## Apply changes

```shell
terraform apply
```

You have to provide `-auto-approve` to get it not to ask you "are you sure?"

## What is missing

you will need a local `terraform.tfvars` file to map the required variable against.

```shell
PREFIX = "wow",
AZURE_CLIENT_ID = "SECRET_CLIENT_ID",
AZURE_SUBSCRIPTION_ID = "SUBSCRIPTION",
AZURE_CLIENT_SECRET = "CLIENT_PASSORD",
AZURE_TENANT_ID = "TENANT",
AZURE_REGION = "west europe",
VM = "VMNamePrefix"
VSTS_TOKEN = "xxx",
VSTS_POOL = "yyy"
VSTS_ACCOUNT = "account"
ADMIN_USERNAME = "dave"
ADMIN_PASSWORD = "Pass"
ADMIN_SSHKEYPATH = "/home/dave/.ssh/authorized_keys"
ADMIN_SSHKEYDATA = "ssh-rsa xxxasdasdasdasd123123123123"
```
