#!/bin/bash

# This script demonstrate I/O redirection.

# Redirect STDOUT to a file
FILE="/tmp/data"
head -n1 /etc/passwd > ${FILE}

# Redirect STDIN to a program
echo
read LINE < ${FILE}
echo "Contents of line: ${LINE}"

# Redirct STDOUT to a file, appending to the file
echo
echo "${RANDOM} ${RANDOM}" >> ${FILE}
echo "Contents of ${FILE}:"
cat ${FILE}	

# Redirect STDIN to a program, using FD 0.
read LINE 0< ${FILE}
echo
echo "LINE contains: ${LINE}"

# Redirect STDOUT to a file using FD 1, overwritting the the file
head -n3 /etc/passwd 1> ${FILE}
echo
echo "Contents of ${FILE}"
cat ${FILE}

# Send output to STDERR
echo
echo "This is STDERR!" >&2

# Discard STDOUT
echo 
echo "Discarding STDOUT:"
head -n3 /etc/passwd /fakefile > /dev/null

# Discard STDOUT and STDERR
echo
echo "Discarding both STDOUT and STDERR:"
head -n3 /etc/passwd /fakefile &> /dev/null

# Clean up
rm ${FILE} ${ERR_FILE} &> /dev/null
