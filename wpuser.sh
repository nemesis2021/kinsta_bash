#!/bin/bash

# Set variables for the user
USERNAME="kinsta_support2"
EMAIL="info2@kinsta.com"
PASSWORD="Password1"
ROLE="administrator"
EXPIRATION="+30 minutes"  # Change from +24 hours to +30 minutes

# Create the user using WP-CLI
echo "Creating the user $USERNAME..."
USER_ID=$(wp user create $USERNAME $EMAIL --role=$ROLE --user_pass=$PASSWORD --porcelain)

# Check if the user creation was successful
if [ -n "$USER_ID" ]; then
    echo "User $USERNAME created with ID $USER_ID."
    
    # Schedule the cron event to expire the user after 30 minutes
    echo "Scheduling expiration for the user $USERNAME in 30 minutes..."
    wp cron event schedule user_expire_event "$EXPIRATION" --user_id=$USER_ID
    
    # Check if the cron event was scheduled
    if [ $? -eq 0 ]; then
        echo "Cron event scheduled successfully. User $USERNAME will expire in 30 minutes."
    else
        echo "Failed to schedule cron event for user expiration."
        exit 1
    fi
else
    echo "Error: User creation failed."
    exit 1
fi
