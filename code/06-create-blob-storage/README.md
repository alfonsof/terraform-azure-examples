# Terraform Create Blob Storage example

This folder contains the create Blob Storage example of a [Terraform](https://www.terraform.io/) file on Microsoft Azure.

This Terraform file deploys the creation of a Blob Storage container on Microsoft Azure.

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

* Configure your storage account.

  An Azure storage account provides a unique namespace to store and access your Azure Storage data objects.

  An storage account can content containers and every container can content blobs.

  ```bash
  Storage Account -|- Container_1 -|- Blob_1
                   |               |
                   |               |- Blob_2
                   |
                   |- Container_2 -|- Blob_1
                                   |
                                   |- Blob_2
                                   |
                                   |- Blob_3
  ```

  The terraform file creates your storage account.

* Initialize working directory.

  The first command that should be run after writing a new Terraform configuration is the `terraform init` command in order to initialize a working directory containing Terraform configuration files. It is safe to run this command multiple times.

  ```bash
  terraform init
  ```

* Modify configuration.

  You have to modify:

  * Storage Account name, which is defined as an input variable `storage_account_name`.
  * Storage container name , which is defined as an input variable `container_name`.

   both in `vars.tf` file.

  If you want to modify these you will be able to do it in several ways:

  * Loading variables from command line flags.

    Run Terraform commands in this way:

    ```bash
    terraform plan -var 'storage_account_name=tfstorageaccountmyaccount' -var 'container_name=terraform-state-my-container'
    ```

    ```bash
    terraform apply -var 'storage_account_name=tfstorageaccountmyaccount' -var 'container_name=terraform-state-my-container'
    ```

  * Loading variables from a file.

    When Terraform runs it will look for a file called `terraform.tfvars`. You can populate this file with variable values that will be loaded when Terraform runs. An example for the content of the `terraform.tfvars` file:

    ```bash
    storage_account_name = "tfstorageaccountmyaccount"
    container_name = "terraform-state-my-container"
    ```

  * Loading variables from environment variables.

    Terraform will also parse any environment variables that are prefixed with `TF_VAR`. You can create environment variables `TF_VAR_storage_account_name` and `TF_VAR_container_name`:

    ```bash
    TF_VAR_storage_account_name=tfstorageaccountmyaccount
    TF_VAR_container_name=terraform-state-my-container
    ```

  * Variable defaults.

    Change the value of the `default` attribute of `storage_account_name` and `container_name` input variables in `vars.tf` file.

* Validate the changes.

  Run command:

  ```bash
  terraform plan
  ```

* Deploy the changes.

  Run command:

  ```bash
  terraform apply
  ```

* Test the deploy.

  When the `terraform apply` command completes, use the Azure console, you should see:
  
  * The new storage account.

  * The new Blob Storage container created in the Azure storage account.

* Clean up the resources created.

  When you have finished, run command:

  ```bash
  terraform destroy
  ```