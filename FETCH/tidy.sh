#!/bin/bash
folder1="/Users/oliviamurray/Documents/FETCH/FETCH_URL_nnUNet/nnUNet_raw/Dataset601_CST_small/imagesTr"
folder2="/Users/oliviamurray/Documents/FETCH/FETCH_URL_nnUNet/nnUNet_raw/Dataset601_CST_small/labelsTr"

# Create an array of prefixes from folder 1
declare -A folder1_prefixes
for filename in "$folder1"/*_0000.nii.gz; do
    base=$(basename "$filename" _0000.nii.gz)
    folder1_prefixes["$base"]=1
done

# Iterate through files in folder 2 and delete if the prefix doesn't exist in folder 1
for filename in "$folder2"/*.nii; do
    base=$(basename "$filename" .nii)
    if [[ ! ${folder1_prefixes["$base"]} ]]; then
        rm "$filename"
        echo "Deleted: $filename"
    fi
done