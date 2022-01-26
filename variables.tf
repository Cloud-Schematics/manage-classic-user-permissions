##############################################################################
# Account Variables
# Copyright 2020 IBM
##############################################################################

# Comment this variable if running in schematics
variable ibmcloud_api_key {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
  type        = string
  sensitive   = true
}

variable iaas_classic_username {
  description = "Classic username key used to initialize the provider"
  type        = string
  sensitive   = true
}

variable iaas_classic_api_key {
  description = "Classic API key used to initialize the provider"
  type        = string
  sensitive   = true
}

variable region {
  description = "Region where the IBM Provider will be initialized"
  type        = string
}

##############################################################################


##############################################################################
# Assess Variables
##############################################################################

variable company_data {
  description = "Data for describing users. Comany data will be applied to all users."
  type        = object({
      company_name = string
      address1     = string
      address2     = optional(string)
      city         = string
      state        = string
      timezone     = string
      country      = string
  })
  default = {
    company_name = "example company"
    address1     = "12345 Any Street"
    address2     = "Suite #99"
    city         = "Atlanta"
    state        = "GA"
    timezone     = "CEST"
    country      = "USA"
  }
}

variable classic_users_from_data {
  description = "A list of IDs for user imported manually. Users must be imported before this variable should be updated."
  type        = list(string)
  default     = [
    "9083260",
    "9089460",
    "9089462"
  ]
}

variable classic_users {
  description = "A list describing users"
  type        = list(
    object({
      email        = string
      first_name   = string
      last_name    = string
      has_api_key  = optional(bool) #  When the value is true, a SoftLayer API key is created for the user. The key is returned in the api_key attribute. When the value is false, any existing SoftLayer API keys for the user are deleted. The default value is false.
    })
  )
  default   = [
    {
      first_name   = "John"
      last_name    = "Test"
      email        = "john@test.example"
      has_api_key  = true
    }
  ]
}

variable permissions {
  description = "List of permissions for all users"
  type        = list(string)
  default     = [ 
    "ACCESS_ALL_DEDICATEDHOSTS",
    "ACCESS_ALL_GUEST",
    "ACCESS_ALL_HARDWARE",
    "TEST"
  ]
}

##############################################################################