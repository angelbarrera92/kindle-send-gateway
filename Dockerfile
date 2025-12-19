FROM alpine as builder

RUN apk add curl ca-certificates tar

RUN curl -LO https://github.com/nikhil1raghav/kindle-send/releases/download/v2.0.0-rc-2/kindle-send_2.0.0-rc-2_linux_amd64.tar.gz && \
    tar -xvf kindle-send_2.0.0-rc-2_linux_amd64.tar.gz


FROM alpine:latest

# Install nginx, fcgiwrap, and spawn-fcgi
RUN apk add --no-cache nginx fcgiwrap spawn-fcgi bash

# Copy kindle-send binary from builder
COPY --from=builder /kindle-send /kindle-send

# Copy nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy CGI script
COPY send.sh /app/send.sh
RUN chmod +x /app/send.sh

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Create necessary directories and set permissions
RUN mkdir -p /var/log/nginx /var/run /config /data && \
    chown -R nginx:nginx /var/log/nginx /var/run /app && \
    chmod 755 /var/run

VOLUME /config
VOLUME /data

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]