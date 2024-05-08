# Jarkom-Modul-2-IT32-2024

## Laporan Resmi Praktikum Jarkom Modul 4 2024 Kelompok IT32 - Menggunakan Topologi 2
| Nama                                  | NRP        |
| ------------------------------------- | ---------- |
| Atha Rahma Arianti                    | 5027221030 |
| Nur Azka Rahadiansyah                 | 5027221064 |

**Persiapan:**

config network erangel:

  ```
  auto eth0
  iface eth0 inet dhcp
  auto eth1
  iface eth1 inet static
  	address 10.63.1.1
  	netmask 255.255.255.0
  auto eth2
  iface eth2 inet static
  	address 10.63.2.1
  	netmask 255.255.255.0
  auto eth3
  iface eth3 inet static
  	address 10.63.3.1
  	netmask 255.255.255.0
  ```

config network lipovka:

  ```
  auto eth0
  iface eth0 inet static
      address 10.63.1.2
      netmask 255.255.255.0
      gateway 10.63.1.1
  ```

config network stalber:
  
  ```
  auto eth0
  iface eth0 inet static
      address 10.63.1.3
      netmask 255.255.255.0
      gateway 10.63.1.1
  ```

config network serverny:
  ```
  auto eth0
  iface eth0 inet static
      address 10.63.1.4
      netmask 255.255.255.0
      gateway 10.63.1.1
  ```

config network pochinki:
 
  ```
  auto eth0
  iface eth0 inet static
      address 10.63.3.2
      netmask 255.255.255.0
      gateway 10.63.3.1
  ```

config network apartments:
  
  ```
  auto eth0
  iface eth0 inet static
      address 10.63.2.5
      netmask 255.255.255.0
      gateway 10.63.2.1
  ```

config network mylta:

  ```
  auto eth0
  iface eth0 inet static
      address 10.63.2.4
      netmask 255.255.255.0
      gateway 10.63.2.1
  ```
    
config network georgopol:

  ```
  auto eth0
  iface eth0 inet static
      address 10.63.2.3
      netmask 255.255.255.0
      gateway 10.63.2.1
  ```

config network ruins:

  ```
  auto eth0
  iface eth0 inet static
      address 10.63.2.2
      netmask 255.255.255.0
      gateway 10.63.2.1
  ```

**command di console:**
```
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.63.0.0/16
echo nameserver 192.168.122.1 > /etc/resolv.conf
cat /etc/resolv.conf
ping google.com
```

### Soal & Pengerjaan:

Untuk membantu pertempuran di Erangel, kamu ditugaskan untuk membuat jaringan komputer yang akan digunakan sebagai alat komunikasi. Sesuaikan rancangan Topologi dengan rancangan dan pembagian yang berada di link yang telah disediakan, dengan ketentuan nodenya sebagai berikut :

DNS Master akan diberi nama Pochinki, sesuai dengan kota tempat dibuatnya server tersebut

Karena ada kemungkinan musuh akan mencoba menyerang Server Utama, maka buatlah DNS Slave Georgopol yang mengarah ke Pochinki

Markas pusat juga meminta dibuatkan tiga Web Server yaitu Severny, Stalber, dan Lipovka. Sedangkan Mylta akan bertindak sebagai Load Balancer untuk server-server tersebut

1. a). console di pochinki
   ```
   apt-get update
    apt-get install bind9 -y
    echo 'zone "pochinki.com" {
        type master;
        file "/etc/bind/jarkom/pochinki.com";
    };' >> /etc/bind/named.conf.local
    
    
    mkdir /etc/bind/jarkom
    cp /etc/bind/db.local /etc/bind/jarkom/pochinki.com
    service bind9 restart

   ```
   b). DNS slave georgopol

   ```
   ```



Karena para pasukan membutuhkan koordinasi untuk mengambil airdrop, maka buatlah sebuah domain yang mengarah ke Stalber dengan alamat airdrop.it32.com dengan alias www.airdrop.it32.com

- pochinki:
  
  ```
  echo '
  zone "airdrop.it32.com" {
      type master;
      notify yes;
      also-notify { 10.63.3.2; };
      allow-transfer { 10.63.3.2; };
      file "/etc/bind/jarkom/airdrop.it32.com";
  };
  ' >> /etc/bind/named.conf.local
  
  
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

  ```

- georgopol:
  
  ```
  echo '
  zone "airdrop.it32.com" {
      type slave;
      masters { 10.63.3.2; }; # IP Pochinki
      file "/etc/bind/jarkom/slave.airdrop.it32.com";
  };
  ' >> /etc/bind/named.conf.local
  ```

Para pasukan juga perlu mengetahui mana titik yang sedang di bombardir artileri, sehingga dibutuhkan domain lain yaitu redzone.it32.com dengan alias www.redzone.it32.com yang mengarah ke Severny

- pochinki:
  
  ```
  echo '
  zone "redzone.it32.com" {
      type master;
      notify yes;
      also-notify { 10.63.3.2; };
      allow-transfer { 10.63.3.2; };
      file "/etc/bind/jarkom/redzone.it32.com";
  };
  ' >> /etc/bind/named.conf.local
  
  
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

  ```

- georgopol:
  
  ```
  echo '
  zone "redzone.it32.com" {
      type slave;
      masters { 10.63.3.2; }; # IP Pochinki
      file "/etc/bind/jarkom/slave.redzone.it32.com";
  };
  ' >> /etc/bind/named.conf.local

  ```

Markas pusat meminta dibuatnya domain khusus untuk menaruh informasi persenjataan dan suplai yang tersebar. Informasi persenjataan dan suplai tersebut mengarah ke Mylta dan domain yang ingin digunakan adalah loot.it32.com dengan alias www.loot.it32.com

- pochinki:
  
  ```
  echo '
  zone "loot.it32.com" {
      type master;
      notify yes;
      also-notify { 10.63.3.2; };
      allow-transfer { 10.63.3.2; };
      file "/etc/bind/jarkom/loot.it32.com";
  };
  ' >> /etc/bind/named.conf.local
  
  
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

  ```

- georgopol:
  
  ```
  echo '
  zone "loot.it32.com" {
      type slave;
      masters { 10.63.3.2; }; # IP Pochinki
      file "/etc/bind/jarkom/slave.loot.it32.com";
  };
  ' >> /etc/bind/named.conf.local

  ```

Pastikan domain-domain tersebut dapat diakses oleh seluruh komputer (client) yang berada di Erangel

- pochinki:
  
  ```
  echo '
  zone "airdrop.it32.com" {
      type master;
      file "/etc/bind/jarkom/airdrop.it32.com";
  };
  
  
  zone "redzone.it32.com" {
      type master;
      file "/etc/bind/jarkom/redzone.it32.com";
  };
  
  
  zone "loot.it32.com" {
      type master;
      file "/etc/bind/jarkom/loot.it32.com";
  };
  ' >> /etc/bind/named.conf.local

  ```

- georgopol:
  
  ```
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
  ' >> /etc/bind/named.conf.local

  ```

Beberapa daerah memiliki keterbatasan yang menyebabkan hanya dapat mengakses domain secara langsung melalui alamat IP domain tersebut. Karena daerah tersebut tidak diketahui secara spesifik, pastikan semua komputer (client) dapat mengakses domain redzone.it32.com melalui alamat IP Severny (Notes : menggunakan pointer record)

- pochinki:
  
  ```
  echo '
  zone "redzone.it32.com" {
      type master;
      file "/etc/bind/jarkom/redzone.it32.com";
  };
  ' >> /etc/bind/named.conf.local
  
  
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

  ```

- georgopol:
  
  ```
  echo '
  zone "redzone.it32.com" {
      type slave;
      masters { 10.63.3.2; }; # IP Pochinki
      file "/etc/bind/jarkom/slave.redzone.it32.com";
  };
  ' >> /etc/bind/named.conf.local

  ```

Akhir-akhir ini seringkali terjadi serangan siber ke DNS Server Utama, sebagai tindakan antisipasi kamu diperintahkan untuk membuat DNS Slave di Georgopol untuk semua domain yang sudah dibuat sebelumnya

- pochinki:
  
  ```
  zone "airdrop.it32.com" {
    type master;
    also-notify { 10.63.3.2; };
    allow-transfer { 10.63.3.2; };
    file "/etc/bind/airdrop/airdrop.it32.com";
  };
  
  zone "redzone.it32.com" {
      type master;
      also-notify { 10.63.3.2; };
      allow-transfer { 10.63.3.2; };
      file "/etc/bind/redzone/redzone.it32.com";
  };
  
  zone "loot.it32.com" {
      type master;
      also-notify { 10.63.3.2; };
      allow-transfer { 10.63.3.2; };
      file "/etc/bind/loot/loot.it32.com";
  };

  ```

- georgopol:
  
  ```
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

  ```

Kamu juga diperintahkan untuk membuat subdomain khusus melacak airdrop berisi peralatan medis dengan subdomain medkit.airdrop.it32.com yang mengarah ke Lipovka

- pochinki:
  
  ```
  echo '
  zone "medkit.airdrop.it32.com" {
      type master;
      file "/etc/bind/jarkom/medkit.airdrop.it32.com";
  };
  ' >> /etc/bind/named.conf.local
  
  
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

  ```

- georgopol:
  
  ```
  echo '
  zone "medkit.airdrop.it32.com" {
      type slave;
      masters { 10.63.3.2; }; # IP Pochinki
      file "/etc/bind/jarkom/slave.medkit.airdrop.it32.com";
  };
  ' >> /etc/bind/named.conf.local

  ```

Terkadang red zone yang pada umumnya di bombardir artileri akan dijatuhi bom oleh pesawat tempur. Untuk melindungi warga, kita diperlukan untuk membuat sistem peringatan air raid dan memasukkannya ke domain siren.redzone.it32.com dalam folder siren dan pastikan dapat diakses secara mudah dengan menambahkan alias www.siren.redzone.it32.com dan mendelegasikan subdomain tersebut ke Georgopol dengan alamat IP menuju radar di Severny

- pochinki:
  
  ```
  echo '
  zone "siren.redzone.it32.com" {
      type master;
      file "/etc/bind/jarkom/siren.redzone.it32.com";
  };
  ' >> /etc/bind/named.conf.local
  
  
  echo '
  ;
  ; BIND data file for local loopback interface
  ;
  $TTL    604800
  @       IN      SOA     siren.redzone.it32.com. root.siren.redzone.it32.com. (
                                2         ; Serial
                           604800         ; Refresh
                            86400         ; Retry
                          2419200         ; Expire
                           604800 )       ; Negative Cache TTL
  ;
  @       IN      NS      siren.redzone.it32.com.
  ; DNS Records
  @       IN      A       10.63.1.4 ; IP Severny
  www     IN      CNAME   siren.redzone.it32.com.
  log     IN      A       10.63.1.4 ; IP Severny (Radar)
  www.log IN      CNAME   log.siren.redzone.it32.com.
  ' > /etc/bind/jarkom/siren.redzone.it32.com

  ```

- georgopol:
  
  ```
  echo '
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
  ```

Markas juga meminta catatan kapan saja pesawat tempur tersebut menjatuhkan bom, maka buatlah subdomain baru di subdomain siren yaitu log.siren.redzone.it32.com serta aliasnya www.log.siren.redzone.it32.com yang juga mengarah ke Severny

- pochinki:
  
  ```
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
  @       IN      A       10.63.3.2
  www     IN      CNAME   redzone.it32.com.
  ns1     IN      A       10.63.3.2
  siren   IN      NS      ns1
  @       IN      AAAA    ::1
  ' > /etc/bind/jarkom/redzone.it32.com
  
  
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
  
  
  echo '
  zone "siren.redzone.it32.com" {
     type master;
     file "/etc/bind/jarkom/siren.redzone.it32.com";
  allow-transfer { 10.63.1.4; };
  };
  ' >> /etc/bind/named.conf.local
  
  
  service bind9 restart

  ```

- georgopol:
  
  ```
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
  
  
  mkdir /etc/bind/delegasi
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

  ```

Setelah pertempuran mereda, warga Erangel dapat kembali mengakses jaringan luar, tetapi hanya warga Pochinki saja yang dapat mengakses jaringan luar secara langsung. Buatlah konfigurasi agar warga Erangel yang berada diluar Pochinki dapat mengakses jaringan luar melalui DNS Server Pochinki

- pochinki:
  
  ```
  ```

- georgopol:
  
  ```
  ```

Karena pusat ingin sebuah website yang ingin digunakan untuk memantau kondisi markas lainnya maka deploy lah webiste ini (cek resource yg lb) pada severny menggunakan apache

  
  ```
    apt-get update
    apt-get install apache2
    service apache2 start
    apt-get install php
    sudo apt-get install lynx
    apt-get install libapache2-mod-php7.0
    a2enmod php7.0
    apt-get install wget
    apt-get install unzip
apt-get install nginx
service nginx start
service nginx status

  ```
Download source dari soal :
```
wget --no-check-certificate "https://drive.google.com/uc?id=1mnQ8W_hhEZaw_or5sfKvRb7QGlvZwvGc" -O "resource.zip"

curl -L -o file.out 'https://drive.google.com/uc?export=download&id=1mnQ8W_hhEZaw_or5sfKvRb7QGlvZwvGc

```
- severny :
```
<VirtualHost *:80>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.

        ServerName 192.168.122.1

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        Include conf-available/serve-cgi-bin.conf
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
ServerName 127.0.0.1
```




Tapi pusat merasa tidak puas dengan performanya karena traffic yag tinggi maka pusat meminta kita memasang load balancer pada web nya, dengan Severny, Stalber, Lipovka sebagai worker dan Mylta sebagai Load Balancer menggunakan apache sebagai web server nya dan load balancernya

- Load Balancer di Mylta :
```
<VirtualHost *:80>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.

        ServerName 192.168.1.2


        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
        <Proxy balancer://mycluster>
        BalancerMember http://10.63.2.4 // ip mylta
        </Proxy>
        ProxyPreserveHost On
        ProxyPass / balancer://mycluster/
        ProxyPassReverse / balancer://mycluster/

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        Include conf-available/serve-cgi-bin.conf
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
ServerName 127.0.0.1
```
Worker :
  
- Severny
  
- Stalber
```
wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=11S6CzcvLG-dB0ws1yp494IURnDvtIOcq' -O 'dir-listing.zip'
wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=1xn03kTB27K872cokqwEIlk8Zb121HnfB' -O 'lb.zip'

unzip -o dir-listing.zip -d dir-listing
unzip -o lb.zip -d lb

cp default.conf /etc/apache2/sites-available/default.conf
rm /etc/apache2/sites-available/000-default.conf

cp ./lb/worker/index.php /var/www/html/index.php

a2ensite default.conf

service apache2 restart
```
- Lipovka
```
wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=11S6CzcvLG-dB0ws1yp494IURnDvtIOcq' -O 'dir-listing.zip'
wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=1xn03kTB27K872cokqwEIlk8Zb121HnfB' -O 'lb.zip'

unzip -o dir-listing.zip -d dir-listing
unzip -o lb.zip -d lb

cp default.conf /etc/apache2/sites-available/default.conf
rm /etc/apache2/sites-available/000-default.conf

cp ./lb/worker/index.php /var/www/html/index.php

a2ensite default.conf

service apache2 restart
```


Mereka juga belum merasa puas jadi pusat meminta agar web servernya dan load balancer nya diubah menjadi nginx

- severny :
```
service apache2 stop

apt install php-fpm -y

service php7.0-fpm start

mkdir /var/www/jarkom

cp ./lb/worker/index.php /var/www/jarkom/index.php

rm /etc/nginx/sites-enabled/default

cp defaultnginx /etc/nginx/sites-available/defaultnginx
ln -s /etc/nginx/sites-available/defaultnginx /etc/nginx/sites-enabled/defaultnginx

service nginx restart

nginx -t
```
- mylta :
```
service apache2 stop

service nginx start

rm /etc/nginx/sites-enabled/default
cp lb-jarkom /etc/nginx/sites-available/lb-jarkom

ln -s /etc/nginx/sites-available/lb-jarkom /etc/nginx/sites-enabled/lb-jarkom

service nginx restart
```


Markas pusat meminta laporan hasil benchmark dengan menggunakan apache benchmark dari load balancer dengan 2 web server yang berbeda tersebut dan meminta secara detail dengan ketentuan:
Nama Algoritma Load Balancer
Report hasil testing apache benchmark 
Grafik request per second untuk masing masing algoritma. 
Analisis
```
```

Karena dirasa kurang aman karena masih memakai IP markas ingin akses ke mylta memakai mylta.xxx.com dengan alias www.mylta.xxx.com (sesuai web server terbaik hasil analisis kalian)

Agar aman, buatlah konfigurasi agar mylta.xxx.com hanya dapat diakses melalui port 14000 dan 14400.

Apa bila ada yang mencoba mengakses IP mylta akan secara otomatis dialihkan ke www.mylta.xxx.com

Soal 16 - 18 Digabung karena dirasa lebih mudah jika disatukan :

- Pochinki :
```
echo 'zone "mylta.it32.com" {
    type master;
    file "/etc/bind/jarkom/mylta.it32.com";
};' >> /etc/bind/named.conf.local

echo 'zone ""2.3.63.10.in-addr.arpa.mylta" {
    type master;
    file "/etc/bind/jarkom/2.3.63.10.in-addr.arpa.mylta";
};' >> /etc/bind/named.conf.local

echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     mylta.it32.com. root.mylta.it32.com. (
                                2         ; Serial
                                604800    ; Refresh
                                86400     ; Retry
                                2419200   ; Expire
                                604800 )  ; Negative Cache TTL
;
@       IN      NS      mylta.it32.com.
@       IN      A       10.63.2.4       ; IP Mylta
www     IN      CNAME   mylta.it32.com.' > /etc/bind/jarkom/mylta.it32.com

echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     mylta.it32.com. root.mylta.it32.com. (
                                2         ; Serial
                                604800    ; Refresh
                                86400     ; Retry
                                2419200   ; Expire
                                604800 )  ; Negative Cache TTL
;
```

Karena probset sudah kehabisan ide masuk ke salah satu worker buatkan akses direktori listing yang mengarah ke resource worker2

- severny :
```
service apache2 stop

mkdir /var/www/jarkom/workersec
cp -r dir-listing/workersec/* /var/www/jarkom/workersec
service php7.0-fpm start

mkdir /var/www/jarkom

cp ./lb/worker/index.php /var/www/jarkom/index.php

rm /etc/nginx/sites-enabled/defaultnginx

cp defaultnginxworkersec /etc/nginx/sites-available/defaultnginxworkersec
ln -s /etc/nginx/sites-available/defaultnginxworkersec /etc/nginx/sites-enabled/defaultnginxworkersec

service nginx restart

nginx -t
```

Worker tersebut harus dapat di akses dengan tamat.xxx.com dengan alias www.tamat.xxx.com

- pochinki :
```
echo 'zone "tamat.it32.com" {
    type master;
    file "/etc/bind/jarkom/tamat.it32.com";
};' >> /etc/bind/named.conf.local

echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     tamat.it32.com. root.tamat.it32.com. (
                                2         ; Serial
                                604800    ; Refresh
                                86400     ; Retry
                                2419200   ; Expire
                                604800 )  ; Negative Cache TTL
;
@       IN      NS      tamat.it32.com.
@       IN      A       10.63.1.4       ; IP Severny
www     IN      CNAME   tamat.it32.com.' > /etc/bind/jarkom/tamat.it32.com

service bind9 restart

echo 'Configuration Complete'
```

## SCRIPT

- POCHINKI:
  
  ```
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
  ```

- GEORGOPOL:
  
  ```
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

  ```
