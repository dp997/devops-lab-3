#! /bin/bash

# Install awsCLI
sudo yum -y install awscli
# Install GIT
sudo yum -y install git
# Install gettext
sudo yum -y install gettext
# Install jq
sudo yum -y install jq
# Install NGINX
sudo yum -y update; sudo yum clean all
sudo yum -y install http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm; sudo yum -y makecache
sudo yum -y install nginx-1.14.0
sudo yum install -y gcc-c++ make 
curl -sL https://rpm.nodesource.com/setup_16.x | sudo -E bash - 
sudo yum -y install nodejs

mkdir /var/reactapp
git clone https://github.com/dp997/devops-lab-3-reactapp.git
cd devops-lab-3-reactapp
npm install create-react-app
npm run build

cp -r /devops-lab-3-reactapp/build/* /var/reactapp
# Remove default files we don't need
sudo rm -f /etc/nginx/conf.d/default.conf

sudo bash -c 'cat <<__EOF__ > /etc/nginx/nginx.conf
pid /run/nginx.pid;
worker_processes auto;
worker_rlimit_nofile 1024;

events {
        multi_accept on;
        worker_connections 1024;
}

http {
    upstream myapp {
        server $(aws elbv2 describe-load-balancers --names Backend-LB --region us-east-1 | jq -r .LoadBalancers[0].DNSName);
    }
    include /etc/nginx/mime.types;
    server {
        listen 80 default_server;
        server_name "";
        
        location / {
            root /var/reactapp/;
            index index.html index.htm;
        }
        location /app {
            proxy_pass http://myapp/;
            proxy_set_header Host \$host;
            proxy_http_version 1.1;
            proxy_read_timeout 120s;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }
}
__EOF__'

sudo systemctl restart nginx