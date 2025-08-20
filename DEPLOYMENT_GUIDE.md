# 🚀 Ubuntu + Nginx 部署指南

## 📋 部署前准备

### 1. 服务器要求
- Ubuntu 20.04 LTS 或更高版本
- 至少 1GB RAM
- 至少 10GB 磁盘空间
- 公网IP地址
- 域名解析已配置

### 2. 域名配置
确保您的域名 `posterinstall.top` 和 `www.posterinstall.top` 都指向您的服务器IP。

## 🛠️ 部署步骤

### 第一步：服务器基础配置

1. **连接到服务器**
```bash
ssh root@YOUR_SERVER_IP
```

2. **运行基础部署脚本**
```bash
# 上传脚本到服务器
scp deploy.sh root@YOUR_SERVER_IP:/root/

# 在服务器上运行
chmod +x deploy.sh
./deploy.sh
```

### 第二步：上传网站文件

1. **在本地运行上传脚本**
```bash
chmod +x upload-files.sh
./upload-files.sh YOUR_SERVER_IP
```

2. **或者手动上传**
```bash
# 打包文件
tar -czf website.tar.gz index.html play.html template.html type.html white.png data/ img/ js/ AD_CONFIG_GUIDE.md

# 上传到服务器
scp website.tar.gz root@YOUR_SERVER_IP:/tmp/

# 在服务器上解压
ssh root@YOUR_SERVER_IP
cd /var/www/posterinstall.top
tar -xzf /tmp/website.tar.gz
chown -R www-data:www-data /var/www/posterinstall.top
chmod -R 755 /var/www/posterinstall.top
systemctl reload nginx
```

### 第三步：配置SSL证书

1. **运行SSL配置脚本**
```bash
# 上传脚本到服务器
scp ssl-setup.sh root@YOUR_SERVER_IP:/root/

# 在服务器上运行
chmod +x ssl-setup.sh
./ssl-setup.sh
```

2. **手动配置SSL（如果需要）**
```bash
# 安装Certbot
apt install -y certbot python3-certbot-nginx

# 申请证书
certbot --nginx -d posterinstall.top -d www.posterinstall.top

# 配置自动续期
(crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet") | crontab -
```

### 第四步：配置广告代码

1. **编辑广告配置文件**
```bash
nano /var/www/posterinstall.top/js/adManager.js
```

2. **更新广告配置**
```javascript
config: {
    publisherId: 'ca-pub-8306112973766890',
    adSlots: {
        top: '您的顶部广告位ID',
        bottom: '您的底部广告位ID',
        center: '您的中央广告位ID',
        banner: '您的横幅广告位ID'
    }
}
```

## 🔧 服务器管理

### 常用命令

```bash
# 检查Nginx状态
systemctl status nginx

# 重启Nginx
systemctl restart nginx

# 查看Nginx错误日志
tail -f /var/log/nginx/error.log

# 查看网站访问日志
tail -f /var/log/nginx/access.log

# 检查SSL证书状态
certbot certificates

# 手动续期SSL证书
certbot renew

# 查看磁盘使用情况
df -h

# 查看内存使用情况
free -h
```

### 防火墙配置

```bash
# 查看防火墙状态
ufw status

# 开放端口
ufw allow 80
ufw allow 443
ufw allow 22

# 启用防火墙
ufw enable
```

## 📊 性能优化

### Nginx优化配置

编辑 `/etc/nginx/nginx.conf`：

```nginx
# 在 http 块中添加
worker_processes auto;
worker_connections 1024;

# 启用gzip压缩
gzip on;
gzip_vary on;
gzip_min_length 1024;
gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;

# 文件缓存
location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|webp)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}
```

### 系统优化

```bash
# 安装性能监控工具
apt install -y htop iotop

# 设置系统限制
echo "* soft nofile 65536" >> /etc/security/limits.conf
echo "* hard nofile 65536" >> /etc/security/limits.conf
```

## 🔍 故障排除

### 常见问题

1. **网站无法访问**
```bash
# 检查Nginx状态
systemctl status nginx

# 检查端口是否开放
netstat -tlnp | grep :80
netstat -tlnp | grep :443

# 检查防火墙
ufw status
```

2. **SSL证书问题**
```bash
# 检查证书状态
certbot certificates

# 重新申请证书
certbot --nginx -d posterinstall.top -d www.posterinstall.top

# 查看证书日志
tail -f /var/log/letsencrypt/letsencrypt.log
```

3. **文件权限问题**
```bash
# 修复文件权限
chown -R www-data:www-data /var/www/posterinstall.top
chmod -R 755 /var/www/posterinstall.top
```

4. **域名解析问题**
```bash
# 检查域名解析
nslookup posterinstall.top
nslookup www.posterinstall.top

# 检查DNS记录
dig posterinstall.top
dig www.posterinstall.top
```

## 📈 监控和维护

### 设置监控

```bash
# 安装监控工具
apt install -y fail2ban logwatch

# 配置fail2ban
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
systemctl enable fail2ban
systemctl start fail2ban
```

### 定期维护

```bash
# 创建维护脚本
cat > /root/maintenance.sh << 'EOF'
#!/bin/bash
# 更新系统
apt update && apt upgrade -y

# 清理日志
journalctl --vacuum-time=7d

# 清理临时文件
apt autoremove -y
apt autoclean

# 检查SSL证书
certbot renew --quiet

# 重启Nginx
systemctl reload nginx
EOF

chmod +x /root/maintenance.sh

# 添加到定时任务
(crontab -l 2>/dev/null; echo "0 2 * * 0 /root/maintenance.sh") | crontab -
```

## 🎯 部署完成检查清单

- [ ] 网站可以通过HTTP访问
- [ ] 网站可以通过HTTPS访问
- [ ] SSL证书自动续期已配置
- [ ] 广告代码已正确配置
- [ ] 防火墙已配置
- [ ] 监控工具已安装
- [ ] 定期维护任务已设置
- [ ] 备份策略已制定

## 📞 技术支持

如果遇到问题，请检查：
1. 服务器日志：`/var/log/nginx/error.log`
2. SSL证书日志：`/var/log/letsencrypt/letsencrypt.log`
3. 系统日志：`journalctl -xe`

您的网站现在应该可以通过以下地址访问：
- http://posterinstall.top
- https://posterinstall.top
- http://www.posterinstall.top
- https://www.posterinstall.top
