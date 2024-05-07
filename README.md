# Jarkom-Modul-2-IT32-2024

## Laporan Resmi Praktikum Jarkom Modul 4 2024

**Kelompok IT32 - Menggunakan Topologi 2**

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



### Soal & Pengerjaan:

Untuk membantu pertempuran di Erangel, kamu ditugaskan untuk membuat jaringan komputer yang akan digunakan sebagai alat komunikasi. Sesuaikan rancangan Topologi dengan rancangan dan pembagian yang berada di link yang telah disediakan, dengan ketentuan nodenya sebagai berikut :

DNS Master akan diberi nama Pochinki, sesuai dengan kota tempat dibuatnya server tersebut

Karena ada kemungkinan musuh akan mencoba menyerang Server Utama, maka buatlah DNS Slave Georgopol yang mengarah ke Pochinki

Markas pusat juga meminta dibuatkan tiga Web Server yaitu Severny, Stalber, dan Lipovka. Sedangkan Mylta akan bertindak sebagai Load Balancer untuk server-server tersebut

Karena para pasukan membutuhkan koordinasi untuk mengambil airdrop, maka buatlah sebuah domain yang mengarah ke Stalber dengan alamat airdrop.it32.com dengan alias www.airdrop.it32.com

Para pasukan juga perlu mengetahui mana titik yang sedang di bombardir artileri, sehingga dibutuhkan domain lain yaitu redzone.it32.com dengan alias www.redzone.it32.com yang mengarah ke Severny

Markas pusat meminta dibuatnya domain khusus untuk menaruh informasi persenjataan dan suplai yang tersebar. Informasi persenjataan dan suplai tersebut mengarah ke Mylta dan domain yang ingin digunakan adalah loot.it32.com dengan alias www.loot.it32.com

Pastikan domain-domain tersebut dapat diakses oleh seluruh komputer (client) yang berada di Erangel

Beberapa daerah memiliki keterbatasan yang menyebabkan hanya dapat mengakses domain secara langsung melalui alamat IP domain tersebut. Karena daerah tersebut tidak diketahui secara spesifik, pastikan semua komputer (client) dapat mengakses domain redzone.it32.com melalui alamat IP Severny (Notes : menggunakan pointer record)

Akhir-akhir ini seringkali terjadi serangan siber ke DNS Server Utama, sebagai tindakan antisipasi kamu diperintahkan untuk membuat DNS Slave di Georgopol untuk semua domain yang sudah dibuat sebelumnya

Kamu juga diperintahkan untuk membuat subdomain khusus melacak airdrop berisi peralatan medis dengan subdomain medkit.airdrop.it32.com yang mengarah ke Lipovka

Terkadang red zone yang pada umumnya di bombardir artileri akan dijatuhi bom oleh pesawat tempur. Untuk melindungi warga, kita diperlukan untuk membuat sistem peringatan air raid dan memasukkannya ke domain siren.redzone.it32.com dalam folder siren dan pastikan dapat diakses secara mudah dengan menambahkan alias www.siren.redzone.it32.com dan mendelegasikan subdomain tersebut ke Georgopol dengan alamat IP menuju radar di Severny

Markas juga meminta catatan kapan saja pesawat tempur tersebut menjatuhkan bom, maka buatlah subdomain baru di subdomain siren yaitu log.siren.redzone.it32.com serta aliasnya www.log.siren.redzone.it32.com yang juga mengarah ke Severny

Setelah pertempuran mereda, warga Erangel dapat kembali mengakses jaringan luar, tetapi hanya warga Pochinki saja yang dapat mengakses jaringan luar secara langsung. Buatlah konfigurasi agar warga Erangel yang berada diluar Pochinki dapat mengakses jaringan luar melalui DNS Server Pochinki

Karena pusat ingin sebuah website yang ingin digunakan untuk memantau kondisi markas lainnya maka deploy lah webiste ini (cek resource yg lb) pada severny menggunakan apache

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
