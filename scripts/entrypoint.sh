#!/bin/bash

# Install required packages
if command -v apt &> /dev/null; then
    apt update && apt install -y curl cron
elif command -v apk &> /dev/null; then
    apk add --no-cache curl dcron
elif command -v yum &> /dev/null; then
    yum install -y curl cronie
fi

# Create cron job to run at 00:00 +3 GMT
echo "0 0 * * * /bin/bash /scripts/start-sing-box.sh" > /etc/crontabs/root

# Start cron service
if command -v crond &> /dev/null; then
    crond -b
elif command -v cron &> /dev/null; then
    cron
fi

# Execute the main script
exec /bin/bash /scripts/start-sing-box.sh
