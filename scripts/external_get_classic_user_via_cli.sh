#!/bin/bash

# Log in to IBM CLI. Stored as data to prevent return to terraform
LOG_IN=$(ibmcloud login --apikey $1 -r $2)
# Get List of Classic Users from CLI
JSON_DATA=$(ibmcloud sl user list --column username --column email --column id --output json)
# Get count of total users
COUNT=$(echo $JSON_DATA | jq ". | length")
# Get length of array
LENGTH=$(($COUNT - 1))
# All arguments after $1 are passed in to the script
CLASSIC_USER_IDS=$@
# JSON string that will be returned to the external terraform object
TF_JSON="["

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
            # Get full name, currently this only works with users who have only a first and last name
            FULL_NAME=$(
                echo $(
                    ibmcloud sl user detail $ID | grep Name | sed -r 's/Name//g'
                )
            )
            # Number of names
            NAME_COUNT=0
            # For each name, set the first name to the name at index 0, otherwise set to lastname
            for name in $FULL_NAME
            do
                if [ $NAME_COUNT == 0 ]; then
                    first_name=$name
                else
                    last_name=$name
                fi
                NAME_COUNT=$(($NAME_COUNT + 1))
            done
            # Add user data to string
            TF_JSON+='{
            "id" : "'$ID'",
            "first_name" : "'$first_name'",
            "last_name" : "'$last_name'",
            "email" : "'$EMAIL'",
            "has_api_key": null
            },'
        fi
    done
    
done


# Use case for empty variable
if [ "$TF_JSON" == "[" ]; then
    TF_JSON="[]"
fi

# Return as data, removing the last trailing comma and adding a close array bracker
jq -n --arg data "${TF_JSON%?}]" '{"data":$data}'