import shutil 
import os
from collections import OrderedDict
import json
import numpy as np
import nibabel as nib
from pathlib import Path

def copy_and_rename(old_location,old_file_name,new_location,new_filename,delete_original = False):

    shutil.copy(os.path.join(old_location,old_file_name),new_location)
    os.rename(os.path.join(new_location,old_file_name),os.path.join(new_location,new_filename))
    if delete_original:
        os.remove(os.path.join(old_location,old_file_name))
def check_modality(filename):
    """
    check for the existence of modality
    return False if modality is not found else True
    """
    end = filename.find('.nii.gz')
    modality = filename[end-4:end]
    for mod in modality: 
        if not(ord(mod)>=48 and ord(mod)<=57): #if not in 0 to 9 digits
            return False
    return True

def threshold_mask(mask_path):
    img = nib.load(mask_path)

    data = img.get_fdata()

    data[data<0.01] = 0 
    data[data!=0] = 1   
    final_img = nib.Nifti1Image(data, img.affine) 
    nib.save(final_img, mask_path)
def rename_for_single_modality(directory):
    
    for file in os.listdir(directory):
        
        if check_modality(file)==False:
            new_name = file[:file.find('.nii.gz')]+"_0000.nii.gz"
            os.rename(os.path.join(directory,file),os.path.join(directory,new_name))
            print(f"Renamed to {new_name}")
        else:
            print(f"Modality present: {file}")
def rename_without_checking(directory):
     for file in os.listdir(directory):
            new_name = file[:file.find('.nii.gz')]+"_0000.nii.gz"
            os.rename(os.path.join(directory,file),os.path.join(directory,new_name))
            print(f"Renamed to {new_name}")
def main():
    train_label_dir = '/Users/oliviamurray/Documents/FETCH/FETCH_nnUNet/Task505_CT_CST_tractography/labelsTr'
    train_image_dir = '/Users/oliviamurray/Documents/FETCH/FETCH_nnUNet/Task505_CT_CST_tractography/imagesTr'
    test_image_dir = '/Users/oliviamurray/Documents/FETCH/FETCH_nnUNet/Task505_CT_CST_tractography/imagesTs'
    test_label_dir = '/Users/oliviamurray/Documents/FETCH/FETCH_nnUNet/Task505_CT_CST_tractography/labelsTs'
    task_name = 'Task505_CT_CST_tractography'
    task_folder_name = '/Users/oliviamurray/Documents/FETCH/FETCH_nnUNet/Task505_CT_CST_tractography'

    # Threshold tractography labels to values above 0.01, then make binary
    
    labels = Path(test_label_dir)
    for label in labels.iterdir():
        if "DS_Store" not in label.name:
            threshold_mask(label)
    """


    
    overwrite_json_file = True #make it True if you want to overwrite the dataset.json file in Task_folder
    json_file_exist = False

    if os.path.exists(os.path.join(task_folder_name,'dataset.json')):
        print('dataset.json already exist!')
        json_file_exist = True

    if json_file_exist==False or overwrite_json_file:

        json_dict = OrderedDict()
        json_dict['name'] = task_name
        json_dict['description'] = "CT_CST_tractography"
        json_dict['tensorImageSize'] = "3D"
        json_dict['reference'] = "see challenge website"
        json_dict['licence'] = "see challenge website"
        json_dict['release'] = "0.0"

        #you may mention more than one modality
        json_dict['modality'] = {
            "0": "CT"
        }
        #labels+1 should be mentioned for all the labels in the dataset
        json_dict['labels'] = {
            "0": "background",
            "1": "white matter",
        
        }
        
        train_ids = os.listdir(train_label_dir)
        print(train_ids)
        test_ids = os.listdir(test_image_dir)
        json_dict['numTraining'] = len(train_ids)
        json_dict['numTest'] = len(test_ids)

        #no modality in train image and labels in dataset.json 
        json_dict['training'] = [{'image': "./imagesTr/%s" % i, "label": "./labelsTr/%s" % i} for i in train_ids]

        #removing the modality from test image name to be saved in dataset.json
        json_dict['test'] = ["./imagesTs/%s" % (i[:i.find("_0000")]+ ".nii.gz") for i in test_ids]

        with open(os.path.join(task_folder_name,"dataset.json"), 'w') as f:
            json.dump(json_dict, f, indent=4, sort_keys=True)

        if os.path.exists(os.path.join(task_folder_name,'dataset.json')):
            if json_file_exist==False:
                print('dataset.json created!')
            else: 
                print('dataset.json overwritten!')
    """
if __name__ == '__main__':
 main()