#!/bin/bash

# This script generates a list of random passwords.


# Random number as password
PASSWORD=${RANDOM}

# Three random numbers together
PASSWORD="${RANDOM}${RANDOM}${RANDOM}"
echo "${PASSWORD}"

# use the current date/time as the basis for password
PASSWORD=$(date +%s)
echo "${PASSWORD}"

# user nanoseconds to act as randomization.
PASSWORD=$(date +%s%N)
echo "${PASSWORD}"

# a better pass
PASSWORD=$(date +%s%N | sha256sum | head -c 32)
echo "${PASSWORD}"

# even better
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c 48)
echo "${PASSWORD}"

# append special char to password
RANDCHAR=$(echo '!@#$%^&*' | fold -w 1 | shuf | head -n 1)
echo "${PASSWORD}${RANDCHAR}"
