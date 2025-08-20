// 广告管理模块使用示例

// 1. 基本使用 - 插入单个广告
AdManager.insertAd(document.getElementById('ad-container'), 'top');

// 2. 批量插入多个广告
AdManager.insertMultipleAds([
    { container: document.getElementById('top-ad'), slotType: 'top' },
    { container: document.getElementById('bottom-ad'), slotType: 'bottom' },
    { container: document.getElementById('center-ad'), slotType: 'center' }
]);

// 3. 更新广告配置
AdManager.updateConfig({
    publisherId: 'ca-pub-1234567890123456',
    adSlots: {
        top: '1234567890',
        bottom: '0987654321',
        center: '1122334455',
        banner: '5566778899'
    }
});

// 4. 在Vue组件中使用
new Vue({
    el: '#app',
    mounted() {
        // 插入顶部广告
        AdManager.insertAd(this.$refs.topAd, 'top');
        
        // 插入底部广告
        AdManager.insertAd(this.$refs.bottomAd, 'bottom');
    }
});

// 5. 动态更新广告配置
function updateAdConfig(newPublisherId, newAdSlots) {
    AdManager.updateConfig({
        publisherId: newPublisherId,
        adSlots: newAdSlots
    });
}

// 6. 获取当前配置
console.log('当前广告配置:', AdManager.getConfig());

// 7. 条件插入广告
function insertAdConditionally(container, slotType, condition) {
    if (condition) {
        AdManager.insertAd(container, slotType);
    }
}

// 8. 延迟插入广告
function insertAdWithDelay(container, slotType, delay) {
    setTimeout(() => {
        AdManager.insertAd(container, slotType);
    }, delay);
}
