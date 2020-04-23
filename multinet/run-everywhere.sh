#!/bin/bash

#

usage() {
  echo 'This script allows a user to execute commands in multiple hosts.'
  echo 'This script should not be run as superuser.'
  echo 'Usage: ${0} [-vsn] [-f FILE]' 
  echo '  -v	Verbose mode.'
  echo '  -n	Dry run commands, display instead of execute.' 
  echo '  -f 	Provide a file that includes hosts names.'
  echo '  -s 	Run commands in host as sudo.'
}


# Logs to File Descriptor (FD) stdout(1) and stderr(2).
log() {
  local MESSAGE="${1}"
  local FD="${2}"
  if [[ "${FD}" -eq '1' ]] && [[ "${VERBOSE}" = 'true' ]]
  then
    echo "INFO:	${MESSAGE}" >&1
  elif [[ "${FD}" -eq '2' ]] && [[ "${VERBOSE}" = 'true' ]]
  then
    echo "ERROR: ${MESSAGE}" >&2
  fi
}

# Enforce that script is NOT being run as sudo
if [[ "${UID}" -eq 0 ]]
then
  log 'Script should not be run as superuser.' 2
  usage
fi 


SERVERS_FILE='/vagrant/servers'

# Process input parameters
while getopts f:nsv OPTION
do
  case ${OPTION} in
    f)  SERVERS_FILE="${OPTARG}" ;;
    n)  DRY_RUN='true' ;;
    s)  SUPERUSER='true' ;;
    v)  VERBOSE='true' ;;
    ?)  usage  ;;
  esac
done

# Check if servers file exists
log 'Checking if server file exists...' 1
if  [[ ! -e "${SERVERS_FILE}" ]]
then
  log "Servers file could not be accessed." 2
  exit 1
fi


for SERVER in $(cat ${SERVERS_FILE})
do
  echo "server: ${SERVER}"
done

exit 0
