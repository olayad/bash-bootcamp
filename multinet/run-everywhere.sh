#!/bin/bash

# Executes an ssh in multiple hosts

SERVERS_FILE='/vagrant/servers'

# Options for the ssh command
SSH_OPTIONS='-o ConnectTimeout=2'

usage() {
  echo "Usage: ${0} [-vsn] [-f FILE] COMMAND"
  echo 'This script allows a user to execute commands in multiple hosts.' 
  echo 'This script should not be run as superuser.' 
  echo '  -v	Verbose mode.' 
  echo '  -n	Dry run mode, display COMMAND instead of execute.' 
  echo "  -f 	Provide a file that includes hosts names. Default ${SERVER_FILE}" 
  echo '  -s 	Execute COMMAND in host as sudo.' 
  exit 1
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
  log 'Script should not be run as superuser, user -s option instead.' 2
  usage
fi 


# Process input parameters
while getopts f:nsv OPTION
do
  case ${OPTION} in
    f)  SERVERS_FILE="${OPTARG}" ;;
    n)  DRY_RUN='true' ;;
    s)  SUDO='sudo' ;;
    v)  VERBOSE='true' ;;
    ?)  usage  ;;
  esac
done

# Remove the options while leaving remaining args.
shift "$(( OPTIND  - 1 ))"
if [[ "${#}" -eq 0 ]]
then 
  usage
fi
# Anything that remains, treat it as a single command
COMMAND=${@}


# Check if servers file exists
log 'Checking if server file exists...' 1
if  [[ ! -e "${SERVERS_FILE}" ]]
then
  echo "Servers file could not be opened: ${SERVERS_FILE}" >&2
  exit 1
fi

EXIT_STATUS='0'
for SERVER in $(cat ${SERVERS_FILE})
do
  SSH_COMMAND="ssh ${SSH_OPTIONS} ${SERVER} ${SUDO} ${COMMAND}"
  log "Executing command:${SSH_COMMAND} @:${SERVER}" 1
  if  [[ "${DRY_RUN}" = 'true' ]]
  then
    echo "DRY RUN: ${SSH_COMMAND}"
  else
    ${SSH_COMMAND}
    SSH_EXIT_STATUS="${?}"
  fi
  if [[ "${SSH_EXIT_STATUS}" -ne 0 ]] 
  then
     EXIT_STATUS="${SSH_EXIT_STATUS}"
     log "Execution failed. ${SSH_COMMAND}@:${SERVER}" 2
  fi
  echo
done

exit ${EXIT_STATUS}
