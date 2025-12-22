# Send to Kindle - Firefox Extension

A simple Firefox extension to send the current page to your Kindle with one click.

## Installation

### Temporary Installation (for testing)

1. Open Firefox and navigate to `about:debugging`
2. Click "This Firefox" in the left sidebar
3. Click "Load Temporary Add-on"
4. Navigate to this `firefox-extension` folder and select `manifest.json`

### Permanent Installation (unsigned)

Firefox requires extensions to be signed. For personal use:

1. Open `about:config` in Firefox
2. Set `xpinstall.signatures.required` to `false`
3. Zip the extension folder contents (not the folder itself)
4. Drag and drop the zip file into Firefox

### Publishing to Mozilla Add-ons

To use the extension permanently:

1. Create a zip file of the extension contents
2. Submit to [addons.mozilla.org](https://addons.mozilla.org/developers/)
3. Wait for review and approval

## Configuration

1. Click the extension icon in the toolbar
2. Click the gear icon or go to Add-ons → Send to Kindle → Options
3. Set your Gateway URL (default: `http://localhost:8080`)

## Usage

1. Navigate to any article/webpage you want to send to your Kindle
2. Click the "Send to Kindle" button in the toolbar
3. You'll get immediate feedback:
   - **Browser notification** - "Article is being sent to your Kindle" on success
   - **Button title** changes to show status:
     - "Sending to Kindle..." - Request in progress
     - "Sent to Kindle! ✓" - Successfully sent
     - "Failed to send ✗" - Error occurred (check gateway URL in settings)

## How It Works

The extension sends the current page URL to your Kindle Send Gateway at `/send?url=<current-page-url>`. The gateway then processes the article and sends it to your configured Kindle email.
