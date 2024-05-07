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

  `auto eth0
  iface eth0 inet static
      address 10.63.2.4
      netmask 255.255.255.0
      gateway 10.63.2.1`
    
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

command di console:
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
1. b). DNS slave georgopol



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
  sudo apt update
  sudo apt install apache2
  systemctl start apache2
  systemctl enable apache2
  sudo cp -r /path/to/your/website/* /var/www/html/
  
  
  # Set izin file jika diperlukan
  # sudo chmod -R 755 /var/www/html/*
  
  
  # Restart Apache untuk menerapkan perubahan
  sudo systemctl restart apache2

  ```

Tapi pusat merasa tidak puas dengan performanya karena traffic yag tinggi maka pusat meminta kita memasang load balancer pada web nya, dengan Severny, Stalber, Lipovka sebagai worker dan Mylta sebagai Load Balancer menggunakan apache sebagai web server nya dan load balancernya

Mereka juga belum merasa puas jadi pusat meminta agar web servernya dan load balancer nya diubah menjadi nginx

Markas pusat meminta laporan hasil benchmark dengan menggunakan apache benchmark dari load balancer dengan 2 web server yang berbeda tersebut dan meminta secara detail dengan ketentuan:
Nama Algoritma Load Balancer
Report hasil testing apache benchmark 
Grafik request per second untuk masing masing algoritma. 
Analisis

Karena dirasa kurang aman karena masih memakai IP markas ingin akses ke mylta memakai mylta.xxx.com dengan alias www.mylta.xxx.com (sesuai web server terbaik hasil analisis kalian)

Agar aman, buatlah konfigurasi agar mylta.xxx.com hanya dapat diakses melalui port 14000 dan 14400.

Apa bila ada yang mencoba mengakses IP mylta akan secara otomatis dialihkan ke www.mylta.xxx.com

Karena probset sudah kehabisan ide masuk ke salah satu worker buatkan akses direktori listing yang mengarah ke resource worker2

Worker tersebut harus dapat di akses dengan tamat.xxx.com dengan alias www.tamat.xxx.com
