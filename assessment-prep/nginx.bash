sudo apt update
sudo apt install nginx

systemctl restart nginx
systemctl status nginx

sudo tee -a /var/www/index.html > /dev/null <<EOT
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>Welcome To BabaBooey Inc.</title>
</head>
<body>
    <h1>Hello, SEC-350!</h1>
    <p>Welocme to the Wonderful Nginx Fuled BabaBooey Site!</p>
</body>
</html>
EOT

systemctl restart nginx
systemctl status nginx
