#!/bin/bash

# Enforces that script is run by superuser
if [[ "${UID}" -eq 0 ]]
then
	echo "W00t, you are root"
else
	echo "ERROR, you must be root to run this command"
	exit 1
fi

# Prompt the person who executed the script to enter the username(login) of new account user and password
read -p 'Enter new username account: ' USERNAME
read -p 'Enter real name: ' COMMENT
read -p 'Enter new password account: ' PASSWORD

# create the new account and set password
useradd -c "${COMMENT}" -m ${USERNAME}
echo ${PASSWORD} | passwd --stdin ${USERNAME}

# test if the password was created succesfully
if [[ "${?}" -ne 0 ]]
then
	echo "There was an ERROR creating the password"
	exit 1
fi
echo "New account created: ${USERNAME} - ${PASSWORD} at ${HOSTNAME}"

# force password to reset after first login
passwd -e ${USERNAME}
exit 0
