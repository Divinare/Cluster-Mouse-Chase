#!/bin/bash

ukkoLocation=".hpc.cs.helsinki.fi"

path=$1
cd $path

# Status
nodesVisited=0
catsThatHaveFoundMouse=0
mouseFoundAtNode="empty"
mouseFound=false

# Sends the cat to search the next node
# $1=catName S=search command
sendCatToSearchNextNode() {
   node=$(sed "${nodesVisited}q;d" ukkonodes)
   echo "Sending $1 to Search $node"
   ssh $node$ukkoLocation "nohup /$path/chase_cat.sh $path $1 S $node >> /$path/logs$1.txt 2>&1 &"
}

# $1=catName S=search command $2=targetNode
sendCatToSearchNode() {
   node=$2
   echo "Sending $1 to Search $node"
   ssh $node$ukkoLocation "nohup /$path/chase_cat.sh $path $1 S $node >> /$path/logs$S1.txt 2>&1 &"
}

# $1=catName $2=targetNode A=attack command
sendCatToAttackMouse() {
   echo "Sending $1 to Attack $2"
   ssh $2$ukkoLocation "nohup /$path/chase_cat.sh $path $1 A $2 >> /$path/logs$1.txt 2>&1 &"
}

sendDifferentCatToNode() {
    catName=$1
    targetNode=$2
    if [ "$catName" == "Catty" ]
    then
        echo "Sending Jazzy to also search the same mouse"
        sendCatToSearchNode "Jazzy" $targetNode
    else
          echo "Sending Catty to also search the same mouse"
         sendCatToSearchNode "Catty" $targetNode
    fi
}

executeCommand() {
   command=$1
   targetNode=$2
   catName=$3

   if [ "$command" == "F" ]
   then
       catsThatHaveFoundMouse=$((catsThatHaveFoundMouse+1))
   fi

   if [ -n $targetNode ]
   then
      echo "The target node was empty, do nothing"
   else
      firstNodeAt=1
      firstNode=$(sed "${firstNodeAt}q;d" ukkonodes)
	  echo "Sending $catName to search first node because he has nothing to do otherwise"
      sendCatToSearchNode $catName $firstNode
   fi

   if [ "$mouseFound" = true ]
   then
       if [ $catsThatHaveFoundMouse -eq 2 ]
       then
             echo "Both of the cats have found the mouse!";
             sendCatToAttackMouse $catName $mouseFoundAtNode
       else
             sendDifferentCatToNode $catName $targetNode
       fi

   else
        if [ "$command" == "F" ]
        then
             mouseFound=true
             mouseFoundAtNode=$targetNode
             sendDifferentCatToNode $catName $targetNode
         fi
    fi

    if [ "$command" == "N" ]
    then
         nodesVisited=$((nodesVisited+1))
	     sendCatToSearchNextNode $catName
    fi

    if [ "$command" == "G"  ]
    then
	     echo "The mouse has been killed. Our job here is done."
         exit;
     fi

}

nextCommandAt=1
start() {
    nodesVisited=$((nodesVisited+1))
	sendCatToSearchNextNode "Catty"
    sleep 4
    nodesVisited=$((nodesVisited+1))
    sendCatToSearchNextNode "Jazzy"
    sleep 4
	while true
	do
        commandLine=$(sed "${nextCommandAt}q;d" cmsg)
		# if a commandLine is empty/null
        if [[ -n $commandLine ]]
        then
              echo "##################################################"
              echo " "
              echo $commandLine
              echo " "
              echo "##################################################"
              commandArray=( $commandLine )
              command=${commandArray[0]}
              targetNode=${commandArray[1]}
              catName=${commandArray[2]}
  	    	  executeCommand $command $targetNode $catName
		      nextCommandAt=$(($nextCommandAt+1))
              sleep 4 # Cordy sleeps if a command is ran
         else
              echo "The command was empty."
         fi
         sleep 4 # Cordy sleeps 4 seconds before checking cmsg again
	done
}

start # Starts the whole cordy process

echo "Exiting"

exit
