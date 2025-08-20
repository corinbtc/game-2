# 🌐 Web控制台部署指南

由于SSH连接问题，请按照以下步骤在服务器Web控制台中完成部署：

## 📋 部署步骤

### 第一步：访问服务器Web控制台

1. **登录您的服务器提供商控制面板**
   - 阿里云、腾讯云、AWS等都有Web控制台
   - 找到您的服务器实例
   - 点击"连接"或"控制台"

2. **进入服务器终端**
   - 选择"Web终端"或"VNC控制台"
   - 使用root账户登录

### 第二步：运行基础部署脚本

在Web控制台中复制粘贴以下命令：

```bash
# 更新系统
apt update && apt upgrade -y

# 安装必要软件
apt install -y nginx nodejs npm git curl wget unzip

# 创建网站目录
mkdir -p /var/www/posterinstall.top
chown -R www-data:www-data /var/www/posterinstall.top
```

### 第三步：配置Nginx

创建Nginx配置文件：

```bash
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

# 测试并重启Nginx
nginx -t && systemctl restart nginx && systemctl enable nginx
```

### 第四步：上传网站文件

#### 方法1：使用wget下载（推荐）

在服务器上运行：

```bash
# 创建临时目录
mkdir -p /tmp/website
cd /tmp/website

# 下载网站文件（需要您将文件上传到网盘或Git仓库）
# 例如：wget https://your-file-hosting.com/website-deploy.tar.gz

# 解压文件
tar -xzf website-deploy.tar.gz

# 复制到网站目录
cp -r * /var/www/posterinstall.top/

# 设置权限
chown -R www-data:www-data /var/www/posterinstall.top
chmod -R 755 /var/www/posterinstall.top
```

#### 方法2：手动创建文件

如果无法下载，可以手动创建主要文件：

```bash
# 创建index.html
cat > /var/www/posterinstall.top/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>游戏网站</title>
</head>
<body>
    <h1>网站部署成功！</h1>
    <p>请上传完整的网站文件。</p>
</body>
</html>
EOF
```

### 第五步：配置防火墙

```bash
# 配置防火墙
ufw allow 'Nginx Full'
ufw allow ssh
ufw --force enable
```

### 第六步：配置SSL证书

```bash
# 安装Certbot
apt install -y certbot python3-certbot-nginx

# 申请SSL证书
certbot --nginx -d posterinstall.top -d www.posterinstall.top --non-interactive --agree-tos --email admin@posterinstall.top

# 配置自动续期
(crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet") | crontab -
```

## 🔧 故障排除

### 检查服务状态

```bash
# 检查Nginx状态
systemctl status nginx

# 检查端口监听
netstat -tlnp | grep :80
netstat -tlnp | grep :443

# 查看Nginx错误日志
tail -f /var/log/nginx/error.log
```

### 常见问题解决

1. **Nginx启动失败**
```bash
nginx -t  # 检查配置
systemctl restart nginx
```

2. **SSL证书申请失败**
```bash
# 检查域名解析
nslookup posterinstall.top
nslookup www.posterinstall.top

# 重新申请证书
certbot --nginx -d posterinstall.top
```

3. **文件权限问题**
```bash
chown -R www-data:www-data /var/www/posterinstall.top
chmod -R 755 /var/www/posterinstall.top
```

## 📞 获取帮助

如果遇到问题：

1. **检查日志文件**
   - Nginx错误日志：`/var/log/nginx/error.log`
   - SSL证书日志：`/var/log/letsencrypt/letsencrypt.log`
   - 系统日志：`journalctl -xe`

2. **联系服务器提供商**
   - 检查服务器状态
   - 确认网络配置
   - 验证防火墙设置

## 🎯 部署完成检查

部署完成后，您的网站应该可以通过以下地址访问：
- http://23.224.194.182
- http://posterinstall.top
- https://posterinstall.top (SSL配置后)
