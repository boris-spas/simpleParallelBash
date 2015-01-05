#!/bin/bash
#usage ./thread threadId limit

TMP_OS=`uname | tr "[:upper:]" "[:lower:]"`
if [[ "{$TMP_OS}" = *darwin* ]]; then
    LOCK='lockfile ../lock.lock'
    UNLOCK='rm -f ../lock.lock'
elif [[ "{$TMP_OS}" = *linux* ]]; then
    LOCK='lockfile-create ../lock'
    UNLOCK='lockfile-remove ../lock'
fi

ID=$1
if [[ "$2" = /* ]]
then
   : # Absolute path
   EXEC=$2
else
   : # Relative path
   EXEC=`pwd`/$2
fi

if [[ "$3" = /* ]]
then
   : # Absolute path
   DATA_FILE=$3
else
   : # Relative path
   DATA_FILE=`pwd`/$3
fi
LIMIT=`awk 'END{print NR}' $DATA_FILE`
COUNTER='../syncedCount.txt'
mkdir $1
cd $1
while :
do
  $LOCK
  index=`cat $COUNTER`
  echo "Thread $1 says: old index value: "$index
  index=$(($index+1))
  echo "Thread $ID says: new index value: "$index
  echo $index > $COUNTER
  $UNLOCK
  if [ "$index" -le "$LIMIT" ]; then
	WORK_LOAD=`sed -n \`echo $index\`p < $DATA_FILE`
	echo "Thread $ID says: working on "$WORK_LOAD
        echo ""
	sh $EXEC $WORK_LOAD > "../standardOutput/$WORK_LOAD.txt" 2>&1
  else
	echo "Thread $ID done, no more work"
	echo ""
	cd ..
	rm -rf $1
	exit
  fi
done

