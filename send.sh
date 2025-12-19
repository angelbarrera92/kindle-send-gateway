#!/bin/sh

# Log to stderr for debugging
echo "[send.sh] Script started - QUERY_STRING=$QUERY_STRING" >&2

# Parse query string to get URL parameter
URL=""
if [ -n "$QUERY_STRING" ]; then
    # Decode URL parameter from query string
    URL=$(echo "$QUERY_STRING" | sed -n 's/^.*url=\([^&]*\).*$/\1/p' | sed 's/%20/ /g; s/%3A/:/g; s/%2F/\//g; s/%3F/?/g; s/%3D/=/g; s/%26/\&/g')
fi

echo "[send.sh] Parsed URL: $URL" >&2

# HTTP headers
echo "Content-Type: text/plain"
echo ""

# Validate URL parameter
if [ -z "$URL" ]; then
    echo "Error: Missing 'url' parameter"
    echo "[send.sh] ERROR: Missing URL parameter" >&2
    exit 1
fi

# Send simple response to client
echo "Request accepted. Processing URL: $URL"

# Execute kindle-send (redirect output to container's main stderr)
echo "[send.sh] Executing kindle-send with URL: $URL" > /proc/1/fd/2
/kindle-send --config /config/config.json send "$URL" 2>&1 | while IFS= read -r line; do
    echo "[kindle-send] $line" > /proc/1/fd/2
done
STATUS=${PIPESTATUS[0]}

if [ $STATUS -ne 0 ]; then
    echo "[send.sh] ERROR: kindle-send failed with exit code $STATUS" > /proc/1/fd/2
    exit 1
fi

echo "[send.sh] Success - Article sent to Kindle" > /proc/1/fd/2
