#!/bin/bash

#--mencari titik pusat--
awk -F',' 'NR == 1 {lat1=$3; lon1=$4}
	       NR == 3 {lat2=$3; lon2=$4}
END {
      longitude_pusat = (lon1 + lon2) / 2
      latitude_pusat = (lat1 + lat2) / 2 
      print "Koordinat pusat: " latitude_pusat "," longitude_pusat
}' titik-penting.txt > posisipusaka.txt

