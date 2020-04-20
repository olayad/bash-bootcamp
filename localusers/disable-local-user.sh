#!/bin/bash

# This script disables, deletes and/or archives users on the local system.

ARCHIVE_DIR='/archive'

usage () {
	echo "Usage: ${0} [-dra] USERNAME [USERN]..." >&2
	echo "Disables a local lunux account." >&2
	echo "  -d 	Deletes accounts instead of disabling them." >&2
	echo "  -r 	Removes the home directory associated with the account(s)." >&2
	echo "  -a 	Creates home directory archive and stores in ${ARCHIVE_DIR}." >&2
	exit 1
}

if [[ "${UID}" -ne 0 ]]
then
	echo "Please run this scripit as root." >&2
	exit 1
fi

# Parse options
while getopts "dra" OPTION
do
  case ${OPTION} in
	d) DELETE='true' ;;
	r) REMOVE_HOME='-r' ;;
	a) ARCHIVE='true' ;;
	?) usage ;;
	esac
done


# Remove the options while leaving the reamaining arguments
shift "$(( OPTIND - 1 ))"
if [[ "${#}" -eq 0 ]]
then 
	usage
fi


# Processing user list
for USER in "${@}"
do
  echo
  ID=$(id -u ${USER} 2>/dev/null)
  if [[ "${?}" -ne 0 ]]
  then
  	echo "Could NOT find user ${USER} in the system."
	continue
  fi	
  
  if [[ ! -z "${ID}" ]] && [[ ${ID} -lt 1000 ]]
  then
  	echo "Cannot delete system account, skipping user ${USER} deletion with id: ${ID}"
	continue
  fi 


  if [[ "${ARCHIVE}" = 'true' ]]
  then
	if [[ ! -d ${ARCHIVE_DIR} ]]
	then
		mkdir -p ${ARCHIVE_DIR}
	fi
	if [[ "${?}" -ne 0 ]]
	then
		echo "The archive dir ${ARCHIVE_DIR} could not be created." &>2
		exit 1
	fi

	# Archive the user's home dir and move it to into the ARCHIVE_DIR
	HOME_DIR="/home/${USER}"
	ARCHIVE_FILE="${ARCHIVE_DIR}/${USER}.tgz"
	if [[ -d "${HOME_DIR}" ]]
	then
		echo "Archiving home for user: ${USER}..."
		tar -zcvf ${ARCHIVE_FILE} ${HOME_DIR}/ &>/dev/null
		if [[ "${?}" -ne 0 ]]
		then
			echo "Error occurred creating archive ${ARCHIVE_FILE}."
			exit 1	
		fi
	else
		echo "${HOME_DIR} doe snot exist or is not a directory." >&2
		exit 1
  	fi
  fi
  
  
  if [[ "${DELETE}" = 'true' ]]
  then
	userdel ${REMOVE_HOME} ${USER}
  	if [[ "${?}" -ne 0 ]]
  	then
		echo "ERROR deleting user: ${USER}"
  		exit 1
 	fi
	echo "The account ${USER} was deleted."
  else
  	chage -E 0 ${USER}
  	if [[ "${?}" -ne 0 ]]
  	then
		echo "ERROR suspending user: ${USER}"
  		exit 1
 	fi
	echo "The account ${USER} was suspended."
  fi
done

exit 0
