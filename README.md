# Azure Pipelines Agents

## via terraform

This project is aimed at quickly getting vms setup and initialised with docker and an azure devops agent.

## To create a new VM

Copy the module and paste in a different module name and VM number. this might be developed to instances of a module, just working things out. may be VM could be an array of VM names.

```shell
module "pool_agent00-ubuntu" {
  source                                 = "./modules/azdo_ubuntuagent"
  PREFIX                                 = "${var.PREFIX}"
  VSTS_POOL_PREFIX                       = "${var.VSTS_POOL_PREFIX}"
  VSTS_ACCOUNT                           = "${var.VSTS_ACCOUNT}"
  VSTS_TOKEN                             = "${var.VSTS_TOKEN}"
  ADMIN_USERNAME                         = "${var.ADMIN_USERNAME}"
  ADMIN_PASSWORD                         = "${var.ADMIN_PASSWORD}"
  ADMIN_SSHKEYPATH                       = "${var.ADMIN_SSHKEYPATH}"
  ADMIN_SSHKEYDATA                       = "${var.ADMIN_SSHKEYDATA}"
  AZURE_REGION                           = "${var.AZURE_REGION}"
  AZURERM_RESOURCE_GROUP_MAIN_NAME       = "${azurerm_resource_group.main.name}"
  AZURERM_RESOURCE_GROUP_MAIN_LOCATION   = "${azurerm_resource_group.main.location}"
  AZURERM_VIRTUAL_NETWORK_MAIN_NAME      = "${data.azurerm_virtual_network.main.name}"
  AZURERM_SUBNET_ID                      = "${data.azurerm_subnet.main.id}"
  AZURERM_NETWORK_SECURITY_GROUP_MAIN_ID = "${azurerm_network_security_group.main.id}"
  VM                                     = "${element(var.SERVERNAMES, 0)}"
  BRANCH                                 = "${var.BRANCH}"
}
```

for a ws2019 image use the `azdo_ws2019agent` agent

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

an example of the vars needed are listed below:

**NOTE** this terraform is not used to build the VNET, as there are other systems pinning to that. So these are referenced as known data objects. To run this you will need to create a separate RG for you VNET and internal and then provide those details at the run time of this process.

```shell
PREFIX                = "agent-prefix"
VNET_NAME             = "existing-vnetname"
INTERNAL_NETWORK_NAME = "existing-internalname"
VNET_RG               = "existing-vnetrg"
AZURE_CLIENT_ID       = "AZURE_CLIENT_ID"
AZURE_SUBSCRIPTION_ID = "AZURE_SUBSCRIPTION_ID"
AZURE_CLIENT_SECRET   = "AZURE_CLIENT_SECRET"
AZURE_TENANT_ID       = "AZURE_TENANT_ID"
AZURE_REGION          = "<Region>"
VSTS_TOKEN            = "xyz"
VSTS_POOL_PREFIX      = "PoolNamePrefix"
VSTS_ACCOUNT          = "VSTS_ACCOUNT"
ADMIN_USERNAME        = "account"
ADMIN_PASSWORD        = "Password"
ADMIN_SSHKEYPATH      = "/home/azureagent/.ssh/authorized_keys"
ADMIN_SSHKEYDATA      = "ssh-rsa xxxxadasdasdasd"
SERVERNAMES           = ["VM01", "VM02", "VM03", "VM04"]
BRANCH                = "master"
```
