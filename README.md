# [walmart-tv](https://walmart-tv.xyz)
walmart-tv is a website where you can view a stream from a Walmart display laptop.
## Prerequisites
- An always-on server running a Debian-based Linux distribution that can run a web server (nginx) along with an RTMP server (libnginx-mod-rtmp)
- A computer capable of streaming with OBS Studio installed
- A domain with a DNS record to your server's IP address, preferably
## Installation
First, update the system.
```
sudo apt update
sudo apt upgrade
```
Then, install nginx with the RTMP module, along with git:
```
sudo apt install nginx libnginx-mod-rtmp git
```
Clone the source code for walmart-tv:
```
git clone https://github.com/displaylaptop/walmart-tv.git -b main /opt/walmart
```
Make a new configuration file (`sudo nano /etc/nginx/conf.d/walmart.conf` or `sudo nano /etc/nginx/sites-available/walmart.conf`) and add the following configuration:
```css
server {
    listen 80;
    server_name <your.ip.or.domain>;

    location / {
        root /opt/walmart;
        index index.html index.htm;
    }

    location /hls {
        types {
            application/vnd.apple.mpegurl m3u8;
            video/mp2t ts;
        }
        root /opt/walmart/stream;
        add_header Cache-Control no-cache;
    }
}

rtmp {
    server {
        listen 1935;
        chunk_size 4096;

        application live {
            live on;
            allow publish all;
            allow play all;
            hls on;
            hls_path /opt/walmart/stream;
            hls_fragment 5s;
            hls_playlist_length 30s; 
        }
    }
}
```
If you have a domain, install certbot, along with the nginx plugin, then create a certificate for your domain:
```
sudo apt install certbot python3-certbot-nginx
sudo mkdir -p /var/lib/letsencrypt/
sudo certbot --email <your@email.tld> -d <domain.tld> --nginx
```
Verify the configuration is correct:
```
nginx -t
```
Run the following command to replace walmart-tv.xyz's stream with your stream:
```
sed -i -e 's/45.90.12.97/<your.ip.or.domain>/g' /opt/walmart/index.html
```
If it is correct, restart nginx:
```
sudo systemctl restart nginx
```
Now, go to OBS (preferably on a Walmart display computer you have remote access to) and:
1. Go to `Settings > Stream`
2. In the Service drop-down, select Custom
3. Paste your RTMP URL (usually `rtmp://<your.ip.or.domain>/live`
4. Type "`walmart`" as the stream key
5. Close the Settings window and press `[Start Streaming]` to start the stream
Congratulations! You have your own walmart-tv instance running.
