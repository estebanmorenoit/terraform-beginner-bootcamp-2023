# Terraform Beginner Bootcamp 2023 - Week 1

- [Terraform Beginner Bootcamp 2023 - Week 1](#terraform-beginner-bootcamp-2023---week-1)
  - [Root Module Structure](#root-module-structure)
  - [Terraform and Input Variables](#terraform-and-input-variables)
    - [Terraform Cloud Variables](#terraform-cloud-variables)
    - [var-file flag](#var-file-flag)
    - [terraform.tfvars](#terraformtfvars)
    - [auto.tfvars](#autotfvars)
    - [Order of terraform variables](#order-of-terraform-variables)
  - [Dealing With Configuration Drift](#dealing-with-configuration-drift)
  - [What happens if we lose our state file?](#what-happens-if-we-lose-our-state-file)
    - [Fix Missing Resources with Terraform Import](#fix-missing-resources-with-terraform-import)
    - [Fix Manual Configuration](#fix-manual-configuration)
  - [Fix using Terraform Refresh](#fix-using-terraform-refresh)
    - [Fix using Terraform Refresh](#fix-using-terraform-refresh-1)
  - [Terraform Modules](#terraform-modules)
    - [Terraform Module Structure](#terraform-module-structure)
    - [Passing Input Variables](#passing-input-variables)
    - [Module Sources](#module-sources)
  - [Working with Files in Terraform](#working-with-files-in-terraform)
    - [Fileexists function](#fileexists-function)
    - [Filemd5](#filemd5)
    - [Path Variable](#path-variable)
  - [Terraform Locals](#terraform-locals)
  - [Terraform Data Sources](#terraform-data-sources)
  - [Working with JSON](#working-with-json)

## Root Module Structure

Our root module structure is as follows:
```
PROJECT_ROOT
│
├── main.tf                 # everything else.
├── variables.tf            # stores the structure of input variables
├── terraform.tfvars        # the data of variables we want to load into our terraform project
├── providers.tf            # defined required providers and their configuration
├── outputs.tf              # stores our outputs
└── README.md               # required for root modules
```

[Terraform Documentation - Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables

Input variables let you customize aspects of Terraform modules without altering the module's own source code. This functionality allows you to share modules across different Terraform configurations, making your module composable and reusable.

When you declare variables in the root module of your configuration, you can set their values using CLI options and environment variables. 

[https://developer.hashicorp.com/terraform/language/values/variables](https://developer.hashicorp.com/terraform/language/values/variables)

### Terraform Cloud Variables

You can set variables specifically for each workspace or you can create variable sets to reuse the same variables across multiple workspaces.

There are 2 types:

- **Environment Variables:** These variables are workspace-specific and are used for storing sensitive information like API keys, credentials, or configuration parameters. They are isolated within a single workspace.

- **Terraform Variables:** Terraform Variables are sets of reusable variables that can be defined and managed across multiple workspaces. They promote consistency and reusability in your configurations, allowing you to define and use variables consistently.

[https://developer.hashicorp.com/terraform/cloud-docs/workspaces/variables](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/variables)

### var flag

To specify individual variables on the command line, use the -var option when running the terraform plan and terraform apply commands:

[https://developer.hashicorp.com/terraform/language/values/variables](https://developer.hashicorp.com/terraform/language/values/variables)

### var-file flag

To set lots of variables, it is more convenient to specify their values in a variable definitions file (with a filename ending in either .tfvars or .tfvars.json) and then specify that file on the command line with -var-file:

```sh
terraform apply -var-file="testing.tfvars"
```

[https://developer.hashicorp.com/terraform/language/values/variables](https://developer.hashicorp.com/terraform/language/values/variables)

### terraform.tfvars

Terraform allows you to define variable files called *.tfvars to create a reusable file for all the variables for a project.

[https://registry.terraform.io/providers/terraform-redhat/rhcs/latest/docs/guides/terraform-vars](https://registry.terraform.io/providers/terraform-redhat/rhcs/latest/docs/guides/terraform-vars)

### auto.tfvars

`auto.tfvars` is a special filename that Terraform recognizes and automatically loads when you run terraform apply or terraform plan. It is used to set values for input variables in your Terraform configuration without requiring you to explicitly specify them on the command line or create separate variable files.

[https://developer.hashicorp.com/terraform/language/values/variables](https://developer.hashicorp.com/terraform/language/values/variables)

### Order of terraform variables

Terraform loads variables in the following order, with later sources taking precedence over earlier ones:

- Environment variables
- The terraform.tfvars file, if present.
- The terraform.tfvars.json file, if present.
- Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
- Any -var and -var-file options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.)

[https://developer.hashicorp.com/terraform/language/values/variables](https://developer.hashicorp.com/terraform/language/values/variables)

## Dealing With Configuration Drift

Configuration drift occurs when your infrastructure's actual state differs from your desired state defined in Terraform.

## What happens if we lose our state file?

Losing your state file often requires manual teardown of your cloud infrastructure. 

While Terraform provides `terraform import` for resource management, not all cloud resources support it. To identify supported resources, consult the Terraform providers' documentation.

[https://developer.hashicorp.com/terraform/cli/import](https://developer.hashicorp.com/terraform/cli/import)
### Fix Missing Resources with Terraform Import

To manage existing resources not originally under Terraform control, use the `terraform import` command. It integrates them into Terraform, allowing you to track and manage them alongside your configuration.

[https://developer.hashicorp.com/terraform/cli/import](https://developer.hashicorp.com/terraform/cli/import)

### Fix Manual Configuration

If you manually modify Terraform-managed resources, adjust your configuration to match the changes, use `terraform plan` to identify updates, and apply the changes with `terraform apply`. 

## Fix using Terraform Refresh

The `terraform refresh` command reads the current settings from all managed remote objects and updates the Terraform state to match.

```sh
terraform apply -refresh-only -auto-approve
```

### Fix using Terraform Refresh

Use the `terraform apply -refresh-only -auto-approve` command to refresh the state of your Terraform-managed resources without making any changes. This can help identify configuration drift and update the state file with the latest information from the real resources.

[https://developer.hashicorp.com/terraform/cli/commands/refresh](https://developer.hashicorp.com/terraform/cli/commands/refresh)

## Terraform Modules

Modules are containers for multiple resources that are used together. A module consists of a collection of `.tf` and/or `.tf.json` files kept together in a directory.

Modules are the main way to package and reuse resource configurations with Terraform.

[https://developer.hashicorp.com/terraform/language/modules](https://developer.hashicorp.com/terraform/language/modules)

### Terraform Module Structure

A complete example of a module following the standard structure is shown below. This example includes all optional elements and is therefore the most complex a module can become:

```
$ tree complete-module/
.
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── ...
├── modules/
│   ├── nestedA/
│   │   ├── README.md
│   │   ├── variables.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   ├── nestedB/
│   ├── .../
├── examples/
│   ├── exampleA/
│   │   ├── main.tf
│   ├── exampleB/
│   ├── .../
```

[https://developer.hashicorp.com/terraform/language/modules/develop/structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

### Passing Input Variables

When using Terraform modules, you can pass input variables to customize their behavior. Define variables in the calling module and pass them to the module using the `variables block` in your module configuration.

[https://developer.hashicorp.com/terraform/language/values/variables](https://developer.hashicorp.com/terraform/language/values/variables)

### Module Sources

Using the source we can import the module from various places eg:

- locally
- Github
- Terraform Registry

```json
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws" 
}
```

[https://developer.hashicorp.com/terraform/language/modules/sources](https://developer.hashicorp.com/terraform/language/modules/sources)

## Working with Files in Terraform

### Fileexists function

The `fileexists` function in Terraform is used to check if a file exists at the specified path. It returns `true` if the file exists and `false` if it does not. This function is often used in variable validation to ensure that a file specified by a user or in configuration actually exists before proceeding with Terraform operations.

Example of using fileexists in variable validation:

```json
variable "example_file" {
  description = "Path to an example file"
  type        = string

  validation {
    condition     = fileexists(var.example_file)
    error_message = "The specified file does not exist."
  }
}
```

[https://developer.hashicorp.com/terraform/language/functions/fileexists](https://developer.hashicorp.com/terraform/language/functions/fileexists)

### Filemd5

The `filemd5` function in Terraform is used to calculate the MD5 hash of the content of a file at the specified path. It is often used to track changes in file content and can be useful for comparing file content in configuration to an existing file.

Example of using `filemd5` to calculate the MD5 hash of a file:

```json
# Calculate the MD5 hash of a file and assign it to a variable
variable "file_md5" {
  type = string
  default = filemd5("path/to/file")
}
```

[https://developer.hashicorp.com/terraform/language/functions/filemd5](https://developer.hashicorp.com/terraform/language/functions/filemd5)

### Path Variable

The `path` variable in Terraform represents the current working directory of the Terraform configuration being applied. It provides a way to reference files and directories relative to the location of the configuration files. This can be useful for specifying file paths or including files located in the same directory as the Terraform configuration.

Example of using the `path` variable to reference a file relative to the configuration directory:

```json
# Reference a file relative to the configuration directory
variable "example_file" {
  type = string
  default = "${path.module}/relative/path/to/file"
}
```

[https://developer.hashicorp.com/terraform/language/expressions/references#path-module](https://developer.hashicorp.com/terraform/language/expressions/references#path-module)

## Terraform Locals

A local value assigns a name to an expression, so you can use the name multiple times within a module instead of repeating the expression.

```json
locals {
    s3_origin_id = "MyS3Origin"
}
```

[https://developer.hashicorp.com/terraform/language/values/locals](https://developer.hashicorp.com/terraform/language/values/locals)

## Terraform Data Sources

Data sources allow Terraform to use information defined outside of Terraform, defined by another separate Terraform configuration, or modified by functions.

```json
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```
[https://developer.hashicorp.com/terraform/language/data-sources](https://developer.hashicorp.com/terraform/language/data-sources)

## Working with JSON

The `jsonencode` function in Terraform converts values into JSON format. It's useful for generating JSON data to interact with external systems like APIs. Use it by passing your data as an argument to the function, and it returns a JSON-encoded string. Terraform also provides a `jsonencode` function for decoding JSON data. Make sure to check the documentation for your Terraform version.

```json
> jsonencode({"hello"="world"})
{"hello":"world"}
```

[https://developer.hashicorp.com/terraform/language/functions/jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)