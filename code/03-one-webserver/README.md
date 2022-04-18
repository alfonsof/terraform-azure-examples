# Terraform Web Server example

This folder contains a one server example of a [Terraform](https://www.terraform.io/) file on Microsoft Azure.

This Terraform file create a single web server on Microsoft Azure by provisioning the necessary infrastructure, and using an Azure Virtual Machine. The web server returns "Hello, World" for the URL `/` listening on port 8080.

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

* Initialize Terraform configuration.

  The first command that should be run after writing a new Terraform configuration is the `terraform init` command in order to initialize a working directory containing Terraform configuration files. It is safe to run this command multiple times.

  If you ever set or change modules or backend configuration for Terraform, rerun this command to reinitialize your working directory. If you forget, other commands will detect it and remind you to do so if necessary.

  Run command:

  ```bash
  terraform init
  ```

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

* Test the web server.

  When the `terraform apply` command completes, it will output the public IP address of the web server.

  You can test it in two ways, but be sure to replace the value of `<SERVER_PUBLIC_IP>` by the public IP address that you have got in the previous command:
  
  * Running this command:

    ```bash
    curl http://<SERVER_PUBLIC_IP>:8080/
    ```

  * Writing in your browser this URL: `http://<SERVER_PUBLIC_IP>:8080/`

  You should get a `Hello, World` response message.

* Clean up the resources created.

  When you have finished, the `terraform destroy` command destroys the infrastructure you created.
  
  Run command:

  ```bash
  terraform destroy
  ```
