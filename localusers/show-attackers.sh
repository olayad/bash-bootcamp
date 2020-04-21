#!/bin/bash


# Analyzes syslog file to find number of failed login attempts per ip.
# If there are any IPs with over LIMIT failures, display the count, IP and location.

LIMIT='10'
FILE=${1}

if [[ ! -e "${FILE}" ]]
then
  echo "File does not exit, terminating program, ${FILE}" >&2
  exit 1
fi

echo "Count,IP,Location"
grep Failed ${FILE} | awk -F 'from ' '{print $2}' | awk '{print $1}' | sort | uniq -c | sort -nr | while read COUNT IP
do
	if [[ "${COUNT}" -gt "${LIMIT}" ]]
	then
		LOCATION=$(geoiplookup ${IP} | awk -F ', ' '{print $2}')
		echo "${COUNT},${IP},${LOCATION}"
	fi
done

exit 0


