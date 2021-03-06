# System
set system host-name edge01-quentin
set system login user quenitn authentication plaintext-password BabaBooey!
set system name-server 10.0.17.2
set system syslog global facility all level info 
set system syslog global facility protocols level debug
set system syslog host 172.16.50.5 facility authpriv level info
set system syslog host 172.16.200.10 facility kern level debug
set system syslog host 172.16.200.10 format octet-counted
set system syslog host 172.16.200.10 port 1514
# Interfaces
set interfaces ethernet eth0 address 10.0.17.115/24
set interfaces ethernet eth0 description SEC350-WAN
set interfaces ethernet eth1 address 172.16.50.2/29
set interfaces ethernet eth0 description SEC350-DMZ
set interfaces ethernet eth1 address 172.16.150.2/24
set interfaces ethernet eth0 description SEC350-LAN
# NAT
set nat source rule 10 description "NAT FROM DMZ TO WAN"
set nat source rule 10 outbound-interface eth0
set nat source rule 10 source address 172.16.50.0/29
set nat source rule 10 translation masquerade
set nat source rule 15 description "NAT FROM LAN TO WAN"
set nat source rule 15 outbound-interface eth0
set nat source rule 15 source address 172.16.150.0/24
set nat source rule 15 translation masquerade
set nat source rule 20 description "NAT FROM MGMT TO WAN"
set nat source rule 20 outbound-interface eth0
set nat source rule 20 source address 172.16.200.0/28
set nat source rule 20 translation masquerade
set nat destination rule 10 description HTTP->WEB01
set nat destination rule 10 destination port 80
set nat destination rule 10 inbound-interface eth0
set nat destination rule 10 protocol tcp
set nat destination rule 10 translation address 172.16.50.5
set nat destination rule 10 port 80
set nat destination rule 11 description SSH->JUMP
set nat destination rule 11 destination port 22
set nat destination rule 11 inbound-interface eth0
set nat destination rule 11 protocol tcp
set nat destination rule 11 translation address 172.16.50.4
set nat destination rule 11 port 22
# Services 
set service dns forwarding allow-from 172.16.50.0/29
set service dns forwarding allow-from 172.16.150.0/24
set service dns forwarding listen-address 172.16.50.2
set service dns forwarding listen-address 172.16.150.2
set service ssh listen-address 172.16.150.2
set service ssh port 22
# Protocols
set protocols rip interface eth2 
set protocols rip network 172.16.50.0/29
set protocols static route 0.0.0.0/0 next-hop 10.0.17.2 
set protocols static route 172.16.200.0/28 next-hop 172.16.150.3
# Firewalls
# DMZ-to-LAN
set firewall name DMZ-to-LAN default action drop 
set firewall name DMZ-to-LAN enable-default-log
set firewall name DMZ-to-LAN rule 1 action accept 
set firewall name DMZ-to-LAN rule 1 state established enable
set firewall name DMZ-to-LAN rule 10 action accept
set firewall name DMZ-to-LAN rule 10 destination address 172.16.200.10 
set firewall name DMZ-to-LAN rule 10 destination port 1514
set firewall name DMZ-to-LAN rule 10 protocol udp
set firewall name DMZ-to-LAN rule 10 descr "Allow DMZ Access to Log01 Graylog"
# DMZ-to-WAN
set firewall name DMZ-to-WAN default action drop 
set firewall name DMZ-to-WAN enable-default-log
set firewall name DMZ-to-WAN rule 1 action accept 
set firewall name DMZ-to-WAN rule 1 state established enable
set firewall name DMZ-to-WAN rule 10 action accept 
set firewall name DMZ-to-WAN rule 10 destination port 123
set firewall name DMZ-to-WAN rule 10 protocol udp
set firewall name DMZ-to-WAN rule 10 description "Nginx01 Time-Check Out"
# LAN-to-DMZ
set firewall name LAN-to-DMZ default action drop 
set firewall name LAN-to-DMZ enable-default-log
set firewall name LAN-to-DMZ rule 10 action accept 
set firewall name LAN-to-DMZ rule 10 destination address 172.16.50.5
set firewall name LAN-to-DMZ rule 10 destination port 80
set firewall name LAN-to-DMZ rule 10 protocol tcp
set firewall name LAN-to-DMZ rule 10 description "LAN access to Nginx01 HTTP"
set firewall name LAN-to-DMZ rule 11 action accept 
set firewall name LAN-to-DMZ rule 11 destination address 172.16.50.5
set firewall name LAN-to-DMZ rule 11 destination port 22
set firewall name LAN-to-DMZ rule 11 protocol tcp
set firewall name LAN-to-DMZ rule 20 action accept
set firewall name LAN-to-DMZ rule 20 description "MGMT access to Jump"
set firewall name LAN-to-DMZ rule 20 destination address 172.16.50.4
set firewall name LAN-to-DMZ rule 20 destination port 22
set firewall name LAN-to-DMZ rule 20 protocol tcp
set firewall name LAN-to-DMZ rule 20 source address 172.16.200.11
# LAN-to-WAN
set firewall name LAN-to-WAN default action drop 
set firewall name LAN-to-WAN enable-default-log
set firewall name LAN-to-WAN rule 1 action accept 
set firewall name LAN-to-WAN rule 1 state established enable
# WAN-to-DMZ
set firewall name WAN-to-DMZ default action drop 
set firewall name WAN-to-DMZ enable-default-log
set firewall name WAN-to-DMZ rule 10 action accept 
set firewall name WAN-to-DMZ rule 10 destination address 172.16.50.5
set firewall name WAN-to-DMZ rule 10 destination port 80
set firewall name WAN-to-DMZ rule 10 protocol tcp
set firewall name WAN-to-DMZ rule 10 description "Allow WAN Access to Nginx01 HTTP"
set firewall name WAN-to-DMZ rule 11 action accept 
set firewall name WAN-to-DMZ rule 11 destination address 172.16.50.4
set firewall name WAN-to-DMZ rule 11 destination port 22
set firewall name WAN-to-DMZ rule 11 protocol tcp
set firewall name WAN-to-DMZ rule 11 description "SSH to Jump"
set firewall name WAN-to-DMZ rule 12 action accept 
set firewall name WAN-to-DMZ rule 12 state established enable
# WAN-to-LAN
set firewall name WAN-to-LAN default action drop 
set firewall name WAN-to-LAN enable-default-log
set firewall name WAN-to-LAN rule 1 action accept 
set firewall name WAN-to-LAN rule 1 state established enable
# Zone Policy 
set zone-policy zone DMZ from LAN firewall name LAN-to-DMZ
set zone-policy zone DMZ from WAN firewall name WAN-to-DMZ
set zone-policy zone DMZ interface eth1
set zone-policy zone LAN from DMZ firewall name DMZ-to-LAN
set zone-policy zone LAN from WAN firewall name WAN-to-LAN
set zone-policy zone LAN interface eth2
set zone-policy zone WAN from DMZ firewall name DMZ-to-WAN
set zone-policy zone WAN from LAN firewall name LAN-to-WAN
set zone-policy zone WAN interface eth0
