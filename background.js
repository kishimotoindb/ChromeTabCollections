// 监听来自弹出页面的消息
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.action === 'openTabCollection') {
    openTabCollection(message.collection);
  }
});

// 打开标签页集合
function openTabCollection(collection) {
  // 在当前窗口中打开集合中的标签页
  chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
    // 获取当前窗口的ID
    const currentWindowId = tabs[0].windowId;
    
    // 为集合中的每个标签页创建新标签页
    collection.tabs.forEach((tab, index) => {
      chrome.tabs.create({
        windowId: currentWindowId,
        url: tab.url,
        active: false // 不激活新创建的标签页，保持当前标签页的焦点
      });
    });
  });
} 