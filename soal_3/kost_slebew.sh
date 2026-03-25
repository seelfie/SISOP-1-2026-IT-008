#!/bin/bash

if [ "$1" == "--check-tagihan" ]; then
    awk -F',' '$5=="Menunggak" {print $1 " menunggak"}' data/penghuni.csv >> log/tagihan.log
    exit 0
fi

echo '  _  __         _    _____ _      _                   '
echo ' | |/ /        | |  / ____| |    | |                  '
echo ' | '"'"' / ___  ___| |_| (___ | | ___| |__   _____      __'
echo ' |  < / _ \/ __| __|\___ \| |/ _ \ '"'"'_ \ / _ \ \ /\ / /'
echo ' | . \ (_) \__ \ |_ ____) | |  __/ |_) |  __/\ V  V / '
echo ' |_|\_\___/|___/\__|_____/|_|\___|_.__/ \___| \_/\_/  '

while true; do 
    echo ""
    echo "========================================"
    echo "     SISTEM MANAJEMEN KOST SLEBEW      "
    echo "========================================"
    echo " ID | OPTION"
    echo "----------------------------------------"
    echo "  1 | Tambah Penghuni Baru"
    echo "  2 | Hapus Penghuni"
    echo "  3 | Tampilkan Daftar Penghuni"
    echo "  4 | Update Status Penghuni"
    echo "  5 | Cetak Laporan Keuangan"
    echo "  6 | Kelola Cron (Pengingat Tagihan)"
    echo "  7 | Exit Program"
    echo "========================================"
    echo -n "Enter option [1-7]: "
    read pilihan

    if [ "$pilihan" == "1" ]; then
        echo "========================================"
        echo "            TAMBAH PENGHUNI             "
        echo "========================================"
        echo -n "Masukkan nama: "
        read nama
        echo -n "Masukkan kamar: "
        read kamar
            if grep -q ",$kamar," data/penghuni.csv; then
                echo "Kamar tidak tersedia."
                continue
            else 
                echo "Kamar tersedia"
            fi
        echo -n "Masukkan harga sewa: "
        read harga 
            if ! echo "$harga" | grep -qE '^[0-9]+$'; then 
                echo "Harga sewa tidak valid."
                continue
            fi 
        echo -n "Masukkan tanggal masuk: "
        read tanggal
            if ! echo "$tanggal" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'; then
                echo "Format tanggal harus YYYY-MM-DD"
                continue
            fi
            today=$(date +%s)
            input=$(date -d "$tanggal" +%s)
            if [ -z "$input" ]; then
                echo "Tanggal tidak valid."
                continue
            fi
            if [ "$input" -gt "$today" ]; then
                echo "Tanggal tidak valid."
                continue
            fi
        echo -n "Masukkan status awal (Aktif/Menunggak): "
        read status
            if [ "$status" != "Aktif" ] && [ "$status" != "Menunggak" ]; then
                echo "Status harus Aktif/Menunggak."
                continue
            fi
        echo "$nama,$kamar,$harga,$tanggal,$status" >> data/penghuni.csv
        echo "Penghuni $nama berhasil ditambahkan ke kamar $kamar dengan status $status."

    elif [ "$pilihan" == "2" ]; then 
        echo "========================================"
        echo "            HAPUS PENGHUNI              "
        echo "========================================"
        echo -n "Masukkan nama penghuni yang akan dihapus: "
        read nama 
        if grep -q "$nama" data/penghuni.csv; then
            baris=$(grep "$nama" data/penghuni.csv)
            today=$(date +%Y-%m-%d)
            echo "$baris,$today" >> sampah/history_hapus.csv
            
            grep -v "$nama" data/penghuni.csv > tmp.csv
            mv tmp.csv data/penghuni.csv
            echo "Data penghuni \"$nama\" berhasil diarsipkan ke sampah/history.csv dan dihapus dari sistem."
            echo "Tekan [ENTER] untuk kembali ke menu..."
            read
        else 
            echo "Penghuni dengan nama /"$nama/" tidak ditemukan."
        fi 
    
    elif [ "$pilihan" == "3" ]; then 
        echo "==========================================================="
        echo "               DAFTAR PENGHUNI KOST SLEBEW           "
        echo "==========================================================="
        echo " No | Nama            | Kamar  | Harga Sewa   | Status       "
        echo "-----------------------------------------------------------"
        awk -F',' '
        function format_harga(n) {
        hasil = ""
        while (n >= 1000) {
            sisa = n % 1000
            n = int(n / 1000)
            hasil = "." sprintf("%03d", sisa) hasil
            }
        return "Rp" n hasil
        }
        {
            no++
            printf " %s  | %-15s | %-6s | %-12s | %s\n", no, $1, $2, format_harga($3), $5
            print "-----------------------------------------------------------"
        }' data/penghuni.csv
        awk -F',' '{
            total++
            if ($5 == "Aktif") aktif++
            else menunggak++
        } END {
            print "==========================================================="
            print "Total:", total, "| Aktif:", aktif, "| Menunggak:", menunggak
            print "==========================================================="
        }' data/penghuni.csv

        echo "Tekan [ENTER] untuk kembali ke menu..."
        read
    
    elif [ "$pilihan" == "4" ]; then 
        echo "==========================================================="
        echo "                       UPDATE STATUS           "
        echo "==========================================================="
        echo -n "Masukkan Nama Penghuni: "
        read nama
            if ! grep -q "^$nama," data/penghuni.csv; then
                echo "penghuni dengan nama $nama tidak terdaftar."
                continue
            else 
                echo -n "Masukkan status baru (Aktif/Menunggak): "
                read status
                    if echo "$status" | grep -iqE '^aktif$'; then
                        status="Aktif"
                    elif echo "$status" | grep -iqE '^menunggak$'; then
                        status="Menunggak"
                    else
                        echo "Status harus Aktif atau Menunggak!"  
                        continue
                    fi 
                awk -F',' -v nama="$nama" -v status="$status" '
                $1 == nama {$5 = status}  
                {print}                   
                ' OFS=',' data/penghuni.csv > tmp.csv
                mv tmp.csv data/penghuni.csv
                echo "Status $nama berhasil diubah menjadi: $status"
            fi
       
    elif [ "$pilihan" == "5" ]; then 
        mkdir -p rekap
        { echo "==========================================================="
        echo "               LAPORAN KEUANGAN KOST SLEBEW                "
        echo "==========================================================="
        awk -F',' '
        function format_harga(n) {
            hasil = ""
            while (n >= 1000) {
                sisa = n % 1000
                n = int(n / 1000)
                hasil = "." sprintf("%03d", sisa) hasil
            }
            return "Rp" n hasil
        } 
        {
            total++
            if ($5 == "Aktif") pemasukan += $3
            else if ($5 == "Menunggak") tunggakan += $3
        } END {
            print "Total pemasukan (Aktif) :", format_harga(pemasukan)
            print "Total tunggakan         :", format_harga(tunggakan)
            print "Jumlah kamar terisi     :", total
        }' data/penghuni.csv
        echo "-----------------------------------------------------------"
        echo " Daftar penghuni menunggak:"
        awk -F',' '$5 == "Menunggak" {print "   - " $1; found++}
        END {if (!found) print "   Tidak ada tunggakan."}' data/penghuni.csv
        echo "==========================================================="
        } > rekap/laporan_bulanan.txt
        cat rekap/laporan_bulanan.txt
        echo "Laporan berhasil disimpan ke rekap/laporan_bulanan.txt"
        echo "Tekan [ENTER] untuk kembali ke menu..."
        read

    elif [ "$pilihan" == "6" ]; then
        while true
        do
            clear
            echo "================================="
            echo "        MENU KELOLA CRON         "
            echo "================================="
            echo "1. Lihat Cron Job Aktif          "
            echo "2. Daftarkan Cron Job Pengingat  "
            echo "3. Hapus Cron Job Pengingat      "
            echo "4. Kembali                       "
            echo "================================="
            echo -n "Pilih [1-4]: " 
            read pilih

            case $pilih in
                1)
                    echo "--- Daftar Cron Job Pengingat Tagihan ---"
                    crontab -l
                    read -p "Tekan [ENTER] untuk kembali..."
                    ;;

                2)
                    read -p "Masukkan Jam (0-23): " jam
                        if ! echo "$jam" | grep -qE '^[0-9]+$' || [ "$jam" -lt 0 ] || [ "$jam" -gt 23 ]; then
                            echo "Jam tidak valid."
                            continue
                        fi
                    read -p "Masukkan Menit (0-59): " menit
                        if ! echo "$menit" | grep -qE '^[0-9]+$' || [ "$menit" -lt 0 ] || [ "$menit" -gt 59 ]; then
                            echo "Menit tidak valid."
                            continue
                        fi

                    script_path="$(pwd)/$(basename "$0")"

                    cron_job="$menit $jam * * * $script_path --check-tagihan"

                    echo "$cron_job" | crontab -

                    echo "Cron job berhasil ditambahkan."
                    read -p "Tekan [ENTER] untuk kembali..."
                    ;;

                3)
                    crontab -r
                    echo "Cron job berhasil dihapus."
                    read -p "Tekan [ENTER] untuk kembali..."
                    ;;

                4)
                    break
                    ;;

                *)
                    echo "Pilihan tidak valid."
                    read -p "Tekan [ENTER]..."
                    ;;
            esac
        done
    
    elif [ "$pilihan" == "7" ]; then
        echo "Keluar dari program..."
        break
    fi
done
