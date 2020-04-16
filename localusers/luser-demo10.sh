#!/bin/bash


log() {
  # This function sends a message to syslog an stdout if verbose is true
  local MESSAGE="${@}"
  if [[ "${VERBOSE}" = 'true' ]]
  then
  	echo "${MESSAGE}"
  fi
  logger -t luser-demo10.sh "${MESSAGE}"
}

backup_file() {
  # This function creates a backup of a file. Returns non-zero status on error.

  local FILE="${1}"
  if [[ -f "${FILE}" ]]
  then
  	local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"
  	log "Backing up ${FILE} to ${BACKUP_FILE}."

	# Exist status of function will be that of cp
	cp -p ${FILE} ${BACKUP_FILE}
  else
	# File does not exist, so return a non-zero exit status
	return 1
  fi
} 	

readonly VERBOSE='true'

log 'Hello!'
log 'This is fun'


backup_file '/etc/passwd'

#Make decision based on the exit status of function
if [[ "${?}" -eq 0 ]]
then 
	log 'File backup succeeded!'
else
	log 'file backup failed!'
	exit 1
fi
