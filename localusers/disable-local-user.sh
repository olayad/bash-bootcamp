#!/bin/bash

# Deletes user from system

usage () {
	echo "Usage: ${0} USERNAME" >&2
}

if [[ "${UID}" -ne 0 ]]
then
	echo "Please run this scripit as root." >&2
	exit 1
fi

while getopts "dra" OPTION
do
  case ${OPTION} in
	d )
	  echo "Deleting account..."
	  ;;
	r )
	  echo "Removing home directory..."
	  ;;
	a )
	  echo "Creating home directory archive..."
	  ;;
	? )
	  usage
	  ;;
	esac
done

# Remove the options while leaving the reamaining arguments
shift "$(( OPTIND - 1 ))"
if [[ "${#}" -eq 0 ]]
then 
	usage
	exit 1
fi

# Processing user list
while [[ "${#}" -gt 0 ]]
do
  echo
  USER=${1}
  echo "Processing request to delete user: ${USER}"
  ID=$(id -u ${USER} 2>/dev/null)
  if [[ "${?}" -ne 0 ]]
  then
  	echo "Could NOT find user ${USER} in the system."
  fi	
  
  #if [[ "${?}" -ne 0 ]] && [[ ${ID} -lt 1000 ]]
  if [[ ! -z "${ID}" ]] && [[ ${ID} -lt 1000 ]]
  then
	# echo "ID string is empty"
  	echo "Cannot delete system account, skipping user ${USER} deletion with id: ${ID}"
  fi 

  shift 
done
