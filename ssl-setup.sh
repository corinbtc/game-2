#!/bin/bash

# SSL证书配置脚本
# 使用Let's Encrypt为posterinstall.top配置HTTPS

echo "🔒 配置SSL证书..."

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 检查是否为root用户
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}请使用 sudo 运行此脚本${NC}"
    exit 1
fi

# 安装Certbot
echo -e "${YELLOW}📦 安装 Certbot...${NC}"
apt install -y certbot python3-certbot-nginx

# 检查域名解析
echo -e "${YELLOW}🔍 检查域名解析...${NC}"
if ! nslookup posterinstall.top > /dev/null 2>&1; then
    echo -e "${RED}❌ 域名 posterinstall.top 无法解析，请检查DNS设置${NC}"
    exit 1
fi

if ! nslookup www.posterinstall.top > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️ 域名 www.posterinstall.top 无法解析，将只为主域名配置SSL${NC}"
    DOMAINS="posterinstall.top"
else
    DOMAINS="posterinstall.top www.posterinstall.top"
fi

# 申请SSL证书
echo -e "${YELLOW}🔐 申请SSL证书...${NC}"
certbot --nginx -d $DOMAINS --non-interactive --agree-tos --email admin@posterinstall.top

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ SSL证书申请成功！${NC}"
    
    # 配置自动续期
    echo -e "${YELLOW}🔄 配置自动续期...${NC}"
    (crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet") | crontab -
    
    # 测试Nginx配置
    echo -e "${YELLOW}🔍 测试Nginx配置...${NC}"
    nginx -t && systemctl reload nginx
    
    echo -e "${GREEN}✅ SSL配置完成！${NC}"
    echo -e "${YELLOW}🌐 您的网站现在可以通过HTTPS访问：${NC}"
    echo -e "   https://posterinstall.top"
    if [[ $DOMAINS == *"www"* ]]; then
        echo -e "   https://www.posterinstall.top"
    fi
else
    echo -e "${RED}❌ SSL证书申请失败${NC}"
    echo -e "${YELLOW}💡 请检查：${NC}"
    echo -e "   1. 域名是否正确解析到服务器IP"
    echo -e "   2. 80端口是否开放"
    echo -e "   3. Nginx是否正常运行"
    exit 1
fi
