# Terraform GCP Cloud Functions provisioning

An opinionated terraform sample project to provision GCP cloud functions.

This project will deploy three GCP cloud functions named:
- gcpEventFuntion
- gcpHttpFunctionGen1
- gcpHttpFunctionGen2

The sample code used is in the `code` directory.

The following steps are a guide for the case of adding and provision a new cloud function.

---
### Adding a new cloud function:
To provision new cloud function we could follow the following steps:

- Add function's code in a directory under the `code` directory.
- Copy to a new .tf file from one of the samples under the `tf-functions` directory using the desired type of function from the tf files provided.
> For example for an event cloud function:
  ```sh
  cp gcpEventFunction.tf myAwesomeFunction.tf
  ```
- Update all the `gcpEventFunction` occurrences in the file with the name of the function.

- Add an entry on `local.tf` similar to the one provided others but with the name of the new function.
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
In the case of need to only allow authentication from another cloud function, replace `"allUsers"` with `"serviceAccount:{emailid}"` where `emailid` refers to the email of the service account that runs the cloud function.
```sh
gcloud functions add-invoker-policy-binding FUNCTION_NAME \
      --region="us-central1" \
      --member="allUsers"
```


### Terraform environment and common commands

- Terraform installation:
Follow the instruction on [this](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform) link to install it.

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
- To plan a terraform provisioning, the according .tfvars file needs to be specified.
  > Example:
  ```sh
   terraform plan -var-file="envs/development/development.tfvars" -out=plan.out
  ```
- Then to apply the plan just
  > Example:
  ```sh
   terraform apply plan.out
  ```