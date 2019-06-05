# Azure Pipelines Agents

## via terraform

This project is aimed at quickly getting vms setup and initialised with docker and an azure devops agent.

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
VM01 = "VM01Name"
VSTS_TOKEN = "",
VSTS_POOL = ""
VSTS_ACCOUNT = "account"
ADMIN_USERNAME = "dave"
ADMIN_PASSWORD = "Pass"
ADMIN_SSHKEY = [{ path = "/home/dave/.ssh/authorized_keys"
    key_data = "ssh-rsa xxxasdasdasdasd123123123123"
}]
```
