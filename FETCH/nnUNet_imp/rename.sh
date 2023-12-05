#!/bin/bash
for file in /mnt/iusers01/ct01/p09383om/scratch/MISTIE_inference/images/*; do
basename=$( basename $file .nii.gz_0000 )
new_name=${basename}_0000.nii.gz
mv $file /mnt/iusers01/ct01/p09383om/scratch/MISTIE_inference/images/$new_name
done
