#!/bin/sh
set -e

echo "[entrypoint] Fixing permissions..."
# Ensure config files are readable by nginx user
if [ -f /config/config.json ]; then
    chown nginx:nginx /config/config.json
    chmod 644 /config/config.json
    echo "[entrypoint] Config file permissions fixed"
else
    echo "[entrypoint] WARNING: /config/config.json not found"
fi

# Ensure data directory is writable by nginx user
chown -R nginx:nginx /data 2>/dev/null || true
chmod 755 /data 2>/dev/null || true

echo "[entrypoint] Starting fcgiwrap..."
# Start fcgiwrap using spawn-fcgi as root (to access mounted volumes)
spawn-fcgi -s /var/run/fcgiwrap.socket -f /usr/bin/fcgiwrap

# Wait for socket to be created
echo "[entrypoint] Waiting for fcgiwrap socket..."
for i in 1 2 3 4 5; do
    if [ -S /var/run/fcgiwrap.socket ]; then
        echo "[entrypoint] fcgiwrap socket ready"
        break
    fi
    sleep 1
done

# Set proper permissions so nginx can connect to the socket
chmod 666 /var/run/fcgiwrap.socket

echo "[entrypoint] Starting nginx..."
# Start nginx in the foreground
exec nginx -g 'daemon off;'
