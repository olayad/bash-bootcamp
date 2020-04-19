#!/bin/bash

# Deletes user from system

usage () {
	echo "Usage: ${0} USERNAME" >&2
	exit 1
}

if [[ "${UID}" -ne 0 ]]
then
	echo "Please run this scripit as root." >&2
	exit 1
fi

DELETE=false;
REMOVE_HOME=false;
ARCHIVE=false
while getopts "dra" OPTION
do
  case ${OPTION} in
	d )
	  DELETE=true
	  ;;
	r )
	  REMOVE_HOME=true
	  ;;
	a )
	  ARCHIVE=true
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
fi


# Processing user list
while [[ "${#}" -gt 0 ]]
do
  echo
  USER=${1}
  ID=$(id -u ${USER} 2>/dev/null)
  if [[ "${?}" -ne 0 ]]
  then
  	echo "Could NOT find user ${USER} in the system."
  	shift
	continue
  fi	
  
  if [[ ! -z "${ID}" ]] && [[ ${ID} -lt 1000 ]]
  then
  	echo "Cannot delete system account, skipping user ${USER} deletion with id: ${ID}"
  	shift
	continue
  fi 


  if [[ "${ARCHIVE}" = true ]]
  then
	if [[ ! -d /archives ]]
	then
		mkdir /archives
	fi
	echo "Archiving home for user: ${USER}..."
	tar -zcvf /archives/${USER}.tar.gz /home/${USER}/ &>/dev/null
	if [[ "${?}" -ne 0 ]]
	then
		echo "Error occurred creating archive, skipping user: ${USER} deletion"
		shift
		continue
	fi
  fi
  
  
  if [[ "${DELETE}" = true ]]
  then
	echo "Deleting user: ${USER}, deleting home dir"
	userdel --remove ${USER}
	shift
	continue
  fi
  if [[ "${?}" -ne 0 ]]
  then
	echo "ERROR deleting user: ${USER}"
	shift
	continue
  
  fi


  if [[ "$REMOVE_HOME" = true ]]
  then
	echo "Removing home dir, user: ${USER}"
	rm -r /home/${USER}
  fi
  if [[ "${?}" -ne 0 ]]
  then
	echo "ERROR removing home dir, user: ${USER}"
	shift
	continue
  
  fi


  chage -E0 ${USER}
  if [[ "${?}" -ne 0 ]]
  then
  	echo "Error disabling user: ${USER} account"
	shift
	continue
  fi

  echo "User: ${USER} suspended succesfully."
  shift 
done

exit 0
