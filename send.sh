#!/bin/sh
set -e

# Parse query string to get URL parameter
URL=""
if [ -n "$QUERY_STRING" ]; then
    # Decode URL parameter from query string
    URL=$(echo "$QUERY_STRING" | sed -n 's/^.*url=\([^&]*\).*$/\1/p' | sed 's/%20/ /g; s/%3A/:/g; s/%2F/\//g; s/%3F/?/g; s/%3D/=/g; s/%26/\&/g')
fi

# HTTP headers
echo "Content-Type: text/plain"
echo ""

# Validate URL parameter
if [ -z "$URL" ]; then
    echo "Error: Missing 'url' parameter"
    echo "Usage: /send?url=https://example.com/article"
    exit 1
fi

# Execute kindle-send
echo "Processing URL: $URL"
echo "---"
/kindle-send --config /config/config.json send "$URL" 2>&1 || {
    echo "Error executing kindle-send"
    exit 1
}
