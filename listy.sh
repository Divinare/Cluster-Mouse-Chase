#!/bin/bash

ukkoLocation=".hpc.cs.helsinki.fi"

echo "Listy started."

path=$1
cd $path

rm cmsg
touch cmsg

basePort=$(awk '{print $2}' $path"/nc_port_listy")

while true
do
	#sleep 2
	echo "Listening port" $basePort"..."
    nc -dl $basePort >> cmsg
	echo "A message inserted into cmsg."
done

echo "Closing listy"

exit
