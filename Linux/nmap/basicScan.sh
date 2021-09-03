#!/bin/bash

# Source the env file
. .env

CURRENTDATE=`date +"%Y-%m-%d--%I-%M-%S"`
nmap ${IPTARGET} > "./output/basic-${CURRENTDATE}.log"
