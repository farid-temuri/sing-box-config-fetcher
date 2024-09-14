#!/bin/sh  
. ./.env

REQUESTED=`curl $CONFIG_URL`
echo $REQUESTED > ./sing-box/config.json