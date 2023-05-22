#!/bin/bash
dpkg --get-selections | grep -w "install" | awk '{print $1}' > ubuntu_packages.txt 
while read p; do
 echo "::::::::::::::::::: Reinstalling: $p :::::::::::::::::::"
 apt reinstall $p
done < ubuntu_packages.txt
