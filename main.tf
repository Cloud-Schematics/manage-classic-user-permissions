##############################################################################
# IBM Cloud Provider
##############################################################################

provider ibm {
  ibmcloud_api_key      = var.ibmcloud_api_key
  iaas_classic_username = var.iaas_classic_username
  iaas_classic_api_key  = var.iaas_classic_api_key 
  ibmcloud_timeout      = 60
}

##############################################################################


##############################################################################
# Create Classic Access
##############################################################################

data external user_data {
  program = [
    "bash", 
    "${path.module}/scripts/external_get_classic_user_via_cli.sh", 
    var.ibmcloud_api_key,
    var.region,
    "${join(" ", var.classic_users_from_data)}"
  ]
}

locals {
  # Convert list of users into an object. This way, each key for `ibm_compute_user` will be the user's email address
  classic_users_object = {
    for user in concat(
      # Decode JSON data
      jsondecode(data.external.user_data.result.data), 
      var.classic_users
    ):
    (replace(user.email, "@", "-at-")) => user
  }
}



resource ibm_compute_user classic_users {
  for_each     = local.classic_users_object
  address1     = var.company_data.address1
  address2     = var.company_data.address2
  city         = var.company_data.city
  state        = var.company_data.state
  timezone     = var.company_data.timezone
  company_name = var.company_data.company_name
  country      = var.company_data.country
  email        = each.value.email
  first_name   = each.value.first_name
  has_api_key  = each.value.has_api_key
  last_name    = each.value.last_name
  permissions  = var.permissions
}

##############################################################################