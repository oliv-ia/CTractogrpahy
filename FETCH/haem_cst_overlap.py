import numpy as np
import SimpleITK as sitk
from pathlib import Path
import pandas as pd
import re
import itk
import cv2
path = "/Users/oliviamurray/Documents/MISTIE_inference/predictions/"
path_2= "/Users/oliviamurray/Documents/MISTIE_inference/predictions_cst"
save_path = "/Users/oliviamurray/Documents/MISTIE_inference/output_full_oct.xlsx"
def GetFiles(filedir):
    entries = Path(filedir)
    fname, id, pathlist = [],[],[]
    idTick = 0
 
    for entry in entries.iterdir():
     if entry.name != ".DS_Store":
      print(entry.name)
      
      idTick += 1
      print(entry.name)
      patient_id_old = entry.name[1:4]
      patient_id = "6" + patient_id_old
      
      fname.append(patient_id)
      id.append(idTick)
      pathlist.append(str(filedir) + "/" + str(entry.name))

    return np.array(fname), np.array(id), np.array(pathlist)

def ReadMask(filedir):
    seg = sitk.ReadImage(filedir, imageIO= "NiftiImageIO")  #="NiftiImageIO")
    seg_arr = sitk.GetArrayFromImage(seg)
    seg_arr = seg_arr.astype(np.int64)
    return seg_arr
def compute_dice_coefficient(mask_pred, mask_gt):

  volume_sum = mask_gt.sum() + mask_pred.sum()
  if volume_sum == 0:
    return np.NaN
  volume_intersect = (mask_gt & mask_pred).sum()
  return 2*volume_intersect / volume_sum 
def precentage_compromised(mask_cst, mask_haem):
   volume_intersect = (mask_cst & mask_haem).sum()
   volume_comp = volume_intersect/ mask_cst.sum()
   return volume_comp
def precentage_compromised_flip(mask_cst, mask_haem):
   mask_cst = np.fliplr(mask_cst)
   volume_intersect = (mask_cst & mask_haem).sum()
   volume_comp = volume_intersect/ mask_cst.sum()
   return volume_comp
def slices_compromised(mask_cst, mask_haem):
   slices_cst = GetSlices(mask_cst)
   slices_haem =  GetSlices(mask_haem)
   count = 0
   for i in range (0, len(slices_cst)):
      sum = (mask_cst[i] & mask_haem[i]).sum()
      if sum != 0:
         count += 1
   return count

def slices_compromised_flip(mask_cst, mask_haem):
   mask_cst = np.fliplr(mask_cst)
   slices_cst = GetSlices(mask_cst)
   slices_haem =  GetSlices(mask_haem)
   count = 0
   for i in range (0, len(slices_cst)):
      sum = (mask_cst[i] & mask_haem[i]).sum()
      if sum != 0:
         count += 1
   return count
         


def compute_flip_dice_coefficient(mask_pred, mask_gt):
  mask_pred_f = np.fliplr(mask_pred)
  #mask_pred = cv2.flip(mask_pred, 1)
  volume_sum = mask_gt.sum() + mask_pred_f.sum()
  if volume_sum == 0:
    return np.NaN
  volume_intersect = (mask_gt & mask_pred_f).sum()
  return 2*volume_intersect / volume_sum 
def compute_slicewise_dice(mask_cst, mask_haem):
   slices_cst = GetSlices(mask_cst)
   slices_haem = GetSlices(mask_haem)
   for i in range (0, len(slices_haem)):
      dsc = compute_dice_coefficient(mask_cst[i], mask_haem[i])
      
   return dsc


def min_distance_between_masks(mask1, mask2):
    # Ensure both masks have the same shape
    if mask1.shape != mask2.shape:
        raise ValueError("Both masks must have the same shape.")

    # Convert binary masks to 8-bit single-channel images
    mask1 = np.uint8(mask1)
    mask2 = np.uint8(mask2)
    mask1 = np.uint8(mask1 * 255)  # Convert 0s and 1s to 0 and 255
    mask2 = np.uint8(mask2 * 255)
    print(mask1.dtype ,mask2.dtype)

    # Calculate the distance transform for each mask
    dist_transform1 = cv2.distanceTransform(mask1, cv2.DIST_L2, 3)
    dist_transform2 = cv2.distanceTransform(mask2, cv2.DIST_L2, 3)

    # Find the non-zero pixel coordinates in the masks
    non_zero_coords1 = np.transpose(np.nonzero(mask1))
    non_zero_coords2 = np.transpose(np.nonzero(mask2))

    min_distance = float('inf')

    # Calculate the minimum distance between non-zero pixels in the two masks
    for coord1 in non_zero_coords1:
        for coord2 in non_zero_coords2:
            distance = abs(dist_transform1[coord1[0], coord1[1]] - dist_transform2[coord2[0], coord2[1]])
            min_distance = min(min_distance, distance)

    return min_distance



  
def GetSlices(seg_arr):
    values= []
    for i in range(0,len(seg_arr)):
        #val = np.sum(seg_arr[i,:,:])
        val = np.sum(seg_arr[i])
        #if val >= 50750:
        if val > 0:
            values.append(i)
    return values
def GetBottomThird(mask_cst):
    values= []
    for i in range(0,len(mask_cst)):
        #val = np.sum(seg_arr[i,:,:])
        val = np.sum(mask_cst[i])
        #if val >= 50750:
        if val > 0:
            values.append(i)
    length = len(values)
    len_third = length//3
    len_23rd = len_third*2
    values = np.array(values)
    values_23rd = values[:len_23rd]
    values_23rd = values_23rd[2:]
    return values, values_23rd
import cv2
from scipy.ndimage import label, generate_binary_structure, maximum
def count_blobs_in_slice(mask_cst):
    # takes in 2d slice
    s = generate_binary_structure(2,2)
    s2 = [[1,1],
          [1,1]]     
    labeled_mask, num_labels = label(mask_cst, structure = s)
    return num_labels

def GetBlobs(mask_cst):

    slices, bottom_third = GetBottomThird(mask_cst)
    print("slices:", slices, "bottom 3rd:", bottom_third)

    blob_counts = []
    split_tract = False
    for slic in bottom_third:
        num_blobs = count_blobs_in_slice(mask_cst[slic])
        print("num blobs: ",num_blobs)
        if 0 < num_blobs < 2:
           
           split_tract = True
        
        blob_counts.append(num_blobs)

    if split_tract:
       return 1
    else:
       return 0


def count_blobs_in_3d_binary_image(binary_volume):
    # Convert the binary volume to an ITK image.
    binary_image = itk.GetImageFromArray(binary_volume.astype('uint8'))
    #instance = itk.Image[itk.RGBPixel[itk.UC], int].New(binary_image)
    # Apply a connected component filter to label the blobs.
    connected_components = itk.ConnectedComponentImageFilter.New(binary_image)
    connected_components.Update()

    # Calculate the number of connected components (blobs).
    label_map = connected_components.GetOutput()
    label_shape = itk.LabelShapeKeepNObjectsImageFilter.New(label_map)
    label_shape.SetBackgroundValue(0)  # Set the background value (usually 0)
    label_shape.SetNumberOfObjects(1)  # Count all labeled objects
    label_shape.Update()

    # Calculate the number of labeled objects (blobs).
    number_of_blobs = label_shape.GetNumberOfObjects()

    return number_of_blobs
def return_asymmetry(mask_cst):
  # takes in 2d slice
  s = generate_binary_structure(2,2)
  s2 = [[1,1],
        [1,1]]     
  labeled_mask, num_labels = label(mask_cst, structure = s)
  sums = []
  
  for j in range (1, num_labels+1):

    sum = np.sum(labeled_mask[labeled_mask == j])
    sums.append(sum)
  if len(sums) == 2:
      max = np.max(sums)
      min = np.min(sums)
      percentage = min/max
  else: 
      percentage = 1
      
  return percentage
def tract_asymmetry(mask_cst):
   slices, bottom_third = GetBottomThird(mask_cst)
   percentages = []
   for slic in bottom_third:
      percentage = return_asymmetry(mask_cst[slic])
      percentages.append(percentage)
   sum = np.sum(percentages)
   avg = sum/len(percentages)
   return avg
      

   
def GetSlicesArray(masks):
    slices_array =[]
    for image in masks:
        slices = GetSlices(image)
        slices_array.append((slices))
    return np.asarray(slices_array)
 

#ct_name, ct_ids, ct_pathlist = GetFiles(path)
haem_name, haem_ids, haem_pathlist = GetFiles(path)
cst_name, cst_ids, cst_pathlist = GetFiles(path_2)
print(haem_pathlist)
print(cst_pathlist)
cst_array = []
haem_array = []
for dir in cst_pathlist:
    cst = ReadMask(dir)
    cst_array.append(cst)
    
    print ("mask shape: ", cst.shape)
    print(" Read for ", dir)
for dir_h in haem_pathlist:
    haem = ReadMask(dir_h)
    haem_array.append(haem)
    
    print ("mask shape: ", haem.shape)
    print(" Read for ", dir_h)
dsc_array=[]
binary_dsc_array =[]
min_distance = []
flip_dsc_array =[]
binary_flip_dsc_array =[]
binary_combined_array = []
percent_compromised =[]
slice_compromised = []
percent_compromised_flip =[]
slice_compromised_flip =[]
split_tract = []
tract_asymmetries =[]
for i in range(0,len(cst_array)):
   print( "dice for : ", haem_name[i], cst_name[i])
   print(cst_array[i].shape, haem_array[i].shape)
   blobs = GetBlobs(cst_array[i])
   split_tract.append(blobs)
   dsc = compute_dice_coefficient(cst_array[i], haem_array[i])
   flip_dsc = compute_flip_dice_coefficient(cst_array[i], haem_array[i])
   percent_comp = precentage_compromised(cst_array[i], haem_array[i])
   percent_comp_flip = precentage_compromised_flip(cst_array[i], haem_array[i])
   percent_compromised_flip.append(percent_comp_flip)
   percent_compromised.append(percent_comp)
   slice_comp = slices_compromised(cst_array[i], haem_array[i])
   slice_compromised.append(slice_comp)
   slice_comp_flip = slices_compromised_flip(cst_array[i], haem_array[i])
   slice_compromised_flip.append(slice_comp_flip)
   tract_asymm = tract_asymmetry(cst_array[i])
   tract_asymmetries.append(tract_asymm)
   print(cst_array[i].shape, haem_array[i].shape)
   flip_dsc_array.append(flip_dsc)
   #min_dist = min_distance_between_masks(cst_array[i], haem_array[i])
   dsc_array.append(dsc)
   
   if dsc > 0:
      dsc_bin = 1
      binary_dsc_array.append(dsc_bin)
   else:
      dsc_bin = 0
      binary_dsc_array.append(dsc_bin)

   if flip_dsc > 0:
      flip_dsc_bin = 1
      binary_flip_dsc_array.append(flip_dsc_bin)
   else:
      flip_dsc_bin = 0
      binary_flip_dsc_array.append(flip_dsc_bin)
   if dsc > 0 or flip_dsc > 0:
      comb_dsc = 1
      binary_combined_array.append(comb_dsc)
   else:
      comb_dsc = 0
      binary_combined_array.append(comb_dsc)

      

  
   
print(binary_dsc_array)
#data = np.array([binary_dsc_array, dsc_array])
data_frame = pd.DataFrame(binary_dsc_array, columns=["binary dice"], index = haem_name)
data_frame["dice"] = dsc_array
data_frame["flip dice"] = flip_dsc_array
data_frame["binary flip dsc"] = binary_flip_dsc_array
data_frame["binary combined dsc"] = binary_combined_array
data_frame["percentage compromised"] = percent_compromised
data_frame["number of slices compromised"] = slice_compromised
data_frame["percentage compromised flip"] = percent_compromised_flip
data_frame["number of slices compromised flip"] = slice_compromised_flip
data_frame["split tract"] = split_tract
data_frame["tract asymmetry"] = tract_asymmetries
#data_frame["ID"] = haem_name
data_frame.to_excel(save_path)

