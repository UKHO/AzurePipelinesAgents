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

## secrets.auto.tfvars.enc

Some secrets are encrypted and stored in the source code. the secret used is the access key found in the terraform vault for this project. these are decrypted and encypted using the `./secret` script.

## initialise terraform using make

- Install make, for windows, this is easily done with chocolatey `choco install make`
  - Remember that make runs best from bash.

- You will also need the access key stored as an environmental add a line to your .bash_profile to `export ARM_ACCESS_KEY="<fromVault>"`

**N.B.** If you do not have access to make, you will still be able to run the standard `terraform` commmand.

```shell
make init
```

## test what it might do

```shell
make plan
```

## Apply changes

```shell
make apply
```

## What is missing

you will need some extra variable if you are running local `.tfvars`.

```shell
BRANCH  = "master"
PREFIX  = "agents"
TAGS    = {
    ENVIRONMENT = "DEV"
    SERVICE = "AzDO"
    SERVICE_OWNER = "Bob Martin"
    RESPONSIBLE_TEAM = "Digital"
}
```

an example of the vars needed are listed below:

**NOTE** this terraform is not used to build the VNET, as there are other systems pinning to that. So these are referenced as known data objects. To run this you will need to create a separate RG for you VNET and internal and then provide those details at the run time of this process.

the secrets that are decrypted are for the following variables:

```shell
ADMIN_PASSWORD        = "<PASSWORD>"
ADMIN_SSHKEYDATA      = "<SSHRSA>"
VNET_NAME             = "<VNETNAME>"
INTERNAL_NETWORK_NAME = "<SUBNETNAME>"
VNET_RG               = "<RG>"
AZURE_REGION          = "<REGION>"
VSTS_POOL_PREFIX      = "TEST"
VSTS_ACCOUNT          = "<VSTSAccount>"
VSTS_TOKEN            = "<PATTOKEN>"
ADMIN_USERNAME        = "agentagents"
ADMIN_SSHKEYPATH      = "/home/agentagents/.ssh/authorized_keys"
SERVERNAMES           = ["VM01", "VM02", "VM03", "VM04", "VM05", "VM06"]
```
