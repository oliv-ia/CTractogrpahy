#!/bin/bash
for file in /Users/oliviamurray/Documents/FETCH/FETCH_URL_nnUNet_oct/nnUNet_raw/Dataset700_CST/labelsTr/*; do
file_b=$( basename $file )
id=$(echo "$file_b" | cut -d'_' -f1)
echo $id
done