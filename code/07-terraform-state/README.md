# Terraform State example

This folder contains a state example of a [Terraform](https://www.terraform.io/) file on Microsoft Azure.

This Terraform file use the Azure Blob Storage container created in the previous example [06-create-blob-storage](../06-create-blob-storage/) to store the information about what infrastructure has been created.

This information is stored in the Terraform state file `terraform.tfstate`. This file contains a JSON format that records a mapping from the representation of the resources on Microsoft Azure to Terrafom resources in the configuration files.

Backends are responsible for storing state and providing an API for state locking. State locking is optional.

Backends determine where state is stored. For example, the local (default) backend stores state in a local JSON file on disk. The Azurerm backend stores the state within a blob storage account.

## Requirements

* You must have a [Microsoft Azure](https://azure.microsoft.com/) subscription.

* You must have the following installed:
  * [Terraform](https://www.terraform.io/) CLI
  * Azure CLI tool

* The code was written for:
  * Terraform 0.14 or later

* It uses the Terraform AzureRM Provider v 3.1 that interacts with the many resources supported by Azure Resource Manager (AzureRM) through its APIs.

## Using the code

* Configure your access to Azure.

  * Authenticate using the Azure CLI.

    Terraform must authenticate to Azure to create infrastructure.

    In your terminal, use the Azure CLI tool to setup your account permissions locally.

    ```bash
    az login  
    ```

    Your browser will open and prompt you to enter your Azure login credentials. After successful authentication, your terminal will display your subscription information.

    You have logged in. Now let us find all the subscriptions to which you have access...

    ```bash
    [
      {
        "cloudName": "<CLOUD-NAME>",
        "homeTenantId": "<HOME-TENANT-ID>",
        "id": "<SUBSCRIPTION-ID>",
        "isDefault": true,
        "managedByTenants": [],
        "name": "<SUBSCRIPTION-NAME>",
        "state": "Enabled",
        "tenantId": "<TENANT-ID>",
        "user": {
          "name": "<YOUR-USERNAME@DOMAIN.COM>",
          "type": "user"
        }
      }
    ]
    ```

    Find the `id` column for the subscription account you want to use.

    Once you have chosen the account subscription ID, set the account with the Azure CLI.

    ```bash
    az account set --subscription "<SUBSCRIPTION-ID>"
    ```

  * Create a Service Principal.

    A Service Principal is an application within Azure Active Directory with the authentication tokens Terraform needs to perform actions on your behalf. Update the `<SUBSCRIPTION_ID>` with the subscription ID you specified in the previous step.

    Create a Service Principal:

    ```bash
    az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"

    Creating 'Contributor' role assignment under scope '/subscriptions/<SUBSCRIPTION_ID>'
    The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
    {
      "appId": "xxxxxx-xxx-xxxx-xxxx-xxxxxxxxxx",
      "displayName": "azure-cli-2022-xxxx",
      "password": "xxxxxx~xxxxxx~xxxxx",
      "tenant": "xxxxx-xxxx-xxxxx-xxxx-xxxxx"
    }
    ```

  * Set your environment variables.

    HashiCorp recommends setting these values as environment variables rather than saving them in your Terraform configuration.

    In your terminal, set the following environment variables. Be sure to update the variable values with the values Azure returned in the previous command.

    * For MacOS/Linux:

      ```bash
      export ARM_CLIENT_ID="<SERVICE_PRINCIPAL_APPID>"
      export ARM_CLIENT_SECRET="<SERVICE_PRINCIPAL_PASSWORD>"
      export ARM_SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"
      export ARM_TENANT_ID="<TENANT_ID>"
      ```

    * For Windows (PowerShell):

      ```bash
      $env:ARM_CLIENT_ID="<SERVICE_PRINCIPAL_APPID>"
      $env:ARM_CLIENT_SECRET="<SERVICE_PRINCIPAL_PASSWORD>"
      $env:ARM_SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"
      $env:ARM_TENANT_ID="<TENANT_ID>"
      ```

* Initialize working directory.

  The first command that should be run after writing a new Terraform configuration is the `terraform init` command in order to initialize a working directory containing Terraform configuration files. It is safe to run this command multiple times.

  ```bash
  terraform init
  ```

* Configure Terraform backend.

  You must modify two attributes in `backend.tf` file:

  * Storage Account name, which is defined in the `storage_account_name` attribute.
  * Container Name, which is defined in the `container_name` attribute.

  ```bash
  storage_account_name = "<YOUR_STORAGE_ACCOUNT_NAME>"
  container_name       = "<YOUR_CONTAINER_NAME>"
  ```

  Be sure to replace the value of `<YOUR_STORAGE_ACCOUNT_NAME>` by your storage account name, and the value of `<YOUR_CONTAINER_NAME>` by your container name.

* Validate the changes.

  The `terraform plan` command lets you see what Terraform will do before actually making any changes.

  Run command:

  ```bash
  terraform plan
  ```

* Apply the changes.

  The `terraform apply` command lets you apply your configuration and it creates the infrastructure.

  Run command:

  ```bash
  terraform apply
  ```

* Test the changes.

  When the `terraform apply` command completes, use the Azure console, you should see the `terraform.tfstate` file created in the Blob Storage container in the storage account.

  The `terraform.tfstate` file is where is stored the terraform state.

* Clean up the resources created.

  When you have finished, the `terraform destroy` command destroys the infrastructure you created.
  
  Run command:

  ```bash
  terraform destroy
  ```
