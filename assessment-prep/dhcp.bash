sudo apt update
sudo apt install isc-dhcp-server

sudo cp /etc/dhcp/dhcpd.conf{,.backup}

sudo tee -a /etc/dhcp/dhcpd.conf > /dev/null <<EOT
# a simple /etc/dhcp/dhcpd.conf
default-lease-time 6000;
max-lease-time 72000;
authoritative;
 
subnet 172.16.150.0 netmask 255.255.255.0 {
 range 172.16.150.100 172.16.150.150;
 option routers 172.16.150.2;
 option domain-name-servers 172.16.200.11;
}
EOT

sudo systemctl restart isc-dhcp-server.service
sudo systemctl status isc-dhcp-server.service
