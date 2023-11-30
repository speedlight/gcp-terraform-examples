# Cloud Functions provisioning


---
### Adding a new cloud function:
In order to provision a cloud function the following steps are required:

- In the `functions/` directory copy gcpHTTPFunction.tf.example or gcpEventFunction.tf.example to a .tf file depending of what type of function is needed with the name of the function to be create.
> Example:
  ```sh
  cp gcpEventFunction.tf.example myAwesomeFunction.tf
  ```

- Update all `newFunction` occurrences in the file with the name of the new working function.

- Add a line on `local.tf` similar to the others but with the name of the new function.
> Example:
  ```sh
  myAwesomeFunction_environment_variables = distinct(concat(var.default_environment_variables, var.myAwesomeFunction_env_vars))
  ```

- Add function environment variables and secrets in the `envs/<environment>/<environment>.tfvars` file for each environment as needed.
> Example:
  ```sh
  # development.tfvars
  ...
  myAwesomeFunction_env_vars = [
    { "name": "ENV_VAR", "value": "FOO" },
  ]
  myAwesomeFunction_secrets = [
   {
    key       = "SECRET_ENV"
    secret_id = "secret_id_on_gsm"
    version   = "1"
   },
  ] 
  ```

### Important note for gen2 cloud functions:
On gen2 cloud functions, the run invoker binding needs to be set in order to allow correct authentication.
Run the following gcloud-cli command to set the binding configuration for a deployed gen2 cloud function.
In the case of need to only allow authentication from another cloud function, replace "allUsers" with "serviceAccount:{emailid}" where `emailid` refers to the email of the service account that runs the cloud function (commonly Compute service account)
```sh
gcloud functions add-invoker-policy-binding FUNCTION_NAME \
      --region="us-central1" \
      --member="allUsers"
```

### Terraform environment and common commands

- Terraform installation:
Follow the instruction on [this](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform) link to install it.
___ 
- As the terraform state file is update via GS backend, any update on the state MUST be done using the deployer service account. Contact project owner and DevOps if access to the service account is required.

  To avoid confusion and errors is not recommended to use gcloud-cli iam impersonation especially when working with different gcp projects and different terraform projects. To automatically tell terraform what service account to use (independent of the gcloud-cli account used) the `GOOGLE_APPLICATION_CREDENTIALS` environment variable pointing to the json file could be set.
  > Example:
  ```sh
  export GOOGLE_APPLICATION_CREDENTIALS=deployer-service-account-key.json
  ```
___
- Initializing terraform:

  First:
  ```sh
  terraform init
  ```
- When making changes on terraform code, is a good practice to run the following command before running other commands like `plan` or `apply` to catch possible errors. 
  ```sh
  terraform validate
  ```
- To plan a terraform provisioning, the according .tfvars file needs to be specified and the .out file as well.
  > Example:
  ```sh
   terraform plan -var-file="envs/development/development.tfvars" -out=plan.out
  ```
- Then to apply the plan just
  > Example:
  ```sh
   terraform apply plan.out
  ```