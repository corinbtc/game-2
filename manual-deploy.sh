#!/bin/bash

# 手动部署脚本 - 可在服务器Web控制台中直接运行
# 适用于无法SSH连接的情况

echo "🚀 开始手动部署游戏网站..."

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 更新系统
echo -e "${YELLOW}📦 更新系统包...${NC}"
apt update && apt upgrade -y

# 安装必要的软件
echo -e "${YELLOW}📦 安装 Nginx, Node.js, Git...${NC}"
apt install -y nginx nodejs npm git curl wget unzip

# 创建网站目录
echo -e "${YELLOW}📁 创建网站目录...${NC}"
mkdir -p /var/www/posterinstall.top
chown -R www-data:www-data /var/www/posterinstall.top

# 配置Nginx
echo -e "${YELLOW}⚙️ 配置 Nginx...${NC}"
cat > /etc/nginx/sites-available/posterinstall.top << 'EOF'
server {
    listen 80;
    server_name posterinstall.top www.posterinstall.top;
    root /var/www/posterinstall.top;
    index index.html;

    # 启用gzip压缩
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;

    # 静态文件缓存
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|webp)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        try_files $uri =404;
    }

    # 主要页面路由
    location / {
        try_files $uri $uri/ /index.html;
    }

    # 游戏页面
    location /play {
        try_files $uri $uri/ /play.html;
    }

    # 类型页面
    location /type {
        try_files $uri $uri/ /type.html;
    }

    # 模板页面
    location /template {
        try_files $uri $uri/ /template.html;
    }

    # 数据文件
    location /data/ {
        expires 1h;
        add_header Cache-Control "public";
    }

    # 图片文件
    location /img/ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # 安全头
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;

    # 错误页面
    error_page 404 /index.html;
    error_page 500 502 503 504 /index.html;
}
EOF

# 启用站点
ln -sf /etc/nginx/sites-available/posterinstall.top /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# 测试Nginx配置
echo -e "${YELLOW}🔍 测试 Nginx 配置...${NC}"
nginx -t

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Nginx 配置测试通过${NC}"
    systemctl restart nginx
    systemctl enable nginx
else
    echo -e "${RED}❌ Nginx 配置测试失败${NC}"
    exit 1
fi

# 配置防火墙
echo -e "${YELLOW}🔥 配置防火墙...${NC}"
ufw allow 'Nginx Full'
ufw allow ssh
ufw --force enable

echo -e "${GREEN}✅ 基础部署完成！${NC}"
echo -e "${YELLOW}📝 下一步：${NC}"
echo -e "1. 上传网站文件到 /var/www/posterinstall.top/"
echo -e "2. 配置SSL证书"
echo -e "3. 配置广告代码"

# 显示当前IP地址
echo -e "${YELLOW}🌐 服务器IP地址：${NC}"
curl -s ifconfig.me
echo ""
