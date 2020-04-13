#!/bin/bash

# Display the UID and username of the user executing this script.
# Display if the user is the vagrant user or not.

# Display the UID.
echo "Your UID is ${UID}"

# Only display if the UID does not match 1000.
UID_TO_TEST_FOR='1000'
if [[ "${UID}" -ne "${UID_TO_TEST_FOR}" ]]
then
	echo "Your UID does not match ${UID_TO_TEST_FOR}"
	exit 1
fi

# Display the username.
USER_NAME=$(id -un)

# Test if the command succeeded.
if [[ "${?}" -ne 0 ]]
then
	echo 'The id command did not execute succesfully.'
	exit 1
fi
echo "Your username is ${USER_NAME}"

# test for != for the string.
USER_NAME_TO_TEST_FOR='casa'
if [[ "${USER_NAME}" = "${USER_NAME_TO_TEST_FOR}" ]]
then
	echo "your username matches ${USER_NAME_TO_TEST_FOR}."
fi

if [[ "${USER_NAME}" != "${USER_NAME_TO_TEST_FOR}" ]]
then
	echo "Your username does not match ${USER_NAME_TO_TEST_FOR}."
	exit 1
fi

exit 0
