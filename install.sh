#!/bin/bash

# Update package lists and install Nginx
sudo apt update
sudo apt install -y nginx libnginx-mod-rtmp

# Create Nginx configuration file
sudo tee /etc/nginx/conf.d/walmart.conf > /dev/null <<EOF
# HTTP server block for serving webpage and HLS streams
server {
    listen 80;
    server_name 45.90.12.97; # Replace with your domain name

    location / {
        root /var/www/html; # Replace with the path to your webpage files
        index index.html index.htm;
    }

    location /hls {
        types {
            application/vnd.apple.mpegurl m3u8;
            video/mp2t ts;
        }
        root /var/www/hls; # Replace with the path where you want to store HLS files
        add_header Cache-Control no-cache;
    }
}

# RTMP server block
rtmp {
    server {
        listen 1935;
        chunk_size 4096;

        application live {
            live on;
            allow publish all;
            allow play all;
            hls on;
            hls_path /var/www/hls; # Replace with the path where you want to store HLS files
            hls_fragment 5s; # Specify the duration of each HLS segment
            hls_playlist_length 30s; # Specify the duration of the HLS playlist
        }
    }
}
EOF

# Create directory for HLS files if it doesn't exist
sudo mkdir -p /var/www/hls

# Set permissions for the HLS directory
sudo chown -R www-data:www-data /var/www/hls

# Restart Nginx to apply changes
sudo systemctl restart nginx

echo "walmart-tv has been set up successfully"
