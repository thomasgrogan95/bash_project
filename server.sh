#!/bin/bash
while true; do
   if [ ! -e server.pipe ]; then
      mkfifo server.pipe
   fi
   read line < server.pipe
   arr=($line)
   client=${arr[0]}
   request=${arr[1]}
   user=${arr[2]}
   service=${arr[3]}
   details="${arr[4]} ${arr[5]} ${arr[6]} ${arr[7]}"
   #read request user service details 
   while [ -d $user.lock ]; do
      sleep 1
   done
   mkdir $user.lock 
   case "$request" in 
      init)
         ./init.sh "$user" > $client.pipe &
         rmdir $user.lock &
         ;;
      insert)  
         ./insert.sh "$user" "$service" "t" "$details" > $client.pipe &
         rmdir $user.lock &
         ;;
      show)
	 ./show.sh "$user" "$service" > $client.pipe &
         rmdir $user.lock &
         ;;
      update)
	 ./insert.sh "$user" "$service" "f" "$details" > $client.pipe &
         rmdir $user.lock &
         ;;
      rm)
         ./rm.sh "$user" "$service" > $client.pipe &
         rmdir $user.lock &
         ;;
      ls)
         ./ls.sh "$user" "$service" > $client.pipe &
         rmdir $user.lock &
         ;;
      shutdown)
         echo "The server has been shut down" > $client.pipe &
         rmdir $user.lock &
	 rm server.pipe &
	 exit 0
         ;;
      *)
         echo "Error: bad request"
         rmdir $user.lock &
         exit 1
   esac
done
