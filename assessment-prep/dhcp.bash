sudo apt update
sudo apt install isc-dhcp-server

sudo cp /etc/dhcp/dhcpd.conf{,.backup}

sudo tee -a /etc/dhcp/dhcpd.conf > /dev/null <<EOT
# a simple /etc/dhcp/dhcpd.conf
default-lease-time 6000;
max-lease-time 72000;
authoritative;
 
subnet 192.168.1.0 netmask 255.255.255.0 {
 range 192.168.1.100 192.168.1.200;
 option routers 192.168.1.254;
 option domain-name-servers 192.168.1.1, 192.168.1.2;
#option domain-name "mydomain.example";
}
EOT

sudo systemctl restart isc-dhcp-server.service
sudo systemctl status isc-dhcp-server.service
