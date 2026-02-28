#!/bin/bash
set -e
apt update -y
apt upgrade -y
apt install -y nginx
mkdir -p /var/www/html
cat > /var/www/html/index.html <<EOF
<html>
  <head><title>Welcome</title></head>
  <body>
    <h1>Server is running</h1>
  </body>
</html>
EOF
cat > /etc/nginx/sites-available/default <<EOF
server {
    listen 80;
    root /var/www/html;
    index index.html;
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
systemctl restart nginx
