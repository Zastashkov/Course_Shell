#!/bin/bash
#
# This script creates a new user on the local system.
# You must supply a username as an argument to the script.
# Optionally, you can also provide a comment for the account as an argument.
# A password will be automatically generated for the account.

# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then
    echo "Pleae run with sudo or as a root."
    exit 1
fi

# Check if user supply at least one argument, then give them help.
if [[ "${#}" -eq 0 ]]
then
    echo "Usage: ${0} USERNAME [COMMENT]..."
    exit 1
fi

# The first parameter is the user name.
USER_NAME="${1}"

# Any remaining arguments are treated as comment for the account.
shift
COMMENT=${*}

# Generate a password for the account.
PASSWORD=$(date +%s%N | sha256sum | head -c48)

# Add new user
useradd -c "${COMMENT}" -m "${USER_NAME}"

# Check if it was added
if [[ ${?} -ne 0 ]]
then
    echo "The account could not be created."
    exit 1
fi

# Set the password on the account.
echo "${PASSWORD}" | passwd --stdin ${USER_NAME}

if [[ "${?}" -ne 0 ]]
then
    echo 'Password could not be set.'
    exit 1
fi

# Force password change on first login.
passwd -e ${USER_NAME}

# Display username, password and the host where the user was created.
echo
echo -e "username: ${USER_NAME}\n"
echo -e "password: ${PASSWORD}\n"
echo -e "host: ${HOSTNAME}\n"
exit 0