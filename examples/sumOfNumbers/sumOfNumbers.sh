#!/bin/bash
SUM=0
COUNTER=1
NUM=$1 
while [  $COUNTER -lt $NUM ]
do
	let SUM=SUM+COUNTER
	let COUNTER=COUNTER+1 
done
echo "The sum of the first $NUM numbers is $SUM, received $# args"
