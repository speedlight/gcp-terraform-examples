# Terraform GCP API Gateway Provisioning

An opinionated Terraform sample project for provisioning an API Gateway service on GCP.

## Overview

This sample project provides a simple way to provision an API gateway on GCP. The goal is to minimize code while still achieving effective provisioning. Two key details to keep in mind:

1. Initially, run the project with dummy URL values for the spec template to provision the API gateway and obtain the real URLs. Afterward, update these values in the corresponding tfvars file, and rerun the project to update the API Gateway configuration on GCP with the correct URLs.

2. The provisioning process requires two Terraform commands to be executed in order:

    - First, use the `-target` argument as indicated below to generate the spec configuration file from the template.
      ```sh
      terraform plan -var-file=envs/development/development.tfvars -target=local_file.spec
      ```

    - Then, execute the complete project.
      ```sh
      terraform plan --var-file=envs/development/development.tfvars --out=plan.out
      ```

Please note that the gateway configuration provided is just an example and will certainly vary in a real-case scenario.
