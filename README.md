# Kindle Send Gateway

An nginx-based HTTP gateway wrapper for [kindle-send](https://github.com/nikhil1raghav/kindle-send) that allows you to send articles to your Kindle via a simple HTTP endpoint.

## Features

- HTTP endpoint `/send?url=<article-url>` to send articles to Kindle
- Health check endpoint `/health` for monitoring
- Dockerized setup with nginx and fcgiwrap
- Easy configuration via JSON file

## Setup

### 1. Configure

Edit `config/config.json` with your credentials:

```json
{
  "sender": "your-email@gmail.com",
  "receiver": "your-kindle-email@kindle.com",
  "storepath": "/data",
  "password": "your-app-password",
  "server": "smtp.gmail.com",
  "port": 465
}
```

**Note:** Use an [App Password](https://support.google.com/accounts/answer/185833) for Gmail, not your regular password.

### 2. Build

```bash
docker build -t kindle-send-gateway .
```

### 3. Run

```bash
docker run -d \
  -p 8080:80 \
  -v ./config:/config \
  -v ./data:/data \
  --name kindle-gateway \
  kindle-send-gateway
```

## Usage

### Send an article to Kindle

```bash
curl "http://localhost:8080/send?url=https://zapier.com/blog/zapier-journey-beyond-ingress-nginx/"
```

### Health check

```bash
curl http://localhost:8080/health
```

## Example

Send a blog post to your Kindle:

```bash
curl "http://localhost:8080/send?url=https://example.com/article"
```

The service will:
1. Download the article
2. Convert it to Kindle-friendly format
3. Email it to your Kindle device

## Architecture

- **nginx**: HTTP server that handles incoming requests
- **fcgiwrap**: FastCGI wrapper for executing shell scripts
- **send.sh**: CGI script that parses the URL parameter and calls kindle-send
- **kindle-send**: The underlying tool that does the actual conversion and sending
