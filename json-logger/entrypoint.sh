#!bin/bash

while [ 1 ]; do
   waitTime=$(shuf -i 1-5 -n 1)
   sleep $waitTime &
   wait $!
   instruction=$(shuf -i 0-4 -n 1)
   d=`date -Iseconds`
   case "$instruction" in
      "1") echo "{\"@timestamp\": \"$d\", \"level\": \"ERROR\", \"message\": \"here's an error message\"}"
      ;;
      "2") echo "{\"@timestamp\": \"$d\", \"level\": \"INFO\", \"message\": \"here's an info message\"}"
      ;;
      "3") echo "{\"@timestamp\": \"$d\", \"level\": \"WARN\", \"message\": \"here's a warning message\"}"
      ;;
      "4") echo "{\"@timestamp\": \"$d\", \"level\": \"DEBUG\", \"message\": \"here's a debug message\", \"debugInfo\": \"a lot of further information\", \"debugObject\": {\"useful\": \"not so much\"}}"
      ;;
   esac
done