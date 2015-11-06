#!/bin/bash

ukkoLocation=".hpc.cs.helsinki.fi"

path=$1
cd $path

# Get the basePort from nc_port_number file:
basePort=$(awk '{print $2}' "nc_port_number")
port=$(($basePort + $(($$%1000))))   # $$ = pid of the mouse

echo $basePort

while true
do
	echo "Listening port "$port"..."
	message=$( nc -l $port)
	echo $message

	if [[ $message=="MEOW" ]]
    then
		# The attack takes 6 seconds
		sleep 6
		catPID=$(ps -u $USER|grep "cat"|awk '{ print $1 }')
		echo "cat pid:"
		echo $catPID
        kill -s SIGINT $catPID
		break
	fi

done

exit


