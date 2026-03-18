#!/bin/bash

BEGIN {
	FS=","
	pilihan = ARGV[2]
	delete ARGV[2]
}
#--a--
NR>1 && pilihan == "a" {count++}

#--b--
NR>1 && pilihan == "b" {gsub(/\r/, "", $4); gerbong[$4]++}

#--c--
NR>1 && pilihan == "c" {if ($2 > max) {max = $2; nama = $1}}

#--d--
NR>1 && pilihan == "d" {sum+=$2; count++} 

#--e--
NR>1 && pilihan == "e" && $3 == "Business" {kelas++}

END {
      if (pilihan == "a") print "Jumlah seluruh penumpang KANJ adalah", count, "orang"

      else if (pilihan == "b") print "Jumlah gerbong penumpang KANJ adalah", length(gerbong)

      else if (pilihan == "c") print nama, "adalah penumpang kereta tertua dengan usia", max, "tahun"

      else if (pilihan == "d") printf "Rata-rata usia penumpang adalah %.0f", sum/count, "tahun"

      else if (pilihan == "e") print "Jumlah penumpang business class ada", kelas, "orang"

      else print  "Soal tidak dikenali. Gunakan a, b, c, d, atau e."
} 
