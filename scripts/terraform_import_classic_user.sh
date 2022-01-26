#!/bin/bash

# IBM Cloud API Key
IBMCLOUD_API_KEY=$1
# Login to IBM Cloud CLI
ibmcloud login --apikey $IBMCLOUD_API_KEY
# Get List of Classic Users from CLI
JSON_DATA=$(ibmcloud sl user list --column username --column email --column id --output json)
# Get count of total users
COUNT=$(echo $JSON_DATA | jq ". | length")
# Get length of array
LENGTH=$(($COUNT - 1))
# All arguments after $1 are passed in to the script
CLASSIC_USER_IDS=$@

# For each classic user
for user in $(seq 0 $LENGTH)
do 
    # Get the ID of that user from JSON data
    ID=$(echo $JSON_DATA | jq -r ".[$user].id")
    # For each user ID passed to the script
    for user_id in $CLASSIC_USER_IDS
    do 
        # If the ID matches the JSON data
        if [ "$user_id" == "$ID" ]; then
            # User email address
            EMAIL="$(echo $JSON_DATA | jq -r ".[$user].email")"
            # User terraform address (user-at-domain.com)
            TF_ADDRESS=\"$(echo $JSON_DATA | jq -r ".[$user].email" | sed -r 's/@/-at-/g')\"
            # Import user into Terraform
            terraform import ibm_compute_user.classic_users[$TF_ADDRESS] $ID
        fi
    done
done