# Terraform Beginner Bootcamp 2023 - Week 0 

- [Semantic Versioning](#semantic-versioning)
- [Install the Terraform CLI](#install-the-terraform-cli)
  * [Considerations with the Terraform CLI changes](#considerations-with-the-terraform-cli-changes)
  * [Considerations for Linux Distribution](#considerations-for-linux-distribution)
  * [Refactoring into Bash Scripts](#refactoring-into-bash-scripts)
    + [Shebang Considerations](#shebang-considerations)
    + [Execution Considerations](#execution-considerations)
    + [Linux Permissions Considerations](#linux-permissions-considerations)
- [Gitpod Lifecycle](#gitpod-lifecycle)
- [Working Env Vars](#working-env-vars)
  * [env command](#env-command)
  * [Setting and Unsetting Env Vars](#setting-and-unsetting-env-vars)
  * [Printing Vars](#printing-vars)
  * [Scoping of Env Vars](#scoping-of-env-vars)
  * [Persisting Env Vars in Gitpod](#persisting-env-vars-in-gitpod)
- [AWS CLI Installation](#aws-cli-installation)
- [Terraform Basics](#terraform-basics)
  * [Terraform Registry](#terraform-registry)
  * [Terraform Console](#terraform-console)
    + [Terraform Init](#terraform-init)
    + [Terraform Plan](#terraform-plan)
    + [Terraform Apply](#terraform-apply)
    + [Terraform Destroy](#terraform-destroy)
    + [Terraform Lock Files](#terraform-lock-files)
    + [Terraform State Files](#terraform-state-files)
    + [Terraform Directory](#terraform-directory)
- [Issues with Terraform Cloud Login and Gitpod Workspace](#issues-with-terraform-cloud-login-and-gitpod-workspace)

## Semantic Versioning

Semantic versioning (SemVer) is a system for versioning software that uses three parts: major, minor, and patch versions to indicate compatibility and changes. It helps developers and users understand the impact of updates.

Given a version number MAJOR.MINOR.PATCH, increment the:

    MAJOR version when you make incompatible API changes
    MINOR version when you add functionality in a backward compatible manner
    PATCH version when you make backward compatible bug fixes

Example: 1.0.0 < 2.0.0 < 2.1.0 < 2.1.1.

Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.

This project is going utilize semantic versioning for its tagging - More info on:
[semver.org](https://semver.org/)

## Install the Terraform CLI

### Considerations with the Terraform CLI changes

The Terraform CLI installation instructions have changed due to gpg keyring changes. So we needed refer to the latest install CLI instructions via Terraform Documentation and change the scripting for install.

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Considerations for Linux Distribution

This project is built against Ubuntu. To check the Linux Distribution you are working one, you can use the instructions from the below article:

[How To Check OS Version in Linux](
https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

***Sample output:***

```sh
$ cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

## Refactoring into Bash Scripts

While addressing the Terraform CLI GPG deprecation issues, we noticed that the Bash script steps involved a considerably larger amount of code. Therefore, we decided to create a Bash script for the Terraform CLI installation.

This Bash script can be found here: [./bin/install_terraform_cli.sh](./bin/install_terraform_cli.sh)

Benefits of this approach include:

- Keeping the Gitpod Task File ([.gitpod.yml](.gitpod.yml)) tidy.
- Facilitating easier debugging and manual execution of the Terraform CLI installation.
- Ensuring better portability for other projects requiring Terraform CLI installation.

### Shebang Considerations

A shebang, also known as a "hashbang" or "pound-bang," is a special character sequence at the beginning of a script file in Unix-like operating systems. It consists of the characters #! followed by the path to the interpreter that should be used to execute the script. For example:

```
#!/usr/bin/env bash
```
ChatGPT recommends the above format for a Bash shebang because:

- It enhances portability across different OS distributions.
- It searches the user's PATH for the Bash executable.

More info on - [Shebang - Linux Bash Shell Scripting Tutorial Wiki](https://bash.cyberciti.biz/guide/Shebang)

### Execution Considerations

When running a Bash script, you can utilize the `./` shorthand notation to execute it directly. For example:

```bash
./bin/install_terraform_cli.sh
```

However, if you're using a script within a `.gitpod.yml` configuration, you should specify a program to interpret and execute the script using the `source` command. Here's an example:

```bash
source ./bin/install_terraform_cli
```

This ensures that the script is executed within the context of your environment and its changes persist after execution.

### Linux Permissions Considerations

To make our Bash script executable, we need to change the file permissions to grant execute access in the user mode.

```sh
chmod u+x ./bin/install_terraform_cli.sh
```

Alternatively:

```sh
chmod 744 ./bin/install_terraform_cli.sh
```

## Gitpod Lifecycle

In Gitpod, these task types serve distinct purposes:

- **"Before" tasks** are designed for preliminary environment configuration, ensuring your workspace is ready.
  
  Example for "before" tasks:
  
  ```yaml
  tasks:
    - name: Before Setup
      command: |
        echo "Performing pre-environment setup..."
        # Add pre-environment setup commands here
  ```

- **"Init" tasks** are meant for customizing your workspace for the specific project. However, keep in mind that they won't rerun if you restart an existing workspace.

  Example for "init" tasks:

  ```yaml
  tasks:
    - name: Initialize Project
      init: true
      command: |
        echo "Customizing the workspace for the project..."
        # Add project-specific setup commands here
  ```

This distinction allows you to prepare your environment and tailor it to your project's requirements efficiently.

[Gitpod Documentation - Tasks](https://www.gitpod.io/docs/configure/workspaces/tasks)

## Working Env Vars

### env command

The env command allows you to view all the environment variables currently defined in your session. It's a useful tool for checking the environment configuration.

### Setting and Unsetting Env Vars

You can set environment variables using the ```export``` command:

```sh
export VAR_NAME=value
``` 

This sets a variable with a specific value. To unset or remove an environment variable, you can use the ```unset``` command:

```sh
unset VAR_NAME
```

### Printing Env Vars

To see the value of a specific environment variable, use the ```echo``` command followed by the variable's name:

```sh
echo $VAR_NAME
```

 This prints the value of the variable to the terminal.

### Scoping of Env Vars

Environment variables can have local or global scopes within a session. Local variables are limited to the current session or script, while global variables are accessible by other processes and sessions.

When you open up new bash terminals in VSCode it will not be aware of env vars that you have set in another window.

If you want to Env Vars to persist across all future bash terminals that are open you need to set env vars in your bash profile. eg. `.bash_profile`

### Persisting Env Vars in Gitpod

We can persist env vars into gitpod by storing them in Gitpod Secrets Storage.

```sh
gp env HELLO='world'
```
We'll use the below env var for this project:

```sh
gp env PROJECT_ROOT='/workspace/terraform-beginner-bootcamp-2023'
```

Expected output:

```sh
gitpod /workspace/terraform-beginner-bootcamp-2023 (6-project-root-env-var) $ gp env PROJECT_ROOT='/workspace/terraform-beginner-bootcamp-2023'
PROJECT_ROOT=/workspace/terraform-beginner-bootcamp-2023
gitpod /workspace/terraform-beginner-bootcamp-2023 (6-project-root-env-var) $ echo $PROJECT_ROOT
/workspace/terraform-beginner-bootcamp-2023
```

All future workspaces launched will set the env vars for all bash terminals opened in thoes workspaces.

You can also set en vars in the ```.gitpod.yml``` but this can only contain non-senstive env vars.

## AWS CLI Installation

The AWS Command Line Interface (CLI) allows you to interact with Amazon Web Services (AWS) services from the command line. 

In order to install, we can follow the below official documentation:

[Install or update the latest version of the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

We can check if our AWS credentials are configured correctly by running the following command:

```sh
aws sts get-caller-identity
```
[Environment variables to configure the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

## Terraform Basics

### Terraform Registry

The Terraform Registry is an interactive resource for discovering a wide selection of integrations (providers), configuration packages (modules), and security rules (policies) for use with Terraform. The Registry includes solutions developed by HashiCorp, third-party vendors, and our Terraform community.

[https://developer.hashicorp.com/terraform/registry](https://developer.hashicorp.com/terraform/registry)

### Terraform Console

The command line interface to Terraform is the terraform command, which accepts a variety of subcommands such as `terraform init` or `terraform plan`

[https://developer.hashicorp.com/terraform/cli/commands](https://developer.hashicorp.com/terraform/cli/commands)

#### Terraform Init

The `terraform init` command initializes a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times.

[https://developer.hashicorp.com/terraform/cli/commands/init](https://developer.hashicorp.com/terraform/cli/commands/init)

#### Terraform Plan

The `terraform plan` command creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure. By default, when Terraform creates a plan it:

- Reads the current state of any already-existing remote objects to make sure that the Terraform state is up-to-date.
- Compares the current configuration to the prior state and noting any differences.
- Proposes a set of change actions that should, if applied, make the remote objects match the configuration.

[https://developer.hashicorp.com/terraform/cli/commands/plan](https://developer.hashicorp.com/terraform/cli/commands/plan)

#### Terraform Apply

The `terraform apply` command executes the actions proposed in a Terraform plan.

[https://developer.hashicorp.com/terraform/cli/commands/apply](https://developer.hashicorp.com/terraform/cli/commands/apply)

#### Terraform Destroy

The `terraform destroy` command is a convenient way to destroy all remote objects managed by a particular Terraform configuration.

[https://developer.hashicorp.com/terraform/cli/commands/destroy](https://developer.hashicorp.com/terraform/cli/commands/destroy)

#### Terraform Lock Files

Terraform generates lock files to prevent concurrent modifications to state files by multiple users. These lock files ensure that only one user can apply changes to the infrastructure at a time, preventing conflicts and inconsistencies.

[https://developer.hashicorp.com/terraform/language/files/dependency-lock](https://developer.hashicorp.com/terraform/language/files/dependency-lock)

#### Terraform State 

Terraform must store state about your managed infrastructure and configuration. This state is used by Terraform to map real world resources to your configuration, keep track of metadata, and to improve performance for large infrastructures.

This state is stored by default in a local file named "terraform.tfstate", but we recommend storing it in Terraform Cloud to version, encrypt, and securely share it with your team.

[https://developer.hashicorp.com/terraform/language/state](https://developer.hashicorp.com/terraform/language/state)

#### Terraform Directory

A Terraform working directory typically contains:

- A Terraform configuration describing resources Terraform should manage. This configuration is expected to change over time.
- A hidden `.terraform` directory, which Terraform uses to manage cached provider plugins and modules, record which workspace is currently active, and record the last known backend configuration in case it needs to migrate state on the next run. This directory is automatically managed by Terraform, and is created during initialization.
- State data, if the configuration uses the default `local` backend. This is managed by Terraform in a `terraform.tfstate` file (if the directory only uses the default workspace) or a `terraform.tfstate.d` directory (if the directory uses multiple workspaces).

[https://developer.hashicorp.com/terraform/cli/init](https://developer.hashicorp.com/terraform/cli/init)

## Issues with Terraform Cloud Login and Gitpod Workspace