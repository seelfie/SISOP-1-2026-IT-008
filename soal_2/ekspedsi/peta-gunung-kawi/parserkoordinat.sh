#!/bin/bash

#--ambil data penting--
awk '/"id"/ {gsub(/.*"id": "|",/, "", $0); id = $0} \
     /"site_name"/ {gsub(/.*"site_name": "|",/, "", $0); site_name = $0} \
     /"latitude"/ {gsub(/.*"latitude": |,/, "", $0); latitude = $0} \
     /"longitude"/ {gsub(/.*"longitude": |,/, "", $0); longitude = $0; print id","site_name","latitude","longitude}' \
     gsxtrack.json > titik-penting.txt

