#!/bin/bash

CONFIG_PATH="/etc/sing-box/config.json"
CONFIG_URL="${CONFIG_URL:-https://example.com/config.json}"
WEBHOOK_PORT=8080
SECRET_TOKEN="${SECRET_TOKEN:-mysecuretoken}"  # Set your secret token

# Function to fetch the latest configuration
fetch_config() {
    echo "Fetching configuration from $CONFIG_URL..."
    if command -v curl &> /dev/null; then
        curl -sS --fail "$CONFIG_URL" -o "$CONFIG_PATH"
    elif command -v wget &> /dev/null; then
        wget -qO "$CONFIG_PATH" "$CONFIG_URL"
    else
        echo "Error: Neither curl nor wget found!"
        exit 1
    fi
    echo "Configuration updated!"
}

# Fetch config initially
fetch_config

# Start sing-box in the background
sing-box run -c "$CONFIG_PATH" &
SING_BOX_PID=$!

# Function to start the webhook server
start_webhook() {
    echo "Starting webhook server on port $WEBHOOK_PORT..."
    while true; do
        # Listen for an incoming connection (blocks until a request is received)
        REQUEST=$(timeout 10 nc -l -p $WEBHOOK_PORT 2>/dev/null)
        
        # Check if we received a valid request
        if [[ -z "$REQUEST" ]]; then
            continue  # If no request, loop again (avoids spamming)
        fi

        echo "Received request: $REQUEST"

        # Extract token from the request
        if echo "$REQUEST" | grep -q "GET /update?token=$SECRET_TOKEN"; then
            echo "Valid token received. Updating config..."
            fetch_config
            kill -HUP $SING_BOX_PID  # Reload sing-box
            RESPONSE="Config Updated Successfully"
        else
            echo "Unauthorized request!"
            RESPONSE="403 Forbidden: Invalid Token"
        fi

        # Send response
        echo -e "HTTP/1.1 200 OK\nContent-Length: ${#RESPONSE}\n\n$RESPONSE" | nc -l -p $WEBHOOK_PORT
    done
}

# Start webhook if enabled
if [ "$ENABLE_WEBHOOK" = "true" ]; then
    start_webhook
else
    # Keep the script running but don't sleep
    tail -f /dev/null
fi
