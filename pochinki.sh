#!/bin/bash
apt-get update
apt-get install bind9 -y
mkdir /etc/bind/jarkom

echo '
zone "pochinki.com" {
    type master;
    file "/etc/bind/jarkom/pochinki.com";
};

zone "airdrop.it32.com" {
    type master;
    notify yes;
    also-notify { 10.63.3.2; };
    allow-transfer { 10.63.3.2; };
    file "/etc/bind/jarkom/airdrop.it32.com";
};

zone "redzone.it32.com" {
    type master;
    notify yes;
    also-notify { 10.63.3.2; };
    allow-transfer { 10.63.3.2; };
    file "/etc/bind/jarkom/redzone.it32.com";
};

zone "loot.it32.com" {
    type master;
    notify yes;
    also-notify { 10.63.3.2; };
    allow-transfer { 10.63.3.2; };
    file "/etc/bind/jarkom/loot.it32.com";
};

zone "2.3.63.10.in-addr.arpa" {
        type master;
        notify yes;
        also-notify { 10.63.3.2; };
        allow-transfer { 10.63.3.2; };
        file "/etc/bind/jarkom/2.3.63.10.in-addr.arpa";
};

zone "medkit.airdrop.it32.com" {
    type master;
    file "/etc/bind/jarkom/medkit.airdrop.it32.com";
};

zone "siren.redzone.it32.com" {
    type master;
    file "/etc/bind/jarkom/siren.redzone.it32.com";

};
' > /etc/bind/named.conf.local

cp /etc/bind/db.local /etc/bind/jarkom/pochinki.com

echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     airdrop.it32.com. root.airdrop.it32.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@             IN      NS      airdrop.it32.com.
@             IN      A       10.63.1.3 ; IP Stalber
www           IN      CNAME   airdrop.it32.com.
' > /etc/bind/jarkom/airdrop.it32.com

echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     redzone.it32.com. root.redzone.it32.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@             IN      NS      redzone.it32.com.
@             IN      A       10.63.1.4 ; IP Severny
www           IN      CNAME   redzone.it32.com.
' > /etc/bind/jarkom/redzone.it32.com

echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     loot.it32.com. root.loot.it32.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@             IN      NS      loot.it32.com.
@             IN      A       10.63.2.4 ; IP Mylta
www           IN      CNAME   loot.it32.com.
' > /etc/bind/jarkom/loot.it32.com

echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     medkit.airdrop.it32.com. root.medkit.airdrop.it32.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@             IN      NS      medkit.airdrop.it32.com.
@             IN      A       10.63.1.2 ; IP Lipovka
www           IN      CNAME   medkit.airdrop.it32.com.
' > /etc/bind/jarkom/medkit.airdrop.it32.com

echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     siren.redzone.it32.com. root.siren.redzone.it32.com. (
                     2022100601         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      siren.redzone.it32.com.
@       IN      A       10.63.1.4
www     IN      A       10.63.1.4
log     IN      A       10.63.1.4
www.log IN      CNAME   www.siren.redzone.it32.com.
'  > /etc/bind/delegasi/siren.redzone.it32.com

cp option.conf /etc/bind/named.conf.options

echo "options {
    directory \"/var/cache/bind\";


    // If there is a firewall between you and nameservers you want
    // to talk to, you may need to fix the firewall to allow multiple
    // ports to talk.  See http://www.kb.cert.org/vuls/id/800113


    // If your ISP provided one or more IP addresses for stable
    // nameservers, you probably want to use them as forwarders.
    // Uncomment the following block, and insert the addresses replacing
    // the all-0's placeholder.


    forwarders {
          192.168.122.1;
     };


    //========================================================================
    // If BIND logs error messages about the root key being expired,
    // you will need to update your keys.  See https://www.isc.org/bind-keys
//========================================================================
    //dnssec-validation auto;
    allow-query {any;};


    auth-nxdomain no;
    listen-on-v6 { any; };
};

" > /etc/bind/named.conf.options

service bind9 restart
