#!/bin/bash
#
# This script creates a new user on the local system.
# You must supply a username as an argument to the script.
# Optionally, you can also provide a comment for the account as an argument.
# A password will be automatically generated for the account.

# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then
    echo "Pleae run with sudo or as a root." >&2
    exit 1
fi

# Check if user supply at least one argument, then give them help.
if [[ "${#}" -eq 0 ]]
then
    echo "Usage: ${0} USERNAME [COMMENT]..." >&2
    exit 1
fi

# The first parameter is the user name.
USER_NAME="${1}"

# Any remaining arguments are treated as comment for the account.
shift
COMMENT=${*}

# Generate a password for the account.
PASSWORD=$(date +%s%N | sha256sum | head -c48) &> /dev/null

# Add new user
useradd -c "${COMMENT}" -m "${USER_NAME}" &> /dev/null

# Check if it was added
if [[ ${?} -ne 0 ]]
then
    echo "The account could not be created." >&2
    exit 1
fi

# Set the password on the account.
echo "${PASSWORD}" | passwd --stdin ${USER_NAME} &> /dev/null

if [[ "${?}" -ne 0 ]]
then
    echo 'Password could not be set.' >&2
    exit 1
fi

# Force password change on first login.
passwd -e ${USER_NAME} &> /dev/null

# Display username, password and the host where the user was created.
echo -e "username: ${USER_NAME}\n"
echo -e "password: ${PASSWORD}\n"
echo -e "host: ${HOSTNAME}\n"
exit 0