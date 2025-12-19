#!/bin/sh
set -e

# Start fcgiwrap in the background
fcgiwrap -s unix:/var/run/fcgiwrap.socket &

# Give fcgiwrap a moment to start
sleep 1

# Start nginx in the foreground
exec nginx -g 'daemon off;'
