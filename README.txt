Execute a bash script multiple times with different input in parallel by running

./run.sh /path/to/script.sh /path/to/input.txt <noOfThreads>

Input file should be a set of arguments you want to pass to the script.sh, one set per line.


example:
./run.sh examples/sumOfNumbers/sumOfNumbers.sh examples/sumOfNumbers/input.txt 4

The run script will fork a given number of "threads" (by essentially executing ./thread.sh &). Each "thread" will create a folder for itself and execute the given script with one line from the given input file. When the user script is done, the "thread" will grab the next free input line from the input file. Synchronisation of access is achieved by a lock-file. All output from the user script is collected in the 'standardOutput' folder, and later merged to the allStandardOutput.txt file.

All additional arguments passed to run.sh are expected to be paths to files or folders that will be copied to each of the "thread" folders. This is in case your script needs some additional executables or files. 
For example, if we have the following bash script:

#!/bin/bash
java -jar myCoolJavaThing.jar $1

The "thread" folders should contain the 'myCoolJavaThing.jar' file. To ensure this we can execute the following command:

./run.sh /path/to/script.sh /path/to/input.txt 4 /path/to/myCoolJavaThing.jar
