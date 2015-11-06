#!/bin/bash
ukkoLocation=".hpc.cs.helsinki.fi"
currentDir=$(pwd)

rm logsCatty.txt
touch logsCatty.txt

rm logsJazzy.txt
touch logsJazzy.txt

rm logsListy.txt
touch logsListy.txt

rm logsMouse.txt
touch logsMouse.txt

listyLocation=$(head -n 1 listy_location)

randomNode() {
	linesCount=$(awk 'END {print NR}' ukkonodes)
	randomNum=$(shuf -i 1-$linesCount -n 1)
	node=$(sed "${randomNum}q;d" ukkonodes)
	echo "$node"
}

sendMouse() {
	node=$(randomNode)
    echo "---------------------------------------"
	echo "Sending mouse to "$node$ukkoLocation
    echo "---------------------------------------"
	ssh $USER"@"$node$ukkoLocation "nohup $currentDir/mouse.sh $currentDir >> /$currentDir/logsMouse.txt 2>&1 &"
}

sendListy() {
	echo "Sending listy to "$listyLocation$ukkoLocation
	ssh $USER"@"$listyLocation$ukkoLocation "nohup $currentDir/listy.sh $currentDir >> /$currentDir/logsListy.txt 2>&1 &"
}

sendCordy() {
	echo "Starting cordy at localhost "localhost
	./cordy.sh $currentDir
}

sendMouse
sendListy
sendCordy
