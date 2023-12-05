import shutil
import numpy as np
from pathlib import Path
ct_path = "/Users/oliviamurray/Documents/FETCH/ct_umcu_nifti_c"
new_ct_path = "/Users/oliviamurray/Documents/FETCH/selected_ct_umcu"
import pathlib
#name_string = np.array(['_Brain_0.5.nii.gz', '_Brain_1.0.nii.gz', '_Head_1.0.nii.gz', '_Head_1.0_Vol..nii.gz', '_Head_0.5.nii.gz', '_Head_3.0.nii.gz', '_Head_0.5_Vol._AIDR_3D_eSTD.nii.gz','_Brain_0.5_Helical_AIDR_3D_STD_Vol._Brain_Helical.nii.gz'])
name_string = np.array(['_TS_AX0.9_0.45.nii.gz', '__TS_AX0.9_0.45.nii.gz', '_MPR_AX.nii.gz', 'HE.nii.gz', 'AX.nii.gz', "AX_.nii,gz", "_TS_AX0.9_0.45,_iDose_(2).nii.gz", "_Hersenen_5.0_MPR_ax.nii.gz", "_TS_AX1_0.5,_iDose_(2).nii.gz", "_MPR,_5_4_AX.nii.gz", "_TS_0.625.nii.gz", "_HE_5_5.nii.gz", "_.nii.gz", "_TS_UB,_1_MM.nii.gz", "_Hersenen_5.0_SPOd.nii.gz", "_Head_5.0_MPR.nii.gz", "_Hersenen_seq_3.0_J40s_3.nii.gz", "_Head_2.0_H22s.nii.gz", "_TS_0.625_BL.nii.gz", "_MPR,_SCHEDEL_6_6.nii.gz", "_Routinespiraal_2.0_H30s.nii.gz", "_TS_AX1_0.5.nii.gz"])
patients = Path(ct_path)

for patient in patients.iterdir():
    if ".DS_Store" not in patient.name:
        scans = Path(patient)
        for scan in scans.iterdir():
               
                if scan.name[7:] in name_string or scan.name[8:] in name_string:
                   print(" ")
                   dest_path = new_ct_path + "/" + patient.name 
                   print(dest_path)
                   shutil.copy(scan, dest_path)
                
                    
                    
