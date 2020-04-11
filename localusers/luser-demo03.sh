#!/bin/bash

# Display the UID and username of the user executing this script.
# Display if the user is the vagrant user or not.

# Display the UID.
echo "Your UID is ${UID}"

# Only display if the UID does not match 1000.
UID_TO_TEST_FOR='1000'
if [[ "${UID}" -ne "${UID_TO_TEST_FOR}" ]]
then
	echo "hi ${UID_TO_TEST_FOR}"
	exit 1
fi

# Display the username.
USER_NAME=$(id -un)

# Test if the command succeeded.

# test for != for the string.
