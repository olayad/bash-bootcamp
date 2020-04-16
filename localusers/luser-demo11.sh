#!/bin/bash

# This script generates a random password
# This user can set password length with -l and add special char with -s
# Verbose mode with -v

log() {

	local MESSAGE="${@}"
	if [[ "${VERBOSE}" = 'true' ]]
	then
		echo "${MESSAGE}"
	fi
}

usage() {
	echo "Usage: ${0} [-vs] [-l LENGTH]" >&2
	echo "Generate a random password."
	echo "  -l LENGTH 	Specify the password length."
	echo "  -s		Append a special character to the password."
	echo "  -v		Increase verbosity."
	exit 1	
}

# Set a default password length
LENGTH=48

while getopts vl:s OPTION
do
	case ${OPTION} in
	  v)
		VERBOSE='true'
		log 'Verbose mode on.'
	  	;;
	  l)
		LENGTH="${OPTARG}"
		;;
	  s)
		USE_SPECIAL_CHARACTER='true'
		;;
	  ?)
		usage
		;;
	esac
done

log 'Generating a password...'

PASSWORD=$(date +%s%N${RANDOM}{RANDOM} | sha256sum | head -c${LENGTH})

# Append special character if requested to do so.
if [[ "${USE_SPECIAL_CHARACTER}" = 'true' ]]
then
	log 'Selecting a random special character...'
	SPECIAL_CHARACTER=$(echo '!@#$%^&*()-+=' | fold -w1 | shuf | head -c1)
	PASSWORD="${PASSWORD}${SPECIAL_CHARACTER}"
fi

echo 'Password:'
echo "${PASSWORD}"

exit 0
