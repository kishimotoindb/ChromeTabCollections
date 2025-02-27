document.addEventListener('DOMContentLoaded', () => {
  // 获取DOM元素
  const saveTabsBtn = document.getElementById('saveTabsBtn');
  const collectionNameInput = document.getElementById('collectionName');
  const collectionsContainer = document.getElementById('collections');
  
  // 加载已保存的标签页集合
  loadSavedCollections();
  
  // 保存当前标签页集合
  saveTabsBtn.addEventListener('click', () => {
    const collectionName = collectionNameInput.value.trim() || `标签集合 ${new Date().toLocaleString()}`;
    
    // 获取当前窗口的所有标签页
    chrome.tabs.query({ currentWindow: true }, (tabs) => {
      const tabsData = tabs.map(tab => ({
        url: tab.url,
        title: tab.title,
        favicon: tab.favIconUrl
      }));
      
      // 创建集合对象
      const collection = {
        id: Date.now().toString(),
        name: collectionName,
        date: new Date().toISOString(),
        tabCount: tabsData.length,
        tabs: tabsData
      };
      
      // 保存到存储
      saveCollection(collection);
      
      // 清空输入框
      collectionNameInput.value = '';
    });
  });
  
  // 加载已保存的标签页集合
  function loadSavedCollections() {
    chrome.storage.local.get('tabCollections', (data) => {
      const collections = data.tabCollections || [];
      
      if (collections.length === 0) {
        collectionsContainer.innerHTML = '<p class="empty-message">还没有保存的标签页集合</p>';
        return;
      }
      
      // 按日期降序排序（最新的在最前面）
      collections.sort((a, b) => new Date(b.date) - new Date(a.date));
      
      // 清空容器
      collectionsContainer.innerHTML = '';
      
      // 渲染集合列表
      collections.forEach(collection => {
        const collectionElement = createCollectionElement(collection);
        collectionsContainer.appendChild(collectionElement);
      });
    });
  }
  
  // 创建集合元素
  function createCollectionElement(collection) {
    const collectionItem = document.createElement('div');
    collectionItem.className = 'collection-item';
    collectionItem.dataset.id = collection.id;
    
    const collectionDate = new Date(collection.date);
    const formattedDate = collectionDate.toLocaleString();
    
    collectionItem.innerHTML = `
      <div class="collection-info">
        <div class="collection-title">${collection.name}</div>
        <div class="collection-date">${formattedDate}</div>
      </div>
      <span class="tab-count">${collection.tabCount}个标签页</span>
      <div class="collection-actions">
        <button class="action-btn open" title="打开此集合">📂</button>
        <button class="action-btn delete" title="删除此集合">🗑️</button>
      </div>
    `;
    
    // 打开标签页集合
    collectionItem.querySelector('.open').addEventListener('click', () => {
      openTabCollection(collection);
    });
    
    // 删除标签页集合
    collectionItem.querySelector('.delete').addEventListener('click', () => {
      deleteTabCollection(collection.id);
      collectionItem.remove();
      
      // 如果没有集合了，显示空消息
      if (collectionsContainer.children.length === 0) {
        collectionsContainer.innerHTML = '<p class="empty-message">还没有保存的标签页集合</p>';
      }
    });
    
    return collectionItem;
  }
  
  // 保存集合到存储
  function saveCollection(collection) {
    chrome.storage.local.get('tabCollections', (data) => {
      const collections = data.tabCollections || [];
      collections.push(collection);
      
      chrome.storage.local.set({ tabCollections: collections }, () => {
        // 添加新集合到UI
        const collectionElement = createCollectionElement(collection);
        
        // 移除空消息（如果有的话）
        const emptyMessage = collectionsContainer.querySelector('.empty-message');
        if (emptyMessage) {
          emptyMessage.remove();
        }
        
        // 添加到列表顶部
        collectionsContainer.insertBefore(collectionElement, collectionsContainer.firstChild);
      });
    });
  }
  
  // 打开标签页集合
  function openTabCollection(collection) {
    // 发送消息给后台脚本，请求打开标签页集合
    chrome.runtime.sendMessage({
      action: 'openTabCollection',
      collection: collection
    });
    
    // 关闭弹出窗口
    window.close();
  }
  
  // 删除标签页集合
  function deleteTabCollection(collectionId) {
    chrome.storage.local.get('tabCollections', (data) => {
      let collections = data.tabCollections || [];
      collections = collections.filter(c => c.id !== collectionId);
      
      chrome.storage.local.set({ tabCollections: collections });
    });
  }
}); 