#!/bin/bash

# Analyzes syslog file to find number of failed login attempts per ip.

FILE=${1}
if [[ ! -e "${FILE}" ]]
then
  echo "File does not exit, terminating program."
  exit 1
fi


TMP="./tmp-totals.txt"
TMP2="./tmp-totals2.txt"
TOTALS="./totals.csv"
cat ./${FILE} | grep -E "\bFailed password for invalid user" | grep -v "snapshot" | awk '{print $13}' > ${TMP}
cat ./${FILE} | grep -E "\bFailed password for root" | awk '{print $11}' >> ${TMP}
cp ${TMP} ${TMP2}
cat ${TMP} | sort -n | uniq -c | sort -nr > ${TMP2}


echo "Count,IP,Location" > ${TOTALS}
cat ${TMP2} | while read LINE
do
	NUM_ATTEMPTS=$(echo "${LINE}" | awk '{print $1}')
	if [[ "${NUM_ATTEMPTS}" -gt 9 ]]
	then
		IP=$(echo "${LINE}" | awk '{print $2}')
		LOCATION=$(geoiplookup ${IP} | awk -F ":" '{print $2}')
		echo "${NUM_ATTEMPTS},${IP},${LOCATION}" >> ${TOTALS}
	fi
done


rm ${TMP} ${TMP2}
exit 0


