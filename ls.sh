#!/bin/bash
if [ $# -eq 1 ]; then
   if [ ! -e "$1" ]; then
      echo "Error: user does not exist"
   else
      echo "OK:"
      tree "$1"
   fi
elif [ $# -eq 2 ]; then
   if [ ! -e "$1" ]; then
      echo "Error: user does not exist"
   elif [ ! -d "$1"/"$2" ]; then
      echo "Error: folder does not exist"
   else
      echo "OK:"
      tree "$1"/"$2"
   fi
else
   echo "Error: parameters problem"
fi
