dir="/Users/oliviamurray/Documents/FETCH/fetch_dti_prequal_radboudumc"

for patient in ${dir}/*; do
  patient_id=$(basename "$patient")
  
  for t1 in $patient/*_t1_MPRage_sag.nii.gz; do
  
  
  # Check if patient directory contains the expected file
  if [ -f "$patient"/*_t1_MPRage_sag.nii.gz ]; then
    
    # Process the file here, e.g., copy it to another directory
    echo "Processing $patient_id"
    # You can add your rsync or other operations here
    #echo p09383om@csf3.itservices.manchester.ac.uk:~/scratch/fetch_radboudumc_bedpostx/$patient_id
    cp  $t1 /Users/oliviamurray/Documents/FETCH/fetch_radboudumc_bedpostx/$patient_id/t1.nii.gz
  else
    echo "File not found in $patient_id"

  fi
  done
done
