#!/bin/bash
echo '
zone "airdrop.it32.com" {
    type slave;
    masters { 10.63.3.2; }; # IP Pochinki
    file "/etc/bind/jarkom/slave.airdrop.it32.com";
};

zone "redzone.it32.com" {
    type slave;
    masters { 10.63.3.2; }; # IP Pochinki
    file "/etc/bind/jarkom/slave.redzone.it32.com";
};

zone "loot.it32.com" {
    type slave;
    masters { 10.63.3.2; }; # IP Pochinki
    file "/etc/bind/jarkom/slave.loot.it32.com";
};

zone "airdrop.it32.com" {
    type slave;
    masters { 10.63.3.2; };
    file "/var/lib/bind/airdrop.it32.com";
};

zone "redzone.it32.com" {
    type slave;
    masters { 10.63.3.2; };
    file "/var/lib/bind/redzone.it32.com";
};

zone "loot.it32.com" {
    type slave;
    masters { 10.63.3.2; };
    file "/var/lib/bind/loot.it32.com";
};

zone "medkit.airdrop.it32.com" {
    type slave;
    masters { 10.63.3.2; }; # IP Pochinki
    file "/etc/bind/jarkom/slave.medkit.airdrop.it32.com";
};

zone "siren.redzone.it32.com" {
    type delegation;
    masters { 10.63.3.2; }; # IP Georgopol
    file "/etc/bind/jarkom/delegasi.siren.redzone.it32.com";
};
' >> /etc/bind/named.conf.local


echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      NS      siren.redzone.it32.com.
' > /etc/bind/jarkom/delegasi.siren.redzone.it32.com


echo ';
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
@       IN      NS      redzone.it32.com.
@       IN      A       10.63.1.4
www     IN      CNAME   redzone.it32.com.
ns1     IN      A       10.63.3.2
siren   IN      NS      ns1
@       IN      AAAA    ::1' > /etc/bind/jarkom/redzone.it32.com


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


echo 'zone "siren.redzone.it32.com" {
   type master;
   file "/etc/bind/delegasi/siren.redzone.it32.com";
};' >> /etc/bind/named.conf.local


cp /etc/bind/db.local /etc/bind/delegasi/siren.redzone.it32.com


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

service bind9 restart
