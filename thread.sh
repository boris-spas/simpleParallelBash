#!/bin/bash
#usage ./thread threadId limit
COUNTER='file.txt'
ID=$1
EXEC=$2
DATA_FILE=$3
LIMIT=`awk 'END{print NR}' $DATA_FILE`
while :
do
  lockfile-create lock
  index=`cat $COUNTER`
  echo "Thread $1 sais: old index value: "$index
  index=$(($index+1))
  echo "Thread $ID sais: new index value: "$index
  echo $index > $COUNTER
  lockfile-remove lock 
  if [ "$index" -lt "$LIMIT" ]; then
	WORK_LOAD=`sed -n \`echo $index\`p < $DATA_FILE`
	echo "Thread $ID sais: working on "$WORK_LOAD
        echo ""
	$EXEC $WORK_LOAD > "standardOutput/$WORK_LOAD.txt"
  else
	echo "Thread $ID done, no more work"
	echo ""
	exit
  fi
done
