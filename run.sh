#!/bin/sh  

SECONDS_TO_SLEEP=3600
CONFIG_URL=localhost:3000/config/ne?asd=ass

while true
do
	REQUESTED=`curl $CONFIG_URL`
	echo $REQUESTED > ./sing-box/config.json
	`docker compose down`
	`docker compose up`
  sleep $SECONDS_TO_SLEEP
done
