#!/bin/bash

# Install curl if not installed
if ! command -v curl &> /dev/null; then
    echo "Installing curl..."
    apt update && apt install -y curl || apk add --no-cache curl || yum install -y curl
fi

# Execute the main script
exec /bin/bash /scripts/start-sing-box.sh
