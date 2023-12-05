import pandas as pd

# Load the original spreadsheet with IDs and the mapping spreadsheet
original_df = pd.read_excel("/Users/oliviamurray/Documents/MISTIE_inference/output_full.xlsx")
mapping_df = pd.read_excel('/Users/oliviamurray/Downloads/MISTIE_III_Link_File.xlsx')

# Merge the data based on the common ID column
result_df = original_df.merge(mapping_df, on='ID', how = 'left' )#, how='left')

# Save the result to a new Excel file with the additional column
result_df.to_excel('/Users/oliviamurray/Documents/MISTIE_inference/output_full_2.xlsx', index=False)
