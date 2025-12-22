// Handle toolbar button click
browser.browserAction.onClicked.addListener(async (tab) => {
  const url = tab.url;
  
  // Get gateway URL from storage
  const result = await browser.storage.sync.get({
    gatewayUrl: 'http://localhost:8080'
  });
  
  const gatewayUrl = result.gatewayUrl;
  const endpoint = `${gatewayUrl}/send?url=${encodeURIComponent(url)}`;
  
  try {
    // Show loading state
    browser.browserAction.setTitle({ 
      tabId: tab.id,
      title: 'Sending to Kindle...' 
    });
    
    // Send request to gateway
    const response = await fetch(endpoint);
    
    if (response.ok) {
      // Success - show notification
      browser.notifications.create({
        type: 'basic',
        iconUrl: 'icon.png',
        title: 'Sent to Kindle',
        message: 'Article is being sent to your Kindle'
      });
      
      browser.browserAction.setTitle({ 
        tabId: tab.id,
        title: 'Sent to Kindle! ✓' 
      });
      
      // Reset title after 2 seconds
      setTimeout(() => {
        browser.browserAction.setTitle({ 
          tabId: tab.id,
          title: 'Send to Kindle' 
        });
      }, 2000);
    } else {
      throw new Error(`HTTP ${response.status}`);
    }
  } catch (error) {
    console.error('Failed to send to Kindle:', error);
    
    browser.notifications.create({
      type: 'basic',
      iconUrl: 'icon.png',
      title: 'Send to Kindle Failed',
      message: 'Could not send article. Check your gateway URL in settings.'
    });
    
    browser.browserAction.setTitle({ 
      tabId: tab.id,
      title: 'Failed to send ✗' 
    });
    
    // Reset title after 3 seconds
    setTimeout(() => {
      browser.browserAction.setTitle({ 
        tabId: tab.id,
        title: 'Send to Kindle' 
      });
    }, 3000);
  }
});
