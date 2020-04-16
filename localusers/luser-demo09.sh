#!/bin/bash

# This script demonstrates the case statement.
#if [[ "${1}" = 'start' ]]
#then
#	echo "starting.."
#elif [[ "${1}" = 'stop' ]]
#then
#	echo "stopping..."
#elif [[ "${1}" = "status" ]]
#then 
#	echo "Status: "
#else
#	echo "Supply a valid option." >&2
#	exit 1
#fi

case "${1}" in
  start)
 	echo 'Starting.'
	;;
  stop)
 	echo 'Stopping.'
	;;
  status|state|--status|--state)
  	echo 'Status.'
	;;
  *)
 	echo 'Supply a valid option' >&2
	exit 1
	;;
esac

exit 0

