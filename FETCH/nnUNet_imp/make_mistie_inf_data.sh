#!/bin/bash
cd /Users/oliviamurray/Downloads/MISTIE_III/
mkdir -p /Users/oliviamurray/Documents/MISTIE_inference/images
mkdir -p /Users/oliviamurray/Documents/MISTIE_inference/predictions
for patient in /Users/oliviamurray/Downloads/MISTIE_III/*; do
if [ -d $patient/'Diagnostic CT' ]; then

    if [ ! -z "$(ls -A $patient/'Diagnostic CT')" ]; then

        for file in $patient/'Diagnostic CT'/*; do
        #echo $file
        #echo patient $patient
        file_name=${file##*/}
        filename=$( basename $file )
        echo $file_name
        #echo $patient"/Diagnostic CT"/$filename
        cp $patient/'Diagnostic CT'/$file_name /Users/oliviamurray/Documents/MISTIE_inference/images/
        done
    fi
fi

done 