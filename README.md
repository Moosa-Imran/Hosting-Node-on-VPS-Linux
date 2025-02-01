# Hosting a Node.js App on a Linux Server (Ubuntu, Hostinger)

This guide provides step-by-step instructions for hosting a Node.js application on an Ubuntu-based server (such as Hostinger). It includes installing necessary dependencies, setting up a process manager, configuring Nginx as a reverse proxy, setting up SSL with Certbot, enabling firewall rules, and installing MongoDB.

---

## 1. Install Node.js

First, ensure your system is up to date:

```sh
sudo apt update && sudo apt upgrade -y
```

Now, install Node.js:

```sh
curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
sudo apt install -y nodejs
```

Verify installation:

```sh
node -v
npm -v
```

Common Mistake: *Ensure you install the correct version of Node.js that matches your application's requirements.*

---

## 2. Install and Configure MongoDB

MongoDB is a NoSQL database commonly used with Node.js applications.

### Install MongoDB

```sh
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt update
sudo apt install -y mongodb-org
```

### Start and Enable MongoDB

```sh
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl status mongod
```

### Allow Remote Access (If Required)

```sh
sudo ufw allow 27017
```

### Create an Admin User

```sh
mongosh
use admin
db.createUser({
  user: "your-username",
  pwd: "your-password",
  roles: [{ role: "root", db: "admin" }]
})
quit()
```

### Secure MongoDB

Before modifying the configuration file, **stop MongoDB** to avoid crashes:

```sh
sudo systemctl stop mongod
```

Now, edit the MongoDB config file:

```sh
sudo nano /etc/mongod.conf
```

Modify the following sections:

```yaml
security:
    authorization: "enabled"
```

```yaml
net:
    bindIP: 0.0.0.0
```

Restart MongoDB:

```sh
sudo systemctl start mongod
sudo systemctl status mongod
```

### Check MongoDB Version

```sh
db.version()
```

Common Mistake: *Beginners often forget to stop the MongoDB service before modifying its config file. Always stop the service before making changes and restart it afterward to prevent unexpected crashes.*

---

## 3. Clone Your Node.js Application

```sh
git clone <repo-name>
cd <repo-name>
```

---

## 4. Install Build Tools

```sh
sudo apt install build-essential
```

---

## 5. Install and Configure PM2 (Process Manager)

PM2 helps in managing and keeping your Node.js app running.

```sh
sudo npm install pm2@latest -g
pm2 start server.js --name "my-node-server"
pm2 save
pm2 startup
```

To enable PM2 on system startup:

```sh
sudo systemctl start pm2-<your-app-name>
```

Common Mistake: *Ensure PM2 is properly saved and starts automatically on reboot by running `pm2 save` and `pm2 startup`.*

---

## 6. Install and Configure Nginx as a Reverse Proxy

### Install Nginx

```sh
sudo apt update
sudo apt install nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

### Configure Nginx for Your Domain

```sh
sudo nano /etc/nginx/sites-available/yourdomain.com
```

Paste the following configuration:

```nginx
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;

    location / {
        proxy_pass http://localhost:3001;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    error_log /var/log/nginx/yourdomain_error.log;
    access_log /var/log/nginx/yourdomain_access.log;
}
```

Enable the configuration:

```sh
sudo ln -s /etc/nginx/sites-available/yourdomain.com /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

---

## 7. Secure Your Application with SSL (Let's Encrypt)

```sh
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com
sudo certbot renew --dry-run
```

---

## 8. Configure Firewall

```sh
sudo ufw status
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw enable
```

Common Mistake: *Ensure you allow `OpenSSH` before enabling UFW, or else you might lock yourself out of the server.*

---

## Additional Resources

- [DigitalOcean Node.js Production Guide](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-node-js-application-for-production-on-ubuntu-20-04)
- [NodeSource Distributions](https://github.com/nodesource/distributions)
- [GeekyShows Nginx SSL Guide](https://github.com/geekyshow1/GeekyShowsNotes/blob/main/nginx/SSL_Cert_Nginx.md)

---

This guide provides a streamlined approach to setting up a Node.js application on an Ubuntu server. If you have any questions or improvements, feel free to contribute!
