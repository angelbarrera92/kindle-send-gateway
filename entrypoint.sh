#!/bin/sh
set -e

echo "[entrypoint] Starting fcgiwrap..."
# Start fcgiwrap using spawn-fcgi
spawn-fcgi -s /var/run/fcgiwrap.socket -f /usr/bin/fcgiwrap -u nginx -g nginx

# Wait for socket to be created
echo "[entrypoint] Waiting for fcgiwrap socket..."
for i in 1 2 3 4 5; do
    if [ -S /var/run/fcgiwrap.socket ]; then
        echo "[entrypoint] fcgiwrap socket ready"
        break
    fi
    sleep 1
done

# Set proper permissions
chmod 666 /var/run/fcgiwrap.socket

echo "[entrypoint] Starting nginx..."
# Start nginx in the foreground
exec nginx -g 'daemon off;'
