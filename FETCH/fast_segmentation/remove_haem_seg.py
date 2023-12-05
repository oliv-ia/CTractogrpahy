import SimpleITK as sitk
import numpy as np
import matplotlib.pyplot as plt
import os


def subtract_segmentations(seg1_path, seg2_path):
    # Read the segmentations
    seg1 = sitk.ReadImage(seg1_path)
    seg2 = sitk.ReadImage(seg2_path)

    # Convert to numpy arrays for manipulation
    seg1_arr = sitk.GetArrayFromImage(seg1)
    seg2_arr = sitk.GetArrayFromImage(seg2)

    # Find overlapping indices
    overlap_indices = np.logical_and(seg1_arr != 0, seg2_arr != 0)

    # Change overlapping pixels in seg1 to 0
    seg1_arr[overlap_indices] = 0

    # Convert back to SimpleITK image
    subtracted = sitk.GetImageFromArray(seg1_arr)
    subtracted.CopyInformation(seg1)

    return subtracted

patient_list = ["2-15-001",
"2-15-004",    
"2-15-005",             
"2-15-007",      
"2-15-008",
"2-15-011",
"2-15-012",
"2-15-013",
"2-15-014",
"2-15-015",
"2-16-017",
"2-16-018",
"2-16-019",
"2-16-020",
"2-16-021",
"2-16-022",
"2-16-023",
"2-16-025",
"2-16-026",
"2-16-030",
"2-17-031",
"2-17-032",
"2-17-035",
"2-17-037",
"2-17-039",
"2-18-002",
"2-18-004"]
for patient in patient_list:
    print(patient)
    if os.path.exists("/Users/oliviamurray/Documents/FETCH/t1_lumc/" + str(patient) +"/bet_seg_CTspace.nii.gz"):

        # Provide the paths to the two segmentations
        seg1_path = "/Users/oliviamurray/Documents/FETCH/t1_lumc/" + str(patient) +"/bet_seg_CTspace.nii.gz"
        seg2_path = "/Users/oliviamurray/Documents/FETCH/FAST_segmentation/lumc_haematoma_segs/" + str(patient) + "/CT.nii.gz"

        # Perform subtraction
        result = subtract_segmentations(seg1_path, seg2_path)

        # Convert to numpy arrays for visualization
        seg1_arr = sitk.GetArrayFromImage(sitk.ReadImage(seg1_path))
        seg2_arr = sitk.GetArrayFromImage(sitk.ReadImage(seg2_path))
        result_arr = sitk.GetArrayFromImage(result)

        sitk.WriteImage(result, "/Users/oliviamurray/Documents/FETCH/FAST_segmentation/lumc_fast_minus_haem_segs/" + str(patient) + ".nii.gz")