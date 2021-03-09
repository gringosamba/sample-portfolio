# Python script to get html split urls for each transcription
import pandas as pd
import numpy as np
import os
from sc_Agencias_Subcategories import subcat_code


os.chdir('C:\\Bossa Nova\\audiototext\\sc\\html url')

df = pd.read_csv('sc_s3_urllist_html_splitfiles.csv', sep=",", dtype=str)

df = df.rename(columns={' Archivo_html': 'Archivo_html'})

df['basename'] = df['Name'].str.slice(start=18, stop=41)

df['Archivo_html'] = df['Archivo_html'].str.strip()

df[['splt_name1', 'splt_name2', 'splt_name3', 'splt_name4'
    ]] = df.Name.str.split("-", expand=True)

df = df.drop(['splt_name1', 'splt_name2', 'splt_name3'], axis=1)

df[['splt_name1', 'splt_name2']] = df.splt_name4.str.split(".", expand=True)

df = df.rename(columns={'splt_name1': 'subcat_code'})

df = df[['basename', 'Archivo_html', 'subcat_code']]

# now merge with audiofilelist to keep only this batch records

os.chdir('C:\\Bossa Nova\\audiototext\\sc\\Additional Input Data')

afl = pd.read_pickle('audiofilelist.pkl')

afl['basename'] = afl['name'].str.slice(start=0, stop=23)

afl = afl.drop('name', axis=1)

df = df.merge(afl, on=["basename"], how="right")

os.chdir('C:\\Bossa Nova\\audiototext\\sc\\html url')

subcat_df = pd.DataFrame(columns=subcat_code)

subcat_df = subcat_df.add_suffix('_url')

df2 = pd.concat([df, subcat_df], axis=1)

n = 1
while n in range(len(subcat_code)):

    try:
        nstring = str(n)
        subcat = 'subcat' + nstring
        subcaturl = 'subcat' + nstring + '_url'
        df2[subcaturl] = np.where(df2['subcat_code'] == subcat,
                                  df2['Archivo_html'], df2[subcaturl])
        n = n + 1

    except(KeyError):

        n = n + 1


df2 = df2.drop(['Archivo_html', 'subcat_code'], axis=1)

df2 = df2.fillna(df2.groupby('basename').ffill())
df2 = df2.fillna(df2.groupby('basename').bfill())

df2 = df2.drop_duplicates(subset=['basename'])

df2 = df2.sort_values(by=['basename'])

df2 = df2.dropna(how='all', axis=1)

df2.to_csv('agencias_html_split_files.csv', index=False)
