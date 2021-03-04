# RLudwig Updated Feb. 25 2021
# Caperio process html file urls
# Python Script equal to "Stata process html files urls"

import sys
import os
import pandas as pd
from datetime import date
sys.path.append(r'C:\\Bossa Nova\\Git\\Python_Caperio')
from subcat_code_cat_code_dict import cat_code_dict
from sc_Agencias_Subcategories import subcat_to_subcategory
from cat_code_to_category_dict import cat_code_category_dict


os.chdir('C:\\Users\\roytl\\Stata to Python')

# Process list2 url list first before processing the html list and finally
# merging the two

data = pd.read_csv('batchname.txt', sep=" ", header=None, dtype=str)
data.columns = ['batch']

df = pd.read_csv('sc_s3_urllist_list2files.csv', encoding='utf8')

# remove special character
df.columns = df.columns.str.replace(' ', '')

df['Archivo_list2'] = df['Archivo_list2'].str.strip()

df[['Name1', 'Name2', 'Name3']] = df.Name.str.split("_", expand=True,)

df[['subcat_code']] = df['Name2'].str.replace('list2', '')

df = df.drop(['Name1', 'Name2', 'Name3'], axis=1)

df['cat_code'] = df['subcat_code'].map(cat_code_dict)

df['subcategory'] = df['subcat_code'].map(subcat_to_subcategory)

df['category'] = df['cat_code'].map(cat_code_category_dict)

df = df.drop(['subcat_code', 'cat_code'], axis=1)

today = date.today()

# dd/mm/YY
df['fecha_update'] = today.strftime("%m/%d/%Y")
df['file_date'] = today.strftime("%Y-%m-%d")

df['filenamedate'] = df['Name'].str[12:22]

df['batch'] = data['batch']

df['batch'] = df['batch'].fillna(method='ffill')

df['batch_url'] = df['Name'].str[-12:-4]

indexNames = df[(df['batch_url']) != (df['batch'])].index

df.drop(indexNames, inplace=True)

df = df[df['Name'].notna()]


# turn off next two lines if running this do file on a date different than the
# date the html files were created
# indexNames = df[(df['filenamedate']) != (df['file_date'])].index
# df.drop(indexNames , inplace=True)

df = df.drop(['batch', 'batch_url'], axis=1)

df['namebatch'] = df['Name'].str[-12:-4]

df['key'] = df['subcategory'] + df['namebatch']

df = df[['key', 'Archivo_list2']]

df.sort_values(by=['key'])


# Now process html url list file

df2 = pd.read_csv('sc_s3_urllist_htmlfiles.csv', encoding='utf8')

df2[['Name1', 'Name2', 'Name3']] = df2.Name.str.split("_", expand=True,)


df2[['subcat_code']] = df2['Name2'].str.replace('contexto', '')

# remove special character
df2.columns = df2.columns.str.replace(' ', '')

os.chdir('C:\\Bossa Nova\\Git\\Python_Caperio')

df2 = df2.drop(['Name1', 'Name2', 'Name3'], axis=1)

df2['cat_code'] = df2['subcat_code'].map(cat_code_dict)

df2['subcategory'] = df2['subcat_code'].map(subcat_to_subcategory)

df2['category'] = df2['cat_code'].map(cat_code_category_dict)

df2 = df2.drop(['subcat_code', 'cat_code'], axis=1)

today = date.today()

# dd/mm/YY
df2['fecha_update'] = today.strftime("%m/%d/%Y")
df2['file_date'] = today.strftime("%Y-%m-%d")

df2['filenamedate'] = df2['Name'].str[12:22]

df2['batch'] = data['batch']

df2['batch_url'] = df2['Name'].str[-13:-5]

df2['batch'] = df2['batch'].fillna(method='ffill')

indexNames = df2[(df2['batch_url']) != (df2['batch'])].index

df2.drop(indexNames, inplace=True)

df2 = df2[df2['Name'].notna()]


# turn off next two lines if running this do file on a date different than
# the date the html files were created

# indexNames = df2[(df2['filenamedate']) != (df2['file_date'])].index
# df2.drop(indexNames , inplace=True)

df2 = df2.drop(['batch', 'batch_url'], axis=1)

df2['namebatch'] = df2['Name'].str[-13:-5]

df2['key'] = df2['subcategory'] + df2['namebatch']

df2 = df2[['key', 'Archivo_html', 'category', 'subcategory', 'fecha_update',
          'Name']]

df2.sort_values(by=['key'])

# Now merge df and df2

merged = pd.merge(df2, df, left_on='key', right_on='key', how='left')

merged = merged[['Archivo_html', 'fecha_update', 'category', 'subcategory',
                'Name', 'Archivo_list2']]

merged.to_csv('agencias_htmlfiles_python.csv', index=False)
