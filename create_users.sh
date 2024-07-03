#!/bin/bash

# Author: Emmanuel Omoiya<emmanuelomoiya6@gmail.com>

# Script name: create_users.sh

# Description: Create users and groups as specified in the input text file from the command line arguments

# Usage: create_users.sh <input_file>

# Log file and password storage file
LOG_FILE="/var/log/user_management.log"
PASSWORD_FILE="/var/secure/user_passwords.txt"

# Ensure the directory exists and has the appropriate permissions
if [ ! -d "/var/secure" ]; then
    mkdir -p /var/secure
    chmod 700 /var/secure
fi

# Ensuring the log file and password file exist and are writable
touch $LOG_FILE $PASSWORD_FILE
chmod 600 $PASSWORD_FILE
chmod 644 $LOG_FILE

# Function to log user actions
log(){
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    log "Script must be run as root."
    echo "Please run as root."
    exit 1
fi

# Check if the input file is provided and readable
if [ ! -f "$1" ]; then
    log "Input file not provided or does not exist."
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Function to generate a random password
generate_password(){
    < /dev/urandom tr -dc 'A-Za-z0-9!@#$%^&*()_+' | head -c 8
}

# Read the input file line by line
while IFS=';' read -r user groups;
do
    user=$(echo "$user" | xargs) # Trim whitespace
    groups=$(echo "$groups" | xargs) # Trim whitespace

    if id "$user" &>/dev/null; then
        log "User $user already exists."
        echo "User $user already exists. Skipping."
        continue
    fi

    # Create groups if they do not exist and collect them in a list
    IFS=',' read -ra group_list <<< "$groups"
    group_string=""
    for group in "${group_list[@]}"; do
        group=$(echo "$group" | xargs)  # Trim whitespace
        if ! getent group "$group" &>/dev/null; then
            groupadd "$group"
            log "Group $group created."
        else
            log "Group $group already exists."
        fi
        group_string+="$group,"
    done
    group_string=${group_string%,} # Remove trailing comma

    # Create user and assign to groups
    useradd -m -G "$group_string" "$user"
    if [ $? -eq 0 ]; then
        log "User $user created and added to groups $groups"
    else
        log "Failed to create user $user."
        echo "Failed to create user $user. Check log for details."
        continue
    fi

    # Generate and assign a password
    password=$(generate_password)
    echo "$user:$password" | chpasswd
    if [ $? -eq 0 ]; then
        log "Password set for user $user."
    else
        log "Failed to set password for user $user."
        echo "Failed to set password for user $user. Check logs for details."
        continue
    fi

    # Store the password securely
    echo "$user:$password" >> $PASSWORD_FILE
    log "Password for user $user stored securely."

    # Set ownership and permissions for home directory
    chown "$user:$user" "/home/$user"
    chmod 700 "/home/$user"
    log "Home directory for user $user set up with appropriate permissions."
done < "$1"

log "Users - groups creation process completed."
echo "User creation process completed. Check $LOG_FILE for details."