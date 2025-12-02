#!/bin/bash

set -e

FQDN="${fqdn}"
HOSTED_ZONE_ID="${hosted_zone_id}"

# Обновления
apt update -y
apt upgrade -y

# Установка Nginx
apt install -y nginx

# Создание директории
mkdir -p /var/www/html

# Создание простой страницы
cat > /var/www/html/index.html <<EOF
<html>
  <head><title>Welcome</title></head>
  <body>
    <h1>Server for ${fqdn}</h1>
  </body>
</html>
EOF

# Настройка Nginx
cat > /etc/nginx/sites-available/default <<EOF
server {
    listen 80;

    server_name ${fqdn};

    root /var/www/html;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

systemctl restart nginx

# Создание DNS записи через AWS CLI
apt install -y awscli jq

cat > /tmp/route53.json <<EOF
{
  "Comment": "Create A record",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "${fqdn}",
        "Type": "A",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "$$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"
          }
        ]
      }
    }
  ]
}
EOF

aws route53 change-resource-record-sets \
  --hosted-zone-id "${hosted_zone_id}" \
  --change-batch file:///tmp/route53.json
