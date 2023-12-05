import SimpleITK as sitk
filedir= '/Users/oliviamurray/Documents/MISTIE_inference/predictions_cst/6299-188_CT_20160321_151859296_Diagnostic_CT.nii.gz'
savedir='/Users/oliviamurray/Documents/MISTIE_inference/flipped_299.nii.gz'
img = sitk.ReadImage(filedir, imageIO= "NiftiImageIO")
flipped_img = sitk.Flip(img, [True, False, False])
#sitk.WriteImage(flipped_img, '/Users/oliviamurray/Documents/MISTIE_inference/flipped_299.nii.gz')

img1 = sitk.ReadImage(savedir)
input1_orientation = sitk.DICOMOrientImageFilter_GetOrientationFromDirectionCosines(img1.GetDirection())
print(f"Input Orientation: {input1_orientation}")
oriented_img1 = sitk.DICOMOrient(img1, desiredCoordinateOrientation='RAS')
sitk.WriteImage(oriented_img1,'/Users/oliviamurray/Documents/MISTIE_inference/flipped_299.nii.gz' )