import pandas as pd
import numpy as np

def convert_binary(string):
    if string == "surgical":
        return  1
    if string == "medical":
        return 0
def sort_mrs(num):
    #0-3 low 
    #4-6 high
    if num <= 3:
        return 0
    if num >3:
        return 1
    
def fix_id(st):
    string = str(st)
    return int(string[0:4])

bios_path = '/Users/oliviamurray/Downloads/Parry_Jones_Dataset_20230706.xlsx'
sop_path = '/Users/oliviamurray/Documents/PhD/MISTIE/adrian_logistic.xlsx'
save_path = '/Users/oliviamurray/Documents/PhD/MISTIE/logistic_h.xlsx'
df = pd.read_excel(bios_path)
df_sop = pd.read_excel(sop_path, sheet_name="H")
sop_ids_unsorted = df_sop["PRIME ID "]
sop_ids = list(map(fix_id, sop_ids_unsorted))
bios_ids = df["patientnum_ninds"].to_numpy()

bios_mrs_1year = df["glasgow_rankin_365"].to_numpy()
sorted_df = df.loc[[sop_ids]]



bios_NIHSS_Q4_facial_palsy_d1 = df["NIHSS_Q4_facial_palsy_d1"].to_numpy()
bios_NIHSS_Q5a_m_left_arm_d1 = df["NIHSS_Q5a_m_left_arm_d1"].to_numpy()
bios_NIHSS_Q5b_right_arm_d1 = df["NIHSS_Q5b_right_arm_d1"].to_numpy()
bios_NIHSS_Q6a_m_left_leg_d1 = df["NIHSS_Q6a_m_left_leg_d1"].to_numpy()
bios_NIHSS_Q6b_right_leg_d1 = df["NIHSS_Q6b_right_leg_d1"].to_numpy()

bios_NIHSS_Q4_facial_palsy_d7 = df["NIHSS_Q4_facial_palsy_d7"].to_numpy()
bios_NIHSS_Q5a_m_left_arm_d7 = df["NIHSS_Q5a_m_left_arm_d7"].to_numpy()
bios_NIHSS_Q5b_right_arm_d7 = df["NIHSS_Q5b_right_arm_d7"].to_numpy()
bios_NIHSS_Q6a_m_left_leg_d7 = df["NIHSS_Q6a_m_left_leg_d7"].to_numpy()
bios_NIHSS_Q6b_right_leg_d7 = df["NIHSS_Q6b_right_leg_d7"].to_numpy()

bios_NIHSS_Q4_facial_palsy_d30 = df["NIHSS_Q4_facial_palsy_d30"].to_numpy()
bios_NIHSS_Q5a_m_left_arm_d30 = df["NIHSS_Q5a_m_left_arm_d30"].to_numpy()
bios_NIHSS_Q5b_right_arm_d30 = df["NIHSS_Q5b_right_arm_d30"].to_numpy()
bios_NIHSS_Q6a_m_left_leg_d30 = df["NIHSS_Q6a_m_left_leg_d30"].to_numpy()
bios_NIHSS_Q6b_right_leg_d30 = df["NIHSS_Q6b_right_leg_d30"].to_numpy()

bios_sis_transformed_hand_function_d30 = df["sis_transformed_hand_function_d30"].to_numpy()
bios_sis_transformed_mobility_d30 = df["sis_transformed_mobility_d30"].to_numpy()
bios_sis_transformed_physical_d30 =df["sis_transformed_physical_d30"].to_numpy()
bios_sis_transformed_hand_function_d180 = df["sis_transformed_hand_function_d180"].to_numpy()
bios_sis_transformed_mobility_d180 = df["sis_transformed_mobility_d180"].to_numpy()
bios_sis_transformed_physical_d180 =df["sis_transformed_physical_d180"].to_numpy()
bios_sis_transformed_hand_function_d365 = df["sis_transformed_hand_function_d365"].to_numpy()
bios_sis_transformed_mobility_d365 = df["sis_transformed_mobility_d365"].to_numpy()
bios_sis_transformed_physical_d365 =df["sis_transformed_physical_d365"].to_numpy()

bios_diagct_ivh_volume = df["diagct_ivh_volume"].to_numpy()
age = df["age_at_consent"].to_numpy()
sex = df["male_gender"].to_numpy()
ich_volume = df["diagct_ich_volume"].to_numpy()
group = df["treatment_group"]
sop_ids_unsorted = df_sop["PRIME ID "]
sop_involvement = df_sop["involvement"]

sop_ids = list(map(fix_id, sop_ids_unsorted))
print(sop_ids)
mrs = []
age_arr =[]
sex_arr =[]
ich_volume_arr =[]
group_arr =[]

left_arm_1 =[]
right_arm_1 =[]
left_leg_1 =[]
right_leg_1 =[]
face_1 =[]

left_arm =[]
right_arm =[]
left_leg =[]
right_leg =[]
face =[]

left_arm_30 =[]
right_arm_30 =[]
left_leg_30 =[]
right_leg_30 =[]
face_30 =[]

sis_hand_30 =[]
sis_mobility_30 =[]
sis_physical_30 =[]
sis_hand_180 =[]
sis_mobility_180 =[]
sis_physical_180 =[]
sis_hand_365 =[]
sis_mobility_365 =[]
sis_physical_365 =[]

added_nihss_1 = []
added_nihss =[]
added_nihss_30 =[]
ivh = []
sop_ids_sorted =[]
involvement_sorted = []

for id in sop_ids:
    if id in bios_ids:
        mrs_ind = bios_ids.tolist().index(id)
        mrs.append(bios_mrs_1year[mrs_ind])
        age_arr.append(age[mrs_ind])
        sex_arr.append(sex[mrs_ind])
        ich_volume_arr.append(ich_volume[mrs_ind])
        group_arr.append(group[mrs_ind])

        left_arm_1.append(bios_NIHSS_Q5a_m_left_arm_d1[mrs_ind])
        right_arm_1.append(bios_NIHSS_Q5b_right_arm_d1[mrs_ind])
        left_leg_1.append(bios_NIHSS_Q6a_m_left_leg_d1[mrs_ind])
        right_leg_1.append(bios_NIHSS_Q6b_right_leg_d1[mrs_ind])
        face_1.append(bios_NIHSS_Q4_facial_palsy_d1[mrs_ind])

        left_arm.append(bios_NIHSS_Q5a_m_left_arm_d7[mrs_ind])
        right_arm.append(bios_NIHSS_Q5b_right_arm_d7[mrs_ind])
        left_leg.append(bios_NIHSS_Q6a_m_left_leg_d7[mrs_ind])
        right_leg.append(bios_NIHSS_Q6b_right_leg_d7[mrs_ind])
        face.append(bios_NIHSS_Q4_facial_palsy_d7[mrs_ind])

        left_arm_30.append(bios_NIHSS_Q5a_m_left_arm_d30[mrs_ind])
        right_arm_30.append(bios_NIHSS_Q5b_right_arm_d30[mrs_ind])
        left_leg_30.append(bios_NIHSS_Q6a_m_left_leg_d30[mrs_ind])
        right_leg_30.append(bios_NIHSS_Q6b_right_leg_d30[mrs_ind])
        face_30.append(bios_NIHSS_Q4_facial_palsy_d30[mrs_ind])

        sis_hand_30.append(bios_sis_transformed_hand_function_d30[mrs_ind])
        sis_mobility_30.append(bios_sis_transformed_mobility_d30[mrs_ind])
        sis_physical_30.append(bios_sis_transformed_physical_d30[mrs_ind])
        sis_hand_180.append(bios_sis_transformed_hand_function_d180[mrs_ind])
        sis_mobility_180.append(bios_sis_transformed_mobility_d180[mrs_ind])
        sis_physical_180.append(bios_sis_transformed_physical_d180[mrs_ind])
        sis_hand_365.append(bios_sis_transformed_hand_function_d365[mrs_ind])
        sis_mobility_365.append(bios_sis_transformed_mobility_d365[mrs_ind])
        sis_physical_365.append(bios_sis_transformed_physical_d365[mrs_ind])
        index = sop_ids.index(id)
        involvement_sorted.append(sop_involvement[index])
        ivh.append(bios_diagct_ivh_volume[mrs_ind])
        sop_ids_sorted.append(id)
print(len(right_arm), len(left_arm), len(right_leg), len(left_leg), len(face))
for i in range(0, len(face)):
    added_1 = face_1[i] + right_arm_1[i] +left_arm_1[i] + left_leg_1[i] + right_leg_1[i]
    added = face[i] + right_arm[i] +left_arm[i] + left_leg[i] + right_leg[i]
    added_30 = face_30[i] + right_arm_30[i] +left_arm_30[i] + left_leg_30[i] + right_leg_30[i]
    added_nihss_1.apend(added_1)
    added_nihss.append(added)
    added_nihss_30.append(added_30)
print(added_nihss)
print(face[0], left_arm[0], left_leg[0], right_arm[0], right_leg[0])
print(len(face), len(added_nihss), len(left_arm), len(sop_ids_sorted))

binary_group = list(map(convert_binary, group_arr))
binary_mrs = list(map(sort_mrs, mrs))



print(binary_group)
#print(len(mrs))
df_log = pd.DataFrame(data = binary_mrs, index = sop_ids_sorted ,columns=["High mRS"])
#print(len(sop_involvement))
#print(sop_involvement)

#df_log["involve"] = sop_involvement

df_log.insert(1, "Involvement", involvement_sorted, True)
df_log["Age"] = age_arr
df_log["Sex"] = sex_arr
df_log["ICH Volume dCT"] = ich_volume_arr
df_log["ln ICH Volume dCT"] = np.log(ich_volume_arr)
df_log["Group"] = binary_group
df_log["NIHSS baseline"] = added_nihss_1
df_log["NIHSS motor d7"] = added_nihss
df_log["NIHSS motor d30"] = added_nihss_30
df_log["IVH Volume dCT"] = ivh
df_log["SISt hand function d30"] = sis_hand_30
df_log["SISt mobility d30"] = sis_mobility_30
df_log["SISt physical d30"] = sis_physical_30
df_log["SISt hand function d180"] = sis_hand_180
df_log["SISt mobility d180"] = sis_mobility_180
df_log["SISt physical d180"] = sis_physical_180
df_log["SISt hand function d365"] = sis_hand_365
df_log["SISt mobility d365"] = sis_mobility_365
df_log["SISt physical d365"] = sis_physical_365
df_log["mRS d365"] = mrs
df_log.to_excel(save_path, sheet_name="H")

df_surg = df_log[df_log.Group != 0]
df_surg.to_excel('/Users/oliviamurray/Documents/PhD/MISTIE/logistic_surgical.xlsx')
#print(df_log)
        

