# Terraform One Server example

This folder contains a one server example of a [Terraform](https://www.terraform.io/) file on Microsoft Azure.

This Terraform file deploys a single server on Microsoft Azure.

## Requirements

* You must have [Terraform](https://www.terraform.io/) installed on your computer.
* You must have a [Microsoft Azure](https://azure.microsoft.com/) subscription.
* It uses the Terraform Azure Provider that interacts with the many resources supported by Azure Resource Manager (AzureRM) through its APIs.
* This code was written for Terraform 0.11.x.

## Using the code

* Configure your access to Azure.

  To enable Terraform to provision resources into Azure, create an Azure AD service principal. The service principal grants your Terraform scripts to provision resources in your Azure subscription.

  You can create it using Azure CLI 2.0 or using the Azure cloud shell.

  * Make sure you select your subscription by:

    ```bash
    az account set --subscription <SUBSCRIPTION_ID>
    ```

    and you have the privileges to create service principals.

  * There are two ways for creating a service principal:

    * First way:

      * Execute the following command for creating a service principal:
  
        ```bash
        az ad sp create-for-rbac --sdk-auth > my.azureauth
        ```

      * This command will create a file `my.azureauth` with this content:

        ```bash
        {
            "clientId": "00000000-0000-0000-0000-000000000000",
            "clientSecret": "00000000-0000-0000-0000-000000000000",
            "subscriptionId": "00000000-0000-0000-0000-000000000000",
            "tenantId": "00000000-0000-0000-0000-000000000000",
            "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
            "resourceManagerEndpointUrl": "https://management.azure.com/",
            "activeDirectoryGraphResourceId": "https://graph.windows.net/",
            "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
            "galleryEndpointUrl": "https://gallery.azure.com/",
            "managementEndpointUrl": "https://management.core.windows.net/"
        }
        ```

    * Second way:

      * Execute the following command for creating a service principal:

        ```bash
        az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
        ```

      * This command will output 5 values:

        ```bash
        {
            "appId": "00000000-0000-0000-0000-000000000000",
            "displayName": "azure-cli-2017-06-05-10-41-15",
            "name": "http://azure-cli-2017-06-05-10-41-15",
            "password": "00000000-0000-0000-0000-000000000000",
            "tenant": "00000000-0000-0000-0000-000000000000"
        }
        ```

  * To configure Terraform to use your Azure AD service principal, set the following environment variables, depending on the previous way for creating the service principal:

    * First way:

      ```bash
      ARM_SUBSCRIPTION_ID = <YOUR_subscriptionId>
      ARM_CLIENT_ID = <YOUR_clientId>
      ARM_CLIENT_SECRET = <YOUR_clientSecret>
      ARM_TENANT_ID = <YOUR_tenantId>
      ```

    * Second way:

      ```bash
      ARM_SUBSCRIPTION_ID = <SUBSCRIPTION_ID>
      ARM_CLIENT_ID = <YOUR_appId>
      ARM_CLIENT_SECRET = <YOUR_password>
      ARM_TENANT_ID = <YOUR_tenant>
      ```

* The first command that should be run after writing a new Terraform configuration is the terraform `init command` in order to initialize a working directory containing Terraform configuration files. It is safe to run this command multiple times.

  ```bash
  terraform init
  ```

* Validate the changes:

  ```bash
  terraform plan
  ```

* Deploy the changes:

  ```bash
  terraform apply
  ```

* Test the deploy:

  When the `terraform apply` command completes, use the Azure console, you should see the new Virtual Machine, and all the resources created with the `Terraform Example` tag.

* Clean up the resources created when you have finished:

  ```bash
  terraform destroy
  ```