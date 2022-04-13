# Terraform examples on Microsoft Azure

Terraform is an open-source infrastructure as code software tool that provides a consistent CLI workflow to manage hundreds of cloud services. Terraform codifies cloud APIs into declarative configuration files.

Terraform is used to create, manage, and update infrastructure resources such as VMs, storage, containers, and more. Almost any infrastructure type can be represented as a resource in Terraform.

This repo contains [Terraform](https://www.terraform.io/) code examples on Microsoft Azure.

The Github repository
[https://github.com/alfonsof/terraform-examples-aws](https://github.com/alfonsof/terraform-examples-aws)
contains the code samples based in the book *[Terraform: Up and Running](http://www.terraformupandrunning.com)* by [Yevgeniy Brikman](http://www.ybrikman.com). But those examples use AWS (Amazon Web Services).

Terraform also supports other Cloud providers and this Github repository contains the code samples of the book on Microsoft Azure.

## Quick start

You must have a [Microsoft Azure](https://azure.microsoft.com/) subscription.

The code consists of Terraform examples using HashiCorp Configuration Language (HCL) on Microsoft Azure.

All the code is in the [code](/code) folder.

For instructions on running the code, please consult the README in each folder.

This is the list of examples:

* [01-hello-world](code/01-hello-world) - Terraform "Hello, World": Example of how to deploy a single server on Microsoft Azure using the shortest script.
* [02-one-server](code/02-one-server) - Terraform One Server: Example of how deploy a single server on Microsoft Azure.
* [03-one-webserver](code/03-one-webserver) - Terraform Web Server: Example of how deploy a single web server on Microsoft Azure. The web server returns "Hello, World" for the URL `/` listening on port 8080.
* [04-one-webserver-with-vars](code/04-one-webserver-with-vars) - Terraform Web Server with vars: Example of how deploy a single web server on Microsoft Azure. The web server returns "Hello, World" for the URL `/` listening on port 8080, which is defined as a variable.
* [05-cluster-webserver](code/05-cluster-webserver) - Terraform Cluster Web Server: Example of how deploy a cluster of web servers on Microsoft Azure using Azure Virtual Machine Scale Set, as well as a load balancer using Azure Load Balancer. The cluster of web servers returns "Hello, World" for the URL `/`. The load balancer listens on port 80.
* [06-create-blob-storage](code/06-create-blob-storage) - Terraform Create Blob Storage: Example of how deploy the creation of a Blob Storage container on Microsoft Azure.
* [07-terraform-state](code/07-terraform-state) - Terraform State: Example of how to store the information about what infrastructure has been created on Microsoft Azure.

## License

This code is released under the MIT License. See LICENSE file.
