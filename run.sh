#!/bin/sh  

SECONDS_TO_SLEEP=1
CONFIG_URL=localhost:3000/config?asd=ass

while true  
do  
	REQUESTED=`curl $CONFIG_URL`
	echo $REQUESTED > ./sing-box/config.json
	echo $REQUESTED
  sleep $SECONDS_TO_SLEEP
done