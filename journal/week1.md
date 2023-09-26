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

