# Google AdSense 广告配置指南

## 📋 配置步骤

### 1. 获取您的广告位ID

1. **登录Google AdSense控制台**
   - 访问：https://www.google.com/adsense
   - 使用您的Google账户登录

2. **创建广告单元**
   - 在左侧菜单中点击"广告" → "广告单元"
   - 点击"创建新广告单元"
   - 选择广告类型（推荐：显示广告）

3. **配置广告单元**
   - 输入广告单元名称（如：顶部广告、底部广告等）
   - 选择广告尺寸（推荐：响应式）
   - 点击"保存并获取代码"

4. **复制广告代码**
   - 系统会生成类似以下的代码：
   ```html
   <ins class="adsbygoogle"
        style="display:block"
        data-ad-client="ca-pub-8306112973766890"
        data-ad-slot="1234567890"
        data-ad-format="auto"
        data-full-width-responsive="true"></ins>
   <script>
        (adsbygoogle = window.adsbygoogle || []).push({});
   </script>
   ```

5. **提取广告位ID**
   - 从代码中提取 `data-ad-slot` 的值
   - 例如：`data-ad-slot="1234567890"` 中的 `1234567890` 就是广告位ID

### 2. 更新配置文件

编辑 `js/adManager.js` 文件，将您的实际广告位ID替换占位符：

```javascript
config: {
    publisherId: 'ca-pub-8306112973766890',  // ✅ 已配置
    adSlots: {
        top: '您的顶部广告位ID',        // 替换 1234567890
        bottom: '您的底部广告位ID',     // 替换 0987654321
        center: '您的中央广告位ID',     // 替换 1122334455
        banner: '您的横幅广告位ID'      // 替换 5566778899
    }
}
```

### 3. 创建不同广告位的建议

| 广告位类型 | 建议尺寸 | 用途 |
|-----------|---------|------|
| top (顶部) | 728x90 或响应式 | 页面顶部横幅 |
| bottom (底部) | 728x90 或响应式 | 页面底部横幅 |
| center (中央) | 300x250 或响应式 | 内容区域侧边 |
| banner (横幅) | 320x50 或响应式 | 移动端横幅 |

### 4. 测试配置

1. **检查控制台**
   - 打开浏览器开发者工具
   - 查看Console是否有错误信息

2. **验证广告显示**
   - 确保广告正确加载
   - 检查广告尺寸是否合适

3. **测试响应式**
   - 在不同设备上测试
   - 确保广告在不同屏幕尺寸下正常显示

## 🔧 高级配置

### 动态更新配置

```javascript
// 在页面加载时动态更新配置
AdManager.updateConfig({
    adSlots: {
        top: '新的顶部广告位ID',
        bottom: '新的底部广告位ID'
    }
});
```

### 条件插入广告

```javascript
// 根据条件决定是否显示广告
if (shouldShowAd) {
    AdManager.insertAd(container, 'top');
}
```

### 批量插入广告

```javascript
// 一次性插入多个广告
AdManager.insertMultipleAds([
    { container: topContainer, slotType: 'top' },
    { container: bottomContainer, slotType: 'bottom' }
]);
```

## ⚠️ 注意事项

1. **广告位ID唯一性**：每个广告位ID只能在一个地方使用
2. **发布商ID**：确保所有广告使用相同的发布商ID
3. **代码完整性**：不要修改生成的广告HTML结构
4. **加载顺序**：确保AdSense脚本在广告代码之前加载
5. **政策遵守**：遵守Google AdSense政策，避免违规

## 🆘 常见问题

**Q: 广告不显示怎么办？**
A: 检查广告位ID是否正确，确保AdSense账户已审核通过

**Q: 如何知道广告位ID？**
A: 在AdSense控制台创建广告单元时，系统会提供完整的代码，从中提取data-ad-slot的值

**Q: 可以重复使用同一个广告位ID吗？**
A: 不建议，每个广告位ID应该只在一个地方使用

**Q: 如何测试广告是否正常工作？**
A: 使用AdSense的"广告单元"页面查看展示次数和点击数据
