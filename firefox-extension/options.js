// Load saved settings
async function loadOptions() {
  const result = await browser.storage.sync.get({
    gatewayUrl: 'http://localhost:8080'
  });
  document.getElementById('gatewayUrl').value = result.gatewayUrl;
}

// Save settings
async function saveOptions() {
  const gatewayUrl = document.getElementById('gatewayUrl').value;
  
  await browser.storage.sync.set({
    gatewayUrl: gatewayUrl
  });
  
  // Show status message
  const status = document.getElementById('status');
  status.style.display = 'block';
  setTimeout(() => {
    status.style.display = 'none';
  }, 2000);
}

document.addEventListener('DOMContentLoaded', loadOptions);
document.getElementById('save').addEventListener('click', saveOptions);
