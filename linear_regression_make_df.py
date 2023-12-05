import pandas as pd
import numpy as np
from scipy.stats import linregress
import matplotlib.pyplot as plt

def convert_binary(string):
    if string == "surgical":
        return 1
    if string == "medical":
        return 0

def sort_mrs(num):
    # 0-3 low 
    # 4-6 high
    return 0 if num <= 3 else 1

def fix_id(st):
    return int(str(st)[0:4])

def binary_involve(st):
    if st[0] == "N":
        return 0
    if st[0] == "P":
        return 1
    if st[0] == "C":
        return 2
def binary_extent(int):
    if int < 70:
        return 0
    if int >= 70:
        return 1
def binary_involve_01(st):
    if st == 0:
        return 0
    if st == 1:
        return 1
    if st == 2:
        return 1
def binary_involve_02(st):
    if st == 0:
        return 0
    if st == 1:
        return 2
    if st == 2:
        return 2
def gradient(arr_len_5):
    x = np.array([1,7,30,180,365])
    y = arr_len_5
    slope, intercept = np.polyfit(x, y, 1)
    return slope
def log_gradient(arr_len_5):
    x = np.array([1,7,30,180,365])
    x_ln = np.log(x)
    y = arr_len_5
    slope, intercept = np.polyfit(x_ln, y, 1)
    return slope

observer = 'Paul'

bios_path = '/Users/oliviamurray/Downloads/Parry_Jones_Dataset_20230706.xlsx'
bios_sorted_path = '/Users/oliviamurray/Downloads/Parry_Jones_Dataset_20230731_Shared.xlsx'
sop_path = '/Users/oliviamurray/Documents/PhD/MISTIE/adrian_logistic.xlsx'
save_path = '/Users/oliviamurray/Documents/PhD/MISTIE/logistic_new' +str(observer) + '.xlsx'

df = pd.read_excel(bios_path)
df_sorted = pd.read_excel(bios_sorted_path)
df_sop = pd.read_excel(sop_path, sheet_name= observer)

# Convert SOP IDs to fixed IDs
df_sop["PRIME ID "] = df_sop["PRIME ID "].map(fix_id)
df_sop["CR involvement "] = df_sop["CR involvement "].map(binary_involve)
print(df_sop)
#setting index
df_sop.set_index("PRIME ID ")
df.set_index("patientnum_ninds")
df_sorted.set_index("patientnum_ninds")
# Merge the DataFrames based on SOP IDs
#merged_df = pd.merge(df, df_sop, left_on="patientnum_ninds", right_on="PRIME ID ", how="inner")
#filtered_df = pd.merge(df_sop, df, left_index = True, right_index = True)
filtered_df = df_sop.merge(df, left_on="PRIME ID ", right_on="patientnum_ninds")
columns = ["patientnum_ninds", "NIHSS_Q4_facial_palsy_d1", "NIHSS_Q5a_m_left_arm_d1", "NIHSS_Q5b_right_arm_d1",
    "NIHSS_Q6a_m_left_leg_d1", "NIHSS_Q6b_right_leg_d1"]
df_sorted = df_sorted[columns]
filtered_df = filtered_df.merge(df_sorted, left_on = "PRIME ID ", right_on = "patientnum_ninds" )
"""
# Filter columns of interest
cols_of_interest = [
    "glasgow_rankin_365", "age_at_consent", "male_gender", "diagct_ich_volume", "treatment_group",
    "NIHSS_Q4_facial_palsy_d1", "NIHSS_Q5a_m_left_arm_d1", "NIHSS_Q5b_right_arm_d1",
    "NIHSS_Q6a_m_left_leg_d1", "NIHSS_Q6b_right_leg_d1",
    "NIHSS_Q4_facial_palsy_d7", "NIHSS_Q5a_m_left_arm_d7", "NIHSS_Q5b_right_arm_d7",
    "NIHSS_Q6a_m_left_leg_d7", "NIHSS_Q6b_right_leg_d7",
    "NIHSS_Q4_facial_palsy_d30", "NIHSS_Q5a_m_left_arm_d30", "NIHSS_Q5b_right_arm_d30",
    "NIHSS_Q6a_m_left_leg_d30", "NIHSS_Q6b_right_leg_d30",
    "NIHSS_Q4_facial_palsy_d180", "NIHSS_Q5a_m_left_arm_d180", "NIHSS_Q5b_right_arm_d180",
    "NIHSS_Q6a_m_left_leg_d180", "NIHSS_Q6b_right_leg_d180",
    "NIHSS_Q4_facial_palsy_d365", "NIHSS_Q5a_m_left_arm_d365", "NIHSS_Q5b_right_arm_d365",
    "NIHSS_Q6a_m_left_leg_d365", "NIHSS_Q6b_right_leg_d365",
    "sis_transformed_hand_function_d30", "sis_transformed_mobility_d30", "sis_transformed_physical_d30",
    "sis_transformed_hand_function_d180", "sis_transformed_mobility_d180", "sis_transformed_physical_d180",
    "sis_transformed_hand_function_d365", "sis_transformed_mobility_d365", "sis_transformed_physical_d365",
    "diagct_ivh_volume", "PRIME ID ", "involvement", "CR involvement "
]

filtered_df = merged_df[cols_of_interest]

# Rename the columns for better readability
filtered_df.columns = [
    "glasgow_rankin_365", "age_at_consent", "male_gender", "diagct_ich_volume", "treatment_group",
    "NIHSS_Q4_facial_palsy_d1", "NIHSS_Q5a_m_left_arm_d1", "NIHSS_Q5b_right_arm_d1",
    "NIHSS_Q6a_m_left_leg_d1", "NIHSS_Q6b_right_leg_d1",
    "NIHSS_Q4_facial_palsy_d7", "NIHSS_Q5a_m_left_arm_d7", "NIHSS_Q5b_right_arm_d7",
    "NIHSS_Q6a_m_left_leg_d7", "NIHSS_Q6b_right_leg_d7",
    "NIHSS_Q4_facial_palsy_d30", "NIHSS_Q5a_m_left_arm_d30", "NIHSS_Q5b_right_arm_d30",
    "NIHSS_Q6a_m_left_leg_d30", "NIHSS_Q6b_right_leg_d30",
    "NIHSS_Q4_facial_palsy_d180", "NIHSS_Q5a_m_left_arm_d180", "NIHSS_Q5b_right_arm_d180",
    "NIHSS_Q6a_m_left_leg_d180", "NIHSS_Q6b_right_leg_d180",
    "NIHSS_Q4_facial_palsy_d365", "NIHSS_Q5a_m_left_arm_d365", "NIHSS_Q5b_right_arm_d365",
    "NIHSS_Q6a_m_left_leg_d365", "NIHSS_Q6b_right_leg_d365",
    "sis_transformed_hand_function_d30", "sis_transformed_mobility_d30", "sis_transformed_physical_d30",
    "sis_transformed_hand_function_d180", "sis_transformed_mobility_d180", "sis_transformed_physical_d180",
    "sis_transformed_hand_function_d365", "sis_transformed_mobility_d365", "sis_transformed_physical_d365",
    "diagct_ivh_volume", "sop_id", "involvement", "CR involvement"
]
"""
# Calculate added_nihss for each row
filtered_df["added_nihss_1"] = filtered_df[
    ["NIHSS_Q4_facial_palsy_d1", "NIHSS_Q5a_m_left_arm_d1", "NIHSS_Q5b_right_arm_d1",
     "NIHSS_Q6a_m_left_leg_d1", "NIHSS_Q6b_right_leg_d1"]
].sum(axis=1)

filtered_df["added_nihss_7"] = filtered_df[
    ["NIHSS_Q4_facial_palsy_d7", "NIHSS_Q5a_m_left_arm_d7", "NIHSS_Q5b_right_arm_d7",
     "NIHSS_Q6a_m_left_leg_d7", "NIHSS_Q6b_right_leg_d7"]
].sum(axis=1)

filtered_df["added_nihss_30"] = filtered_df[
    ["NIHSS_Q4_facial_palsy_d30", "NIHSS_Q5a_m_left_arm_d30", "NIHSS_Q5b_right_arm_d30",
     "NIHSS_Q6a_m_left_leg_d30", "NIHSS_Q6b_right_leg_d30"]
].sum(axis=1)

filtered_df["added_nihss_180"] = filtered_df[
    ["NIHSS_Q4_facial_palsy_d180", "NIHSS_Q5a_m_left_arm_d180", "NIHSS_Q5b_right_arm_d180",
     "NIHSS_Q6a_m_left_leg_d180", "NIHSS_Q6b_right_leg_d180"]
].sum(axis=1)

filtered_df["added_nihss_365"] = filtered_df[
    ["NIHSS_Q4_facial_palsy_d365", "NIHSS_Q5a_m_left_arm_d365", "NIHSS_Q5b_right_arm_d365",
     "NIHSS_Q6a_m_left_leg_d365", "NIHSS_Q6b_right_leg_d365"]
].sum(axis=1)





# Convert categorical columns to binary
filtered_df["treatment_group"] = filtered_df["treatment_group"].map(convert_binary)
filtered_df["glasgow_rankin_365_binary"] = filtered_df["glasgow_rankin_365"].map(sort_mrs)

columns_to_calculate_gradient = ["added_nihss_1", "added_nihss_7", "added_nihss_30", "added_nihss_180", "added_nihss_365"]
d1 = filtered_df["added_nihss_1"].to_numpy()
d7 = filtered_df["added_nihss_7"].to_numpy()
d30 = filtered_df["added_nihss_30"].to_numpy()
d180= filtered_df["added_nihss_180"].to_numpy()
d365 = filtered_df["added_nihss_365"].to_numpy()
print(d1.shape, d1[1], d7[1])
#d1,d7,d30,d180,d365 = filtered_df[["added_nihss_1", "added_nihss_7", "added_nihss_30", "added_nihss_180", "added_nihss_365"]].to_numpy()
slopes = []
log_slopes =[]
extents =[]
for i in range(0, len(d7)):
    
    x = np.array([d1[i], d7[i], d30[i], d180[i], d365[i]])
    slope = gradient(x)
    log_slope = log_gradient(x)
    y = np.array([1,7,30,180,365])
    
    log_slopes.append(log_slope)
    slopes.append(slope)
    if d1[i] > 2:
       
        extent = (d1[i] - d180[i])/(d1[i])
        extent = extent*100
    else:
        extent = np.nan
    extents.append(extent)
    

print(len(extents), extents)
filtered_df["NIHSS gradient"] = slopes
filtered_df["NIHSS log gradient"] = log_slopes
filtered_df["NIHSS extent"] = np.array(extents)
filtered_df["Log ICH volume"] = filtered_df["diagct_ich_volume"].apply(np.log)
filtered_df["NIHSS extent binary"] = filtered_df["NIHSS extent"].map(binary_extent)
filtered_df["NIHSS extent binary"] = filtered_df["NIHSS extent"].map(binary_extent)
filtered_df["CR collapsed involvement"] = filtered_df["CR involvement "].map(binary_involve_01)
filtered_df["PLIC collapsed involvement"] = filtered_df["involvement"].map(binary_involve_01)
filtered_df["PLIC collapsed involvement 2"] = filtered_df["involvement"].map(binary_involve_02)
# Apply the lambda function to create a new column with the sum
filtered_df["Combined involvement"] = filtered_df.apply(lambda row: row["CR collapsed involvement"] + row["PLIC collapsed involvement"], axis=1)
filtered_df["Combined involvement 0123"] = filtered_df.apply(lambda row: row["CR collapsed involvement"] + row["PLIC collapsed involvement 2"], axis=1)
filtered_df["SIS impairment d180"] = filtered_df["sis_transformed_physical_d180"]
filtered_df["SIS function d180"] = filtered_df.apply(lambda row: row["sis_transformed_mobility_d180"] + row["sis_transformed_hand_function_d180"], axis=1)
# now filter out relevant columns
filtered_columns = ["PRIME ID ","treatment_group", "age_at_consent", "male_gender", 
                    "diagct_ivh_volume", "Log ICH volume", "Combined involvement","PLIC collapsed involvement", "CR collapsed involvement", "Combined involvement 0123", "added_nihss_1", "added_nihss_180", 
                    "SIS impairment d180", "SIS function d180" ,"NIHSS log gradient", "NIHSS gradient", "NIHSS extent", "NIHSS extent binary"]
filtered_df = filtered_df[filtered_columns]
filtered_df.to_excel(save_path, sheet_name= observer, index=False)
# Filter surgical group and save to a new Excel file
df_surg = filtered_df[filtered_df["treatment_group"] != 0]

df_surg.to_excel('/Users/oliviamurray/Documents/PhD/MISTIE/logistic_surgical.xlsx', index=False)
df_not_involved = filtered_df[filtered_df["Combined involvement 0123"] == 0]
df_not_involved.to_excel('/Users/oliviamurray/Documents/PhD/MISTIE/logistic_not_involved.xlsx', index=False)