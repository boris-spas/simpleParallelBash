Run bash processes in parallel by running

./run.sh /path/to/script.sh /path/to/input.txt <noOfThreads>

Input file should be a set of arguments you want to pass to the script.sh, one set per line.


example:
./run.sh examples/sumOfNumbers/sumOfNumbers.sh examples/sumOfNumbers/input.txt 4

