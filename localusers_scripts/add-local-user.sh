#!/bin/bash

# This script creates a new user on the local system.
# You will be prompted to enter the username (login), the person name, and a password.
# The username, password, and host for the account will be displayed.

USER_ID=${UID}
ROOT_ID=0

# Make sure the script is being executed with superuser privileges.
if [[ ${USER_ID} -ne ${ROOT_ID} ]]
then
    echo "Pleae run with sudo or as a root."
    exit 1
fi

# GEt the username (login).
read -p "Enter the username to create: " USER_NAME

# Get the real name (contents for the description field).
read -p "Enter the name of the person or application that will be using this account: " COMMENT

# Get the password.
read -p "Enter the password to use for the account: " PASSWORD

# Creat the account.
useradd -c "${COMMENT}" -m "${USER_NAME}"

# Check to see if the useradd command succeeded.
# if it didn't, script will tell the user that account was not created
if [[ "${?}" -ne 0 ]]
then
    echo "Account was not created for some reason"
    exit 1
fi

# Set the password
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

if [[ "${?}" -ne 0 ]]
then
    echo "The password for the account could not be set."
    exit 1
fi

# Force password change on first login
passwd -e ${USER_NAME}

# Display the username, password, and the host where the user was created.
echo
echo -e "username:\n${USER_NAME}\n"
echo -e "password:\n${PASSWORD}\n"
echo -e "host:\n${HOSTNAME}"
exit 0
