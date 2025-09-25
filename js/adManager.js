

// 广告管理模块
const AdManager = {
    // 广告配置
    config: {
        publisherId: 'ca-pub-8306112973766890',
        adSlots: {
            top: '9991062085',        // 请替换为您的顶部广告位ID
            bottom: '1130662885',     // 请替换为您的底部广告位ID
            center: '9994382779',     // 请替换为您的中央广告位ID
            banner: '5069359150'      // 请替换为您的横幅广告位ID
        }
    },

    // 生成广告HTML代码
    generateAdHTML: function(slotType) {
        const slotId = this.config.adSlots[slotType];
        if (!slotId) {
            console.error('未找到广告位配置:', slotType);
            return '';
        }
        
        return `<ins class="adsbygoogle" style="display:block" data-ad-client="${this.config.publisherId}" data-ad-slot="${slotId}" data-ad-format="auto" data-full-width-responsive="true"></ins>`;
    },

    // 生成广告脚本代码
    generateAdScript: function() {
        return '(adsbygoogle = window.adsbygoogle || []).push({});';
    },

    // 插入广告到指定容器
    insertAd: function(containerRef, slotType, delay = 16) {
        if (!containerRef) {
            console.error('容器引用不存在');
            return;
        }

        const adHTML = this.generateAdHTML(slotType);
        const adScript = this.generateAdScript();

        // 设置HTML内容
        if (containerRef.innerHTML !== undefined) {
            containerRef.innerHTML = adHTML;
        }

        // 延迟插入脚本
        setTimeout(() => {
            const scriptElement = document.createElement('script');
            scriptElement.innerHTML = adScript;
            containerRef.appendChild(scriptElement);
        }, delay);
    },

    // 批量插入多个广告
    insertMultipleAds: function(adConfigs, delay = 16) {
        adConfigs.forEach((config, index) => {
            setTimeout(() => {
                this.insertAd(config.container, config.slotType, 0);
            }, delay * index);
        });
    },

    // 更新广告配置
    updateConfig: function(newConfig) {
        this.config = { ...this.config, ...newConfig };
    },

    // 获取广告配置
    getConfig: function() {
        return this.config;
    }
};

// 导出模块
if (typeof module !== 'undefined' && module.exports) {
    module.exports = AdManager;
}
