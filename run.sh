#!/bin/sh  
. ./.env

while true
do
	REQUESTED=`curl $CONFIG_URL`
	echo $REQUESTED > ./sing-box/config.json
	`docker compose down`
	`docker compose up -d`
  sleep $DELAY_IN_SECONDS
done
