#! /bin/bash

sudo apt-get update
sudo apt-get install -y git apache2
cd /var/www/html
sudo rm index.html -f
sudo git init
sudo git pull https://github.com/DmyMi/2048.git
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
ZONE=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)
sed -i "s|zone-here|$ZONE|" /var/www/html/index.html
sudo systemctl restart apache2