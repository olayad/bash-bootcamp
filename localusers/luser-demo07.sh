#!/bin/bash

# Demonstrate the use of shift andn while loops

# Display the first three params
echo "Parameter 1: ${1}"
echo "Parameter 2: ${2}"
echo "Parameter 3: ${3}"
echo 

# Loop through all positional params
while [[ "${#}" -gt 0 ]]
do
	echo "Number of parameters: ${#}"
	echo "Param 1: ${1}"
	echo "Param 2: ${2}"
	echo "Param 3: ${3}"
	echo
	shift 
done

