#!/bin/bash

# This script generates a random password for each user specirfied on the command line

# Display what the user typed on the command line.
echo "You executed this command: ${0}"

# Display path and filename of the script.
echo "You need $(dirname ${0}) as path to the $(basename ${0}) script."

# Tell the user how many args they passed in
# Inside the script they are parameters, outside they are arguments
NUM_PARAMS="${#}"
echo "You supplied ${NUM_PARAMS} argument(s) on the command line"

# make sure supply one argument at least.
if [[ "${NUM_PARAMS}" -lt 1 ]]
then
	echo "Usage: ${0} USER_NAME [USER_NAME] ..."
	exit 1
fi

# Generate and display a password for each parameter.
for USER_NAME in "${@}"
do
	PASSWORD=$(date +%s%N | sha256sum | head -c48)
	echo "${USER_NAME}: ${PASSWORD}"
done

