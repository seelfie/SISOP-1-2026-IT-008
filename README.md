# SISOP-1-2026-IT-008

Silfi Rochmatul Auliyah (5027251008)

---

## Reporting

### Soal 1
#### Penjelasan 
Pada soal ini diminta untuk membantu Pak Rusdi, seorang kondektur magang untuk menyusun laporan lengkap mengenai penumpang kereta dengan menganalisis data dalam file `passenger.csv` menggunakan command linux dan awk. 

Pada soal ini diminta untuk menganalisis data sebagai berikut. 
1. Total penumpang kereta 
2. Total gerbong kereta
3. Menemukan penumpang dengan usia tertua di kereta
4. Rata-rata usia penumpang kereta
5. Total penumpang Business Class

Langkah pertama adalah mengunduh file `passenger.csv` kemudian menempatkannya pada folder yang sama dengan `KANJ.sh`. 

Selanjutnya karena script ini dijalankan dengan menerima argumen dari user yaitu `awk -f KANJ.sh passenger.csv (a/b/c/d/e)`, maka argumen tersebut diakses menggunakan variabel bawaan awk yaitu `ARGV[2]` karena kata yang akan diambil terdapat dalam urutan ke [2]. Kemudian, argumen tersebut disimpan ke dalam variabel `pilihan`. 
```sh 
BEGIN {
	FS=","
	pilihan = ARGV[2]
	delete ARGV[2]
      }
```
Kemudian proses analisis data sebagai  berikut. 
**a. Menghitung seluruh baris data penumpang dan menyusun laporan**
Untuk langkah pertama adalah menghitung baris data penumpang dalam file dengan mengecualikan header. 
```sh 
NR>1 && pilihan == "a" {count++}
```
Kemudian mencatat jumlah penumpang dalam laporan. 
```sh
if (pilihan == "a") print "Jumlah seluruh penumpang KANJ adalah", count, "orang"
```

**b. Menghitung total gerbong kereta**
Untuk langkah keduanya adalah menghitung jumlah gerbong KANJ dalam file dengan menyimpan nilai setiap gerbong dan mengecualikan header. Nilai  setiap gerbong disimpan sebagai kunci di dalam array gerbong[] agar tidak terhitunng dua kali. 
```sh
NR>1 && pilihan == "b" {gsub(/\r/, "", $4); gerbong[$4]++}
```
Kemudian mencatat jumlah gerbong dalam laporan.
```sh
else if (pilihan == "b") print "Jumlah gerbong penumpang KANJ adalah", length(gerbong)
```

**c. Menemukan penumpang dengan usia tertua di kereta**
Untuk langkah ketiga adalah membandingkan usia setiap penumpang kereta untuk menemukan penumpang dengan usia tertua. 
```sh
NR>1 && pilihan == "c" {if ($2 > max) {max = $2; nama = $1}}
```
Kemudian mencatat nama dan umur penumpang tertua dalam laporan.
```sh
else if (pilihan == "c") print nama, "adalah penumpang kereta tertua dengan usia", max, "tahun"
```

**d. Menghitung rata-rata usia penumpang kereta**
Untuk langkah keempat adalah menghitung rata-rata usia dengan menghitung baris usia dan baris total penumpang kemudian membaginya. 
```sh
NR>1 && pilihan == "d" {sum+=$2; count++}
```
Kemudian mencatat rata-rata usia dalam laporan. 
```sh
else if (pilihan == "d") printf "Rata-rata usia penumpang adalah %.0f tahun", sum/count
```

**e. Menghitung jumlah penumpang business class**
Untuk langkah kelima adalah menghitung jumlah penumpang business class dengan memfilter baris kelas bernilai "Business". 
```sh
NR>1 && pilihan == "e" && $3 == "Business" {kelas++}
```
Kemudian jumlah penumpang business class dicatat dalam laporan. 
```sh
else if (pilihan == "e") print "Jumlah penumpang business class ada", kelas, "orang"
```

Selain itu jika opsi yang dimasukkan saat menjalankan program adalah selain a/b/c/d/e maka akan menjalankan perintah berikut. 
```sh
else print  "Soal tidak dikenali. Gunakan a, b, c, d, atau e.\n" "Contoh penggunaan: awk -f KANJ.sh passenger.csv (a/b/c/d/e)"
```

#### Output 
1. Mengunduh file passenger.csv 
![alt text](assets/soal_1/unduh_csv.png)
2. opsi a - menampilkan laporan jumlah seluruh penumpang KANJ
![alt text](assets/soal_1/a_JumlahPenumpang.png)
3. opsi b - menampilkan laporan jumlah gerbong KANJ
![alt text](assets/soal_1/b_JumlahGerbong.png)
4. opsi c - menampilkan laporan penumpang tertua KANJ
![alt text](assets/soal_1/c_PenumpangTertua.png)
5. opsi d - menampilkan laporan rata-rata usia penumpang 
![alt text](assets/soal_1/d_rata2usia.png)
6. opsi e - menampilkan laporan jumlah penumpang business class
![alt text](assets/soal_1/e_PenumpangBusinessClass.png)
7. Jika memasukkan opsi selain a/b/c/d/e
![alt text](assets/soal_1/TidakSesuaiOpsi.png)

#### Kendala
tidak ada kendala 

### Soal 2
#### Penjelasan 
#### Output 
