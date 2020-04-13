#!/bin/bash

# This script creates an account on the local system.
# You will be prompted for the account name and password

# ask for the user name
read -p 'Enter the username to craete: ' USER_NAME

# ask for the real name
read -p 'Enter the name of the person who this account is for: ' COMMENT

# ask for the password
read -p 'Enter the password to user for the new account: ' PASSWORD

# create the user
useradd -c "${COMMENT}" -m ${USER_NAME}

# set the password for the user
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# force password change on first login
passwd -e ${USER_NAME}
