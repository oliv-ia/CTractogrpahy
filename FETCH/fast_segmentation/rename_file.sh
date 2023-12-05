#!/bin/bash
#cd /Users/oliviamurray/Documents/FETCH/selected_ct_lumc/
#directory="/Users/oliviamurray/Documents/FETCH/selected_ct_lumc/"

# Iterate through the main directory
# find "$directory" -type d -print0 | while IFS= read -r -d '' dir; do
#    echo "$dir"
    # Iterate through the files in each subdirectory
#    find "$dir" -maxdepth 1 -type f -name "*.nii.gz" -print0 | while IFS= read -r -d '' file; do
#        echo "$file"
#        new_file="${file%.nii.gz}_CT.nii.gz"
#        #mv "$file" "$new_file"
#        echo "Renamed: $file to $new_file"
#    done
#done
cd /Users/oliviamurray/Documents/FETCH/selected_ct_lumc
for patient in *
do
    echo ${patient}
    cp /Users/oliviamurray/Documents/FETCH/selected_ct_lumc/${patient}/CT_0000.nii.gz /Users/oliviamurray/Documents/FETCH/FAST_segmentation/fast_nnUNet/nnUNet_raw/Dataset600_FASTnoHaem/imagesTr/${patient}_0000.nii.gz
done