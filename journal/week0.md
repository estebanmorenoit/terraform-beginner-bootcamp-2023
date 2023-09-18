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
### Setting and Unsetting Env Vars
### Printing Vars
### Scoping of Env Vars
### Persisting Env Vars in Gitpod
## AWS CLI Installation
## Terraform Basics
### Terraform Registry
### Terraform Console
#### Terraform Init
#### Terraform Plan
#### Terraform Apply
#### Terraform Destroy
#### Terraform Lock Files
#### Terraform State Files
#### Terraform Directory
## Issues with Terraform Cloud Login and Gitpod Workspace