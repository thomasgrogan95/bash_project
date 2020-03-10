#!/bin/bash
if [ $# -lt 2 ]; then
   echo "Incorrect number of arguments"
   exit 1
elif [ $2 == "init" ]; then
   if [ $# -ne 3 ]; then
      echo "Parameters error"
      exit 1
   else
      mkfifo $1.pipe
      echo "$1" "$2" "$3" > server.pipe
      read line < $1.pipe
      echo "$line"
      rm $1.pipe
   fi
elif [ $2 == "insert" ]; then
   if [ $# -ne 4 ]; then
      echo "Parameters error"
      exit 1
   else
      mkfifo $1.pipe
      echo "Please write login:"
      read login
      echo "Automatically generate password? ( Y for Yes, any other button for No )"
      read answer
      if [ "$answer" == 'Y' ] || [ "$answer" == 'y' ]; then
         password='date +%s | sha256sum | base64 | head -c 32'
         payload="login: ${login} password: $(eval "$password")"
         echo "$1" "$2" "$3" "$4" "$payload" > server.pipe
	 read line < $1.pipe
         echo "$line"
      else 
      	 echo "Please write password:"
      	 read password
      	 payload="login: ${login} password: ${password}"
      	 echo "$1" "$2" "$3" "$4" "$payload" > server.pipe
      	 read line < $1.pipe
      	 echo "$line"
      fi
      rm $1.pipe
   fi
elif [ $2 == "show" ]; then
   if [ $# -ne 4 ]; then
      echo "Parameters error"
      exit 1
   else
      mkfifo $1.pipe
      echo "$1" "$2" "$3" "$4" > server.pipe
      read line < $1.pipe
      array=($line)
      login=${array[1]}
      password=${array[3]}
      echo "$3's login for $4 is: $login"
      echo "$3's password for $4 is: $password"
      rm $1.pipe
   fi
elif [ $2 == "ls" ]; then
   if [ $# -lt 3 ]; then
      echo "Parameters error"
      exit 1
   else
      mkfifo $1.pipe
      if [ $# -eq 3 ]; then
         echo "$1" "$2" "$3" > server.pipe
      elif [ $# -eq 4 ]; then
         echo "$1" "$2" "$3" "$4" > server.pipe
      fi
      while read p; do
         echo "$p"
      done < $1.pipe
      rm $1.pipe
   fi
elif [ $2 == "edit" ]; then
   if [ $# -ne 4 ]; then
      echo "Parameters error"
      exit 1
   else 
      mkfifo $1.pipe
      echo "$1" "show" "$3" "$4" > server.pipe
      temp="$(mktemp)"
      read payload < $1.pipe
      echo "$payload" > $temp
      vi $temp
      read payload < $temp
      echo "$1" "update" "$3" "$4" "$payload" > server.pipe
      read line < $1.pipe
      echo "$line"
      rm $temp
      rm $1.pipe
   fi
elif [ $2 == "rm" ]; then
   if [ $# -ne 4 ]; then
      echo "Parameters error"
      exit 1
   else
      mkfifo $1.pipe
      echo "$1" "$2" "$3" "$4" > server.pipe
      read line < $1.pipe
      echo "$line"
      rm $1.pipe
   fi
elif [ $2 == "shutdown" ]; then
   mkfifo $1.pipe
   echo "$1" "$2" > server.pipe
   read line < $1.pipe
   echo "$line" 
   rm $1.pipe
fi
