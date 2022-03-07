ssh-keygen -b 4096

# C:\Users\WINUSER/.ssh/id_rsa.pub

cp C:\Users\quentin\.ssh\id_rsa.pub C:\Users\quentin\authorized_keys
cd C:\Users\quentin\
scp authorized_keys quentin@[ubuntu-Host-Ip]:~/.ssh
