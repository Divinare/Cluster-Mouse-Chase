#!/bin/bash

ukkoLocation=".hpc.cs.helsinki.fi"

while IFS='' read -r line || [[ -n "$line" ]]; do
        echo "node: "$line$ukkoLocation

        nohup ssh $USER@$line$ukkoLocation <<'ENDSSH'
                pkill mouse.sh -x -u $USER
                pkill nc -x -u $USER
ENDSSH
done < "ukkonodes"

listyLocation=$(head -n 1 listy_location)
nohup ssh $USER@$listyLocation$ukkoLocation <<'ENDSSH'
        pkill listy.sh -x -u $USER
        pkill nc -x -u $USER
ENDSSH

exit
