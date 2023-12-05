#!/bin/bash --login
#$ -l nvidia_v100  
#$ -pe smp.pe 4
export OMP_NUM_THREADS=$NSLOTS
module load apps/binapps/fsl/6.0.5
export patient=2-18-002
bedpost_dir=/mnt/iusers01/ct01/p09383om/scratch/fetch_lumc_bedpostx/2-18-002.bedpostX
mkdir -p /mnt/iusers01/ct01/p09383om/scratch/xtract_experiment


xtract -bpx /mnt/iusers01/ct01/p09383om/scratch/fetch_lumc_bedpostx/2-18-002.bedpostX -out /mnt/iusers01/ct01/p09383om/scratch/xtract_experiment/output -species HUMAN -stdwarp /mnt/iusers01/ct01/p09383om/scratch/fetch_lumc_bedpostx/2-18-002.bedpostX/xfms/standard2diff.nii.gz /mnt/iusers01/ct01/p09383om/scratch/fetch_lumc_bedpostx/2-18-002.bedpostX/xfms/diff2standard.nii.gz 