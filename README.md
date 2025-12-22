# Kindle Send Gateway

An nginx-based HTTP gateway wrapper for [kindle-send](https://github.com/nikhil1raghav/kindle-send) that allows you to send articles to your Kindle via a simple HTTP endpoint.

## Features

- HTTP endpoint `/send?url=<article-url>` to send articles to Kindle
- Health check endpoint `/health` for monitoring
- Comprehensive logging with prefixed output for easy debugging
- Dockerized setup with nginx and fcgiwrap
- Easy configuration via JSON file

## Setup

### Option 1: Using the Public Docker Image (Recommended)

The Docker image is automatically built and pushed to GitHub Container Registry with each push to main.

```bash
docker run -d \
  -p 8080:80 \
  -v ./config:/config \
  -v ./data:/data \
  --name kindle-gateway \
  ghcr.io/yourusername/kindle-send-gateway:latest
```

Replace `yourusername` with the actual repository owner.

### Option 2: Build Locally

#### 1. Configure

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

#### 2. Build

```bash
docker build -t kindle-send-gateway .
```

#### 3. Run

```bash
docker run -d \
  -p 8080:80 \
  -v ./config:/config \
  -v ./data:/data \
  --name kindle-gateway \
  kindle-send-gateway
```

## Usage

### Firefox Extension (Recommended)

The easiest way to send articles to your Kindle is using the Firefox extension. Simply click a button on any webpage to send it to your Kindle.

**Installation:**
1. Open Firefox and go to `about:debugging`
2. Click "This Firefox" → "Load Temporary Add-on"
3. Navigate to the `firefox-extension` folder and select `manifest.json`
4. Configure your gateway URL in the extension settings (right-click icon → Manage Extension → Options)

**Using the extension:**
- Click the extension icon in your toolbar while viewing any article
- You'll get a browser notification when the article is being sent
- Check your Kindle device in a few minutes

See [firefox-extension/README.md](firefox-extension/README.md) for more details.

### Send an article to Kindle

```bash
curl "http://localhost:8080/send?url=https://zapier.com/blog/zapier-journey-beyond-ingress-nginx/"
```

The client will receive a quick acknowledgment:
```
Request accepted. Processing URL: https://zapier.com/blog/zapier-journey-beyond-ingress-nginx/
```

### Monitor logs

View detailed processing logs on the server:

```bash
docker logs -f kindle-gateway
```

Logs are prefixed for easy identification:
- `[entrypoint]` - Container startup messages
- `[send.sh]` - Request handling
- `[kindle-send]` - Article processing and sending
- `[nginx]` - HTTP access logs

Example log output:
```
[entrypoint] Starting nginx...
[send.sh] Executing kindle-send with URL: https://example.com/article
[kindle-send] Loaded configuration
[kindle-send] Fetched https://example.com/article --> Article Title
[kindle-send] Downloading Images
[kindle-send] Mail sent successfully
[nginx] 192.168.1.23 - - [19/Dec/2025:12:48:38 +0000] "GET /send?url=..." 200 106 "-" "curl/8.7.1" "-"
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

## CI/CD Pipeline

This project uses GitHub Actions to automatically build and publish Docker images to [GitHub Container Registry](https://github.com/features/packages).

### Image Tags

When you push to the repository, images are tagged based on the context:

- **Main branch**: `latest`, `main`, `<commit-sha>`
- **Version tags**: `v*` (semantic versioning, e.g., `v1.0.0`, `1.0`)
- **Feature branches**: `<branch-name>-<commit-sha>` (build only, no push)
- **Pull Requests**: `pr-<PR-number>`, `<commit-sha>` (push enabled for same-repo PRs only)

### Build Behavior

- **Main branch & version tags**: Builds and pushes images to registry with registry-based caching
- **Pull Requests** (same repo): Builds and pushes images for testing with `pr-<number>` tag
- **Pull Requests** (forks): Build only, no push (security-restricted)
- **Feature branches**: Build only, no push (to validate changes)
- **Workflow dispatch**: Manual trigger available (requires explicit authorization)

### Example Usage with Public Images

```bash
# Use the latest version
docker pull ghcr.io/username/kindle-send-gateway:latest

# Use a specific version
docker pull ghcr.io/username/kindle-send-gateway:v1.0.0

# Use a PR image for testing
docker pull ghcr.io/username/kindle-send-gateway:pr-42

# Use a specific commit
docker pull ghcr.io/username/kindle-send-gateway:main-abc123def456
```

### Security

- Docker image pushes are restricted to this repository only
- Fork pull requests cannot push images to the registry
- Feature branches only build images locally (no registry push)
- All pushes require proper authentication to GitHub Container Registry
