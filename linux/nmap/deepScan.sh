#!/bin/bash

# Source the env file
. .env

CURRENTDATE=`date +"%Y-%m-%d--%I-%M-%S"`
nmap -A -T4${IPTARGET} > "./output/deep-${CURRENTDATE}.log"
