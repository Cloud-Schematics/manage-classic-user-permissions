# Manage Classic User Permissions

This module provides a template to manage Classic Infrastructure permissions by using the IBM Cloud CLI and Terraform.   


## Using the CLI Locally

### Importing the Users

Using the [terraform import bash script](./scripts/terraform_import_classic_user.sh) users can be imported using the IBM Cloud CLI.

The first parameter for this script is your IBM Cloud API key, each additional parameter is the classic user ID of a user to be imported into the template. To look up IDs for users you can use this command:

```bash
ibmcloud sl user list --column username --column email --column id 
```

Example script use:

```bash
./scripts/terraform_import_classic_user.sh <your ibmcloud api key> classic-id-1 classic-id-2 ...
```

### Updating Variables

Once the script has been run to import classic users, ensure that any user imported into the template are added to the `classic_users_from_data` variable in [variables.tf](./variables.tf). Use the `terraform plan` command to make sure all users are correctly added.


### Applying the Plan

When applying the plan, all users will be updated to have the same info found in the `company_data` variable and the same permissions as in the `permissions`

## Module VariablesName                    | Type                                                                                                                                            | Description                                                | Sensitive | Default
----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- | --------- | ----------------------------------------------------------------------------------------------------------------------------------------------------
ibmcloud_api_key        | string                                                                                                                                          | The IBM Cloud platform API key needed to deploy IAM enabled resources         | true      | 
iaas_classic_username   | string                                                                                                                                          | Classic username key used to initialize the provider                          | true      | 
iaas_classic_api_key    | string                                                                                                                                          | Classic API key used to initialize the provider                               | true      | 
TF_VERSION              |                                                                                                                                                 | The version of the Terraform engine that's used in the Schematics workspace.  |           | 1.0
region                  | string                                                                                                                                          | Region where VPC will be created                                              |           | us-south
company_data            | object({ company_name = string address1 = string address2 = optional(string) city = string state = string timezone = string country = string }) | Data for describing users. Comany data will be applied to all users.          |           | { company_name = "example company" address1 = "12345 Any Street" address2 = "Suite city = "Atlanta" state = "GA" timezone = "CEST" country = "USA" }
classic_users_from_data | list(string)                                                                                                                                  | A list of IDs for user imported manually. Users must be imported before runtime |           | [ "1111111", "2222222", "3333333" ]
classic_users           | list( object({ email = string first_name = string last_name = string has_api_key = optional(bool) }) )                                          | A list describing users                                                       |           | [ { first_name = "John" last_name = "Test" email = "john@test.example" has_api_key = true } ]
permissions             | list(string)                                                                                                                                    | List of permissions for all users                                             |           | [ "ACCESS_ALL_DEDICATEDHOSTS", "ACCESS_ALL_GUEST", "ACCESS_ALL_HARDWARE", "TEST" ]
