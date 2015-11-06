#!/bin/bash

ukkoLocation=".hpc.cs.helsinki.fi"

# Cat gets params:
# $1=path $2=catName $3=command $4=targetNode

path=$1
catName=$2
command=$3
targetNode=$4

cd $path

echo "$catName at $targetNode with command $command in path $path"

mousePID=$(ps -u $USER|grep "mouse"|awk '{ print $1 }')
basePortListy=$(awk '{print $2}' "nc_port_listy")
basePortMouse=$(awk '{print $2}' "nc_port_number")
listyLocation=$(head -n 1 "listy_location")$ukkoLocation

echo "mouse pid: " $mousePID
echo "length: " ${#mousePID}

mouseFound() {
    echo "Mouse found from $targetNode!"
	echo "Sending information to listy in location $listyLocation at port $basePortListy"
    echo "F $targetNode $catName   Found the mouse on $targetNode" |nc $listyLocation $basePortListy
}

mouseNotFound() {
	echo "Did not found a mouse!"
    echo "$targetNode $catName $listyLocation $basePortListy"
	echo "Sending information to listy in location $listyLocation at port $basePortListy"
	echo "N $targetNode $catName    No mouse on $targetNode" |nc $listyLocation $basePortListy
}

mouseCaught() {
	echo "Caught mouse! Sending information to listy."
	echo "Sending information to listy in location $listyLocation at port $basePortListy"
	echo "G $targetNode $catName   Got the mouse" |nc $listyLocation $basePortListy
}

attackMouse() {
   echo "Attacking mouse!"
   echo "MEOW" |nc localhost $basePortMouse
}

# SEARCH
if [ $command == "S" ]
then
    sleep 12 # Takes 12 seconds to search the node
	if [[ -n "$mousePID" ]]
	then
		echo "mouse found, doing actions.."
		mouseFound
	else
		echo "mouse not found, doing actions.."
		mouseNotFound
	fi
fi

# ATTACK
if [ $command == "A" ]
then
    attackMouse
    trap SIGINT
    mouseCaught
	# Cat waits 8 seconds for SIGINT
	sleep 8
fi

echo "Exiting from cat $catName"

exit
