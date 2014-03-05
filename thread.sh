#!/bin/bash
#usage ./thread threadId limit

TMP_OS=`uname | tr "[:upper:]" "[:lower:]"`
if [[ "{$TMP_OS}" = *darwin* ]]; then
    LOCK='lockfile lock.lock'
    UNLOCK='rm -f lock.lock'
elif [[ "{$TMP_OS}" = *linux* ]]; then
    LOCK='lockfile-create lock'
    UNLOCK='lockfile-remove lock'
fi

ID=$1
EXEC=$2
DATA_FILE=$3
LIMIT=`awk 'END{print NR}' $DATA_FILE`
COUNTER='syncedCount.txt'
while :
do
  $LOCK
  index=`cat $COUNTER`
  echo "Thread $1 sais: old index value: "$index
  index=$(($index+1))
  echo "Thread $ID sais: new index value: "$index
  echo $index > $COUNTER
  $UNLOCK
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
