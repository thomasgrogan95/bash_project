#!/bin/bash
if [ $# -ne 4 ]; then
   echo "Error: parameters problem."
elif [ ! -e "$1" ]; then
   echo "Error: user does not exist."
elif [ "$3" == "f" ]; then
   if [ -e "$1"/"$2" ]; then
      echo -e "$4" > "$1"/"$2"
      echo "OK: service updated"
   elif [[ "$2" == *"/"* ]]; then
      IFS='/'
      read -ra ARR <<< "$2"
      folder=( "${ARR[0]}" )
      file=( "${ARR[1]}" )
      IFS=' '
      if [ -e "$1"/"$folder" ]; then
         touch "$1"/"$folder"/"$file"
         echo -e "$4" > "$1"/"$folder"/"$file"
         echo "OK: service created"
      else
         mkdir "$1"/"$folder"
         touch "$1"/"$folder"/"$file"
         echo -e "$4" > "$1"/"$folder"/"$file"
         echo "OK: service created"
      fi
   else
      touch"$1"/"$2"
      echo -e "$4" > "$1"/"$2"
      echo "OK: service created"
   fi
elif [ "$3" != "f" ]; then
   if [ -e "$1"/"$2" ]; then 
      echo "Error: service already exists."
   elif [[ "$2" == *"/"* ]]; then
      IFS='/'
      read -ra ARR <<< "$2"
      folder=( "${ARR[0]}" )
      file=( "${ARR[1]}" )
      IFS=' '
      if [ -e "$1"/"$folder" ]; then
          touch "$1"/"$folder"/"$file"
          echo -e "$4" > "$1"/"$folder"/"$file"
          echo "OK: service created"
      else
          mkdir "$1"/"$folder"
          touch "$1"/"$folder"/"$file"
          echo -e "$4" > "$1"/"$folder"/"$file"
          echo "OK: service created"
      fi
   else
      touch "$1"/"$2"
      echo -e "$4" > "$1"/"$2"
      echo "OK: service created"
   fi
fi
   
   
