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
    echo "Usage: /send?url=https://example.com/article"
    echo "[send.sh] ERROR: Missing URL parameter" >&2
    exit 1
fi

# Execute kindle-send
echo "Processing URL: $URL"
echo "---"
echo "[send.sh] Executing kindle-send with URL: $URL" >&2
/kindle-send --config /config/config.json send "$URL" 2>&1 || {
    echo "Error executing kindle-send"
    echo "[send.sh] ERROR: kindle-send failed" >&2
    exit 1
}

echo "[send.sh] Success" >&2
