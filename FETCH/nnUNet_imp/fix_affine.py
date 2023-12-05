import SimpleITK as sitk
import nibabel as nib
from pathlib import Path
def threshold_mask(mask_path):
    img = nib.load(mask_path)

    data = img.get_fdata()

    data[data<0.01] = 0 
    data[data!=0] = 1   
    final_img = nib.Nifti1Image(data, img.affine) 
    nib.save(final_img, mask_path)
def np2itk(arr,original_img):
    img = sitk.GetImageFromArray(arr)
    img.SetSpacing(original_img.GetSpacing())
    img.SetOrigin(original_img.GetOrigin())
    img.SetDirection(original_img.GetDirection())
    return img
path_lab = "/Users/oliviamurray/Documents/FETCH/FETCH_URL_nnUNet_oct/nnUNet_raw/Dataset700_CST/labelsTs"
path_img = "/Users/oliviamurray/Documents/FETCH/FETCH_URL_nnUNet_oct/nnUNet_raw/Dataset700_CST/imagesTs"
labels = Path(path_lab)
for label in labels.iterdir():
    if "DS_Store" not in label.name:
        print(label.name)
        file = label.name
        p = "/Users/oliviamurray/Documents/FETCH/FETCH_URL_nnUNet_oct/nnUNet_raw/Dataset700_CST/labelsTs/" + str(label.name)
        print(p)
        path_ct = path_img + "/" + str(file[:file.find('.nii.gz')]+"_0000.nii.gz")
        path_label = path_lab + "/" + str(label.name)
        img = sitk.ReadImage(path_ct)
        arr_img = sitk.ReadImage(path_label)
        
        arr = sitk.GetArrayFromImage(arr_img)
        sitk.WriteImage(np2itk(arr,img),p)
        threshold_mask(p)
        

