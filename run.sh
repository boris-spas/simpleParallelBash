#!/bin/bash
if [ $# -eq 2 ]
  then
    EXEC=$1
    DATA_FILE=$2
    THREAD_COUNT=1
  else
    EXEC=$1
    DATA_FILE=$2
    THREAD_COUNT=$3
fi
echo 0 > file.txt
echo ""
echo "Spawning "$THREAD_COUNT" Threads"
echo ""
for i in $(seq 1 $THREAD_COUNT)
do
	./thread.sh $i $EXEC $DATA_FILE&
done
wait 
rm file.txt
echo ''
echo 'Reducing all standard output to one file'
cat standardOutput/* > allStandardOutput.txt
echo ''
echo 'All threads done!'
