import pandas as pd
bios_path = '/Users/oliviamurray/Downloads/Parry_Jones_Dataset_20230731_Shared.xlsx'
bios_path_2 = '/Users/oliviamurray/Downloads/Parry_Jones_Dataset_20230706.xlsx'
save_path = '/Users/oliviamurray/Documents/PhD/MISTIE/wrong_dataframe.xlsx'
df_sorted = pd.read_excel(bios_path)
df_org = pd.read_excel(bios_path_2)


df_b = df_sorted[df_org.columns]
diff = df_b.compare(df_org, align_axis = 1)

eq = df_b.equals(df_org)

print(eq)
df_b = (df_sorted[df_org.columns] != df_org).any()

df_b = pd.DataFrame(df_b)
diff.to_excel('/Users/oliviamurray/Documents/PhD/MISTIE/wrong_dataframe.xlsx')
