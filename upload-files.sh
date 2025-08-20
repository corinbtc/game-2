#!/bin/bash

# 文件上传和部署脚本
# 将本地文件上传到Ubuntu服务器

echo "📤 文件上传和部署脚本"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 服务器配置
SERVER_IP="YOUR_SERVER_IP"  # 请替换为您的服务器IP
SERVER_USER="root"          # 服务器用户名
REMOTE_PATH="/var/www/posterinstall.top"

# 检查参数
if [ "$1" = "" ]; then
    echo -e "${YELLOW}使用方法：${NC}"
    echo -e "  $0 <服务器IP地址>"
    echo -e "  例如：$0 123.456.789.10"
    exit 1
fi

SERVER_IP=$1

echo -e "${YELLOW}🚀 开始上传文件到服务器 ${SERVER_IP}...${NC}"

# 创建临时打包文件
echo -e "${YELLOW}📦 打包网站文件...${NC}"
tar -czf website.tar.gz \
    index.html \
    play.html \
    template.html \
    type.html \
    white.png \
    data/ \
    img/ \
    js/ \
    AD_CONFIG_GUIDE.md

# 上传文件到服务器
echo -e "${YELLOW}📤 上传文件到服务器...${NC}"
scp website.tar.gz ${SERVER_USER}@${SERVER_IP}:/tmp/

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 文件上传失败${NC}"
    exit 1
fi

# 在服务器上解压和部署
echo -e "${YELLOW}🔧 在服务器上部署文件...${NC}"
ssh ${SERVER_USER}@${SERVER_IP} << 'EOF'
    # 备份现有文件
    if [ -d /var/www/posterinstall.top ]; then
        mv /var/www/posterinstall.top /var/www/posterinstall.top.backup.$(date +%Y%m%d_%H%M%S)
    fi
    
    # 创建新目录
    mkdir -p /var/www/posterinstall.top
    
    # 解压文件
    tar -xzf /tmp/website.tar.gz -C /var/www/posterinstall.top/
    
    # 设置权限
    chown -R www-data:www-data /var/www/posterinstall.top
    chmod -R 755 /var/www/posterinstall.top
    
    # 清理临时文件
    rm -f /tmp/website.tar.gz
    
    # 重启Nginx
    systemctl reload nginx
    
    echo "✅ 文件部署完成！"
EOF

# 清理本地临时文件
rm -f website.tar.gz

echo -e "${GREEN}✅ 部署完成！${NC}"
echo -e "${YELLOW}🌐 您的网站现在可以通过以下地址访问：${NC}"
echo -e "   http://${SERVER_IP}"
echo -e "   http://posterinstall.top"
echo -e "   https://posterinstall.top (如果已配置SSL)"
