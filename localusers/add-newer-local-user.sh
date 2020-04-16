#!/bin/bash

# Creates a new user and password with the arguments given.
# Password is generated randomly


# Check root is running the program
if [[ "$(id -u)" -ne 0 ]]
then
	echo "Please run script with sudo or as root, current UID: ${UID}" >&2
	exit 1
fi


# Check the first args (positional param) was given.
if [[ "${#}" -eq 0 ]]
then
	echo "Usage: ${0} USER_NAME [COMMENT]..." >&2
	exit 1
fi

# create new user with args given
USER_NAME=${1}
shift
COMMENTS=${*}
useradd -c "${COMMENTS}" -m ${USER_NAME} &> /dev/null
if [[ "${?}" -ne 0 ]]
then 
	echo "There was an error creating the user" >&2
	exit 1
fi

# generate password
PASSWORD=$(date +%s%N | sha256sum | head -c 48)
echo ${PASSWORD} | passwd --stdin ${USER_NAME} &> /dev/null
if [[ "${?}" -ne 0 ]]
then
	echo "There was an error creating the password" >&2
	exit 1
fi
passwd -e ${USER_NAME} > /dev/null

# Display the new user created info
echo "NEW USER CREATED: "
echo "User: ${USER_NAME}"
echo "Comments: ${COMMENTS}"
echo "Password:  ${PASSWORD}"
echo "Host:  ${HOSTNAME}"

exit 0

