#!/bin/bash
if [ $# -ne 1 ]; then
   echo "Error: Please enter only one user"
elif [ -e "$1" ]; then
   echo "Error: user already exists"
else
   echo "OK: user created"
   mkdir $1
fi
