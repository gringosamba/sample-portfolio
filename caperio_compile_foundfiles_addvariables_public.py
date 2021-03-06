# Rluwig Updt. March 4 2021
# This file contains code used in processing a batch of customer interactions
# Caperio process found files and generate key output files

import pandas as pd
import numpy as np
import os
from pandas.errors import EmptyDataError
import glob
from functools import reduce
from datetime import date
from various_functions import find_number
from subcat_code_cat_code_dict import cat_code_dict
from sc_Agencias_Subcategories import subcat_to_subcategory
from cat_code_to_category_dict import cat_code_category_dict
from rename_additional_variables import add_var_dict


# Batch File Processing //
# change path to get the batchname file
os.chdir('C:\\Bossa Nova\\audiototext\\sc\\Caspio')
batch_df = pd.read_csv('batchname.txt', sep=" ", header=None, dtype=str)
batch_df.columns = ['batch']

# Additional Excel Variable Processing //
# change path to get the additional excel variables file
os.chdir('C:\\Bossa Nova\\audiototext\\sc\\Additional Input Data')
add_df = pd.read_excel('additionaldata.xlsx', dtype=str)
# rename additional variables using dictionary from module
add_df.columns = add_df.columns.to_series().map(add_var_dict)
# get basename
add_df['basename'] = add_df['varalph16'].str.slice(start=0, stop=23)
# drop if basename ==""
add_df = add_df[add_df['basename'].notna()]
# destring numeric variables
cols_to_convert = ['varnum1', 'varnum2', 'varnum3']
for col in cols_to_convert:
    add_df[col] = pd.to_numeric(add_df[col], errors='coerce')
# change blanks to zero value
add_df.loc[pd.isna(add_df['varnum2']), 'varnum3'] = 0

add_df = add_df.drop_duplicates(subset=['basename'])

add_df['name'] = add_df['varalph16']

# Get file date
add_df['fecha_arq'] = add_df['varalph16'].str[0:8]

# Reformat data variables
add_df['fecha_arq'] = pd.to_datetime(add_df.fecha_arq)
add_df['fecha_arq'] = add_df['fecha_arq'].dt.strftime('%m/%d/%Y')

add_df['vardate1'] = pd.to_datetime(add_df.vardate1, format='%Y%m%d')
add_df['vardate1'] = add_df['vardate1'].dt.strftime('%m/%d/%Y')

add_df['vardate2'] = pd.to_datetime(add_df.vardate2, format='%Y%m%d')
add_df['vardate2'] = add_df['vardate2'].dt.strftime('%m/%d/%Y')

add_df['vardate3'] = pd.to_datetime(add_df.vardate3, format='%Y%m%d')
add_df['vardate3'] = add_df['vardate3'].dt.strftime('%m/%d/%Y')

# Get a list of audio file names for this batch //
name = add_df['varalph16']
afl = name.to_frame('name')
afl['name'] = afl["name"].str.replace('.wav', '.flac')
afl = afl.drop_duplicates(subset=['name'])
afl = afl[afl['name'].notna()]

# Get the audio file S3 url's and merge with audio list //
os.chdir('C:\\Bossa Nova\\audiototext\\sc\\Audios S3 URL')
audios_df = pd.read_csv('sc_s3_urllist.csv')
audios_df['Name'] = audios_df['Name'].str.replace('cb-agencias/', '')
audios_df.columns = ['name', 'Archivo_llamada']

# Merge audio files list with S3 url file list
df1 = audios_df.merge(afl, on=["name"], how="right")
df1.columns = df1.columns.str.replace(' ', '')
df1['basename'] = df1['name'].str.slice(start=0, stop=23)
df1 = df1.drop('name', axis=1)
df1 = df1[['basename', 'Archivo_llamada']]

# Process Transcription S3 url's //
os.chdir('C:\\Bossa Nova\\audiototext\\sc\\Transcript S3 URL')
trans_df = pd.read_csv('sc_s3_urllist_transcripts.csv')
trans_df.rename(columns={'Name': 'name'}, inplace=True)
trans_df['name'] = trans_df['name'].str.replace('.json-transcript.txt', '')
trans_df['name'] = trans_df["name"].str.replace('cb-agencias/', '')

# Merge transcript URL's with audio file list
df2 = trans_df.merge(afl, on=["name"], how="right")
df2.columns = df2.columns.str.replace(' ', '')
df2['basename'] = df2['name'].str.slice(start=0, stop=23)
df2 = df2.drop('name', axis=1)
df2 = df2[['basename', 'Archivo_transcript']]

# Change path to get the found files for processing
os.chdir('C:\\Bossa Nova\\audiototext\\sc\\Text Transcripts')

# Get a count of words for each transcription
word_df = pd.read_fwf('wordcount.txt')
word_df['basename'] = word_df['Name'].str.slice(start=0, stop=23)
word_df = word_df.drop('Name', axis=1)
word_df.columns = ['characters', 'basename']
word_df = word_df[['basename', 'characters']]
word_df['characters'] = pd.to_numeric(word_df['characters'], errors='coerce')

# Processing for each subcategory //
# for subcats with group matching (subcat13,subcat80, maybe others)
for filename in glob.glob('encuentra_subcat*.txt'):

    try:
        subcat_df = pd.read_fwf(filename, header=None)
        fnoext = os.path.splitext(filename)[0]
        subcat = fnoext.replace('encuentra_', '')
        subcat_df[subcat] = 1
        subcat_df.drop(subcat_df.columns[[0, 1]], axis=1, inplace=True)
        subcat_df.columns = ['Name', subcat]
        subcat_df['basename'] = subcat_df['Name'].str.slice(start=12, stop=35)
        subcat_df = subcat_df[['basename', subcat]]
        subcat_df.to_pickle(subcat + ".pkl")

    except(NameError, EmptyDataError):
        data = [['', 1]]
        fnoext = os.path.splitext(filename)[0]
        subcat = fnoext.replace('encuentra_', '')
        subcat_df = pd.DataFrame(data, columns=['basename', subcat])
        subcat_df.to_pickle(subcat + ".pkl")

    except(ValueError):
        subcat_df = pd.read_fwf(filename)
        subcat_df.columns = ['Name']
        subcat_df['matchcount'] = subcat_df['Name'].str.slice(start=0, stop=10)
        subcat_df['groupcount'] = subcat_df['Name'].str.slice(start=11, stop=22)
        subcat_df['matchcount'] = subcat_df['matchcount'].apply(lambda x: find_number(x))
        subcat_df['groupcount'] = subcat_df['groupcount'].apply(lambda x: find_number(x))
        subcat_df['file'] = subcat_df['Name'].str[-48:]
        subcat_df[['basename']] = subcat_df['file'].str.replace('.flac.json-transcript.txt', '')
        subcat_df[['basename']] = subcat_df['basename'].str.replace('.flac.json-transcript.tx', '')
        subcat_df[['basename']] = subcat_df['basename'].str.replace('\\', '')
        subcat_df = subcat_df.drop(['Name', 'matchcount', 'file'], axis=1)
        subcat_df['groupcount'] = pd.to_numeric(subcat_df['groupcount'], errors='coerce')
        subcat_df = subcat_df[subcat_df['groupcount'] >= 4]
        fnoext = os.path.splitext(filename)[0]
        subcat = fnoext.replace('encuentra_', '')
        subcat_df[subcat] = 1
        subcat_df = subcat_df[['basename', subcat]]
        subcat_df.to_pickle(subcat + ".pkl")

# Now compile all processed subcat files to create one dataframe
path = r'C:\\Bossa Nova\\audiototext\\sc\\Text Transcripts'
all_files = glob.glob(os.path.join(path, "subcat*.pkl"))
df_from_each_file = (pd.read_pickle(f) for f in all_files)
pkl_df = pd.concat(df_from_each_file, ignore_index=True)
pkl_df = pkl_df[pkl_df['basename'].notna()]
pkl_df = pkl_df.groupby('basename').sum()
pkl_df.to_csv('pickle.csv')

# Consolidate subcat dataframe with wordcount and excel variables
data_frames = [pkl_df, word_df, add_df]
df3 = reduce(lambda left, right: pd.merge(left, right, on=['basename'],
                                          how='outer'), data_frames)

df3['size'] = ''
df3['length'] = ''
totalseconds = df3['varnum1']
tcts = df3['characters'] / totalseconds
nosilence = 11
silence = nosilence - tcts
df3['pctsilence'] = silence / nosilence
df3.loc[df3.pctsilence <= 0, 'pctsilence'] = 0
df3.rename(columns={'pctsilence': 'tcts'}, inplace=True)

# Merge to pick up audio and transcription url's
data_frames = [df3, df2, df1]
df4 = reduce(lambda left, right: pd.merge(left, right, on=['basename'],
                                          how='outer'), data_frames)
df4 = df4[df4['Archivo_transcript'].notna()]
df4.to_pickle('merged_sc_files.pkl')

today = date.today()

df4['fecha_update'] = today.strftime("%m/%d/%Y")

df4 = df4.astype(str)

# Destring numeric variables
cols_to_convert = ['varnum1', 'varnum2', 'varnum3']
for col in cols_to_convert:
    df4[col] = pd.to_numeric(df4[col], errors='coerce')


# ### Conditional Coding Section //

df4.loc[df4.varalph4 != "LE", ['subcat22', 'subcat23', 'subcat24', 'subcat25',
                               'subcat26', 'subcat27', 'subcat28', 'subcat29',
                               'subcat30', 'subcat31']] = "N/A"


df4['varalph9'] = df4['varalph9'].str.strip()

df4.loc[df4.varalph9 != "GOAL", ['subcat48', 'subcat49', 'subcat50', 'subcat51',
                                 'subcat69', 'subcat79']] = "N/A"

df4.loc[df4.varalph9.str.contains('MED'), 'subcat44'] = "N/A"

# ## End of Conditional Coding

# Re-order the columns
df4 = df4[['name', 'basename', 'fecha_update', 'tcts', 'vardate1', 'varalph1',
          'varalph2', 'varnum1', 'varalph3', 'varalph4', 'varalph5',
           'varalph6', 'varalph7', 'varalph8', 'varalph9', 'varalph10',
           'varnum2', 'varalph11', 'vardate2', 'varalph12', 'vardate3',
           'varnum3', 'varalph13', 'varalph14', 'varalph15', 'varalph16',
           'varalph17', 'varalph18', 'varalph19', 'varalph20', 'subcat1',
           'subcat2', 'subcat3', 'subcat4', 'subcat5', 'subcat6', 'subcat7',
           'subcat8', 'subcat9', 'subcat10', 'subcat11', 'subcat12',
           'subcat13', 'subcat14', 'subcat16', 'subcat17', 'subcat18',
           'subcat19', 'subcat20', 'subcat21', 'subcat22', 'subcat23',
           'subcat24', 'subcat25', 'subcat26', 'subcat27', 'subcat28',
           'subcat29', 'subcat30', 'subcat31', 'subcat32', 'subcat33',
           'subcat34', 'subcat35', 'subcat36', 'subcat37', 'subcat38',
           'subcat39', 'subcat40', 'subcat41', 'subcat43', 'subcat44',
           'subcat45', 'subcat46', 'subcat47', 'subcat48', 'subcat49',
           'subcat50', 'subcat51', 'subcat52', 'subcat53', 'subcat54',
           'subcat55', 'subcat56', 'subcat57', 'subcat58', 'subcat59',
           'subcat60', 'subcat61', 'subcat62', 'subcat63', 'subcat64',
           'subcat65', 'subcat66', 'subcat67', 'subcat68', 'subcat69',
           'subcat70', 'subcat71', 'subcat72', 'subcat73', 'subcat75',
           'subcat76', 'subcat77', 'subcat78', 'subcat79', 'subcat80',
           'Archivo_llamada', 'Archivo_transcript']]

df4.columns = df4.columns.str.lower()
df4 = df4[df4['name'].notna()]

df4.to_pickle('agencias_subcat_detect_xcelvars_dash.pkl')
df4.to_csv('agencias_subcat_detect_xcelvars_dash.csv')

df4.iloc[:, 30:] = df4.iloc[:, 30:].replace({'1.0': 'Sí', '0.0': 'No'}).fillna(0)

df4.to_csv('agencias_subcat_detect_xcelvars.csv')


col_list = ['name', 'basename', 'fecha_update', 'vardate1', 'varalph1',
            'varalph2', 'varnum1', 'varalph3', 'varalph4', 'varalph5',
            'varalph6', 'varalph7', 'varalph8', 'varalph9', 'varalph10',
            'varnum2', 'varalph11', 'vardate2', 'varalph12', 'vardate3',
            'varnum3', 'varalph13', 'varalph14', 'varalph15', 'varalph16',
            'varalph17', 'varalph18', 'varalph19', 'varalph20']

xcelvars_df = df4[col_list]
xcelvars_df.to_csv('agencias_xcelvars.csv')

# Get Total Processed //
df5 = pd.read_pickle('agencias_subcat_detect_xcelvars_dash.pkl')

subcat_list = ['subcat1', 'subcat2',
               'subcat3', 'subcat4', 'subcat5', 'subcat6', 'subcat7',
               'subcat8', 'subcat9', 'subcat10', 'subcat11', 'subcat12',
               'subcat13', 'subcat14', 'subcat16', 'subcat17', 'subcat18',
               'subcat19', 'subcat20', 'subcat21', 'subcat22', 'subcat23',
               'subcat24', 'subcat25', 'subcat26', 'subcat27', 'subcat28',
               'subcat29', 'subcat30', 'subcat31', 'subcat32', 'subcat33',
               'subcat34', 'subcat35', 'subcat36', 'subcat37', 'subcat38',
               'subcat39', 'subcat40', 'subcat41', 'subcat43', 'subcat44',
               'subcat45', 'subcat46', 'subcat47', 'subcat48', 'subcat49',
               'subcat50', 'subcat51', 'subcat52', 'subcat53', 'subcat54',
               'subcat55', 'subcat56', 'subcat57', 'subcat58', 'subcat59',
               'subcat60', 'subcat61', 'subcat62', 'subcat63', 'subcat64',
               'subcat65', 'subcat66', 'subcat67', 'subcat68', 'subcat69',
               'subcat70', 'subcat71', 'subcat72', 'subcat73', 'subcat75',
               'subcat76', 'subcat77', 'subcat78', 'subcat79', 'subcat80']

pieces = []
for col in subcat_list:
    tmp_series = df5[col].value_counts()
    tmp_series.name = col
    pieces.append(tmp_series)
df5_vc = pd.concat(pieces, axis=1)

df5_vc = df5_vc.drop('N/A', axis=0)

df5_vc = df5_vc.append(df5_vc.sum(numeric_only=True), ignore_index=True)

df5_vc['name'] = 'Total Procesado'

df5_total = df5_vc.tail(1)

df5_total.to_pickle('sc_ct_agencias_tot_volumen_summary.pkl')

# Get Total Found //

df5_encontrado = df5_vc.head(-1)

df5_encontrado = df5_encontrado.tail(-1)

df5_encontrado = df5_encontrado.apply(lambda x: x.fillna(0))

df5_encontrado['name'] = 'Total Encontrado'

df5_encontrado.to_pickle('sc_ct_agencias_tot_found_summary.pkl')

# Get Avg. Promise Amount for Detected //

df6 = df5

cols = [c for c in df6.columns if c.lower()[:3] != 'var' and c[:3] != 'arc'
        and c[-4:] != 'name' or c[:7] == 'varnum3']

df6 = df6[cols]

df6 = df6.replace({'N/A': ''})

cols = df6.columns.drop('fecha_update')
df6[cols] = df6[cols].apply(pd.to_numeric, errors='coerce')

df6.to_pickle('df6-yes-as-ones.pkl')

df7 = pd.read_pickle('df6-yes-as-ones.pkl')

df7 = df7.replace(0.0, np.NaN)

cats = df7.iloc[:, 3:]
s_yes = cats.mul(df7.varnum3, axis='rows')
s_yes = s_yes.mean()
s_yes['name'] = 'Avg Yes MP'
s_yes = s_yes.to_frame('Avg Yes MP')
s_yes = s_yes.T
s_yes.to_pickle('sc_d_yesmp_summary.pkl')

# Get Avg. Payment Amount for NOT Detected //
df8 = pd.read_pickle('df6-yes-as-ones.pkl')

df8.iloc[:, 3:] = df8.iloc[:, 3:].replace({1.0: 2.0})

df8.iloc[:, 3:] = df8.iloc[:, 3:].replace({0.0: 1.0})

df8.iloc[:, 3:] = df8.iloc[:, 3:].replace({2.0: np.nan})

cats = df8.iloc[:, 3:]
s_no = cats.mul(df8.varnum3, axis='rows')
s_no = s_no.mean()
s_no['name'] = 'Avg No MP'
s_no = s_no.to_frame('Avg No MP')
s_no = s_no.T
s_no.to_pickle('sc_e_nomp_summary.pkl')


# PTP Rate for Detected //
yptp_df = df6

yptp_df['varnum3'] = yptp_df.varnum3.replace(np.nan, 0)

cats = yptp_df.iloc[:, 3:]
s_yesptp = cats.mul(yptp_df.varnum3, axis='rows')
s_yesptp[s_yesptp > 1] = 1
s_yesptp.to_pickle('sc_yesptp.pkl')

# ## PTP rate for NOT Detected
nptp_df = df6

nptp_df['varnum3'] = nptp_df.varnum3.replace(np.nan, 0)

nptp_df.iloc[:, 3:] = nptp_df.iloc[:, 3:].replace({1.0: 2.0})

nptp_df.iloc[:, 3:] = nptp_df.iloc[:, 3:].replace({0.0: 1.0})

nptp_df.iloc[:, 3:] = nptp_df.iloc[:, 3:].replace({2.0: np.nan})

cats = nptp_df.iloc[:, 3:]
s_noptp = cats.mul(nptp_df.varnum3, axis='rows')
s_noptp[s_noptp > 1] = 1
s_noptp.to_pickle('sc_noptp.pkl')

# ## Now get total ptp's for yes and no
tot_yesptp = s_yesptp

tot_yesptp = tot_yesptp.append(tot_yesptp.sum(numeric_only=True), ignore_index=True)

tot_yesptp['name'] = '# Yes PTP'

tot_yesptp = tot_yesptp.tail(1)

tot_yesptp.to_pickle('sc_f_yesptp_summary.pkl')

tot_noptp = s_noptp

tot_noptp = tot_noptp.append(tot_noptp.sum(numeric_only=True), ignore_index=True)

tot_noptp['name'] = '# No PTP'

tot_noptp = tot_noptp.tail(1)

tot_noptp.to_pickle('sc_g_noptp_summary.pkl')


# ## Now Append the dataframes
tcts = df4.iloc[:, 3]
tcts = pd.to_numeric(tcts)
avg_tcts = tcts.mean()

path = r'C:\\Bossa Nova\\audiototext\\sc\\Text Transcripts'
all_files = glob.glob(os.path.join(path, "*summary.pkl"))
df_from_each_file = (pd.read_pickle(f) for f in all_files)
allfiles_df = pd.concat(df_from_each_file, ignore_index=True)

allfiles_df['avg_tcts'] = avg_tcts
allfiles_df['fecha_update'] = today.strftime("%m/%d/%Y")

cols = list(allfiles_df.columns)
cols = [cols[-3]] + [cols[-1]] + [cols[-2]] + cols[:-3]
allfiles_df = allfiles_df[cols]

allfiles_df = allfiles_df.T

allfiles_df['subcat_code'] = allfiles_df.index

allfiles_df.columns = ['found', 'processed', 'yesmp', 'nomp', 'yesptp',
                       'noptp', 'subcat_code']

allfiles_df['process_date'] = allfiles_df['found'][1]

allfiles_df['cat_code'] = allfiles_df['subcat_code'].map(cat_code_dict)
allfiles_df['subcategory'] = allfiles_df['subcat_code'].map(subcat_to_subcategory)
allfiles_df['category'] = allfiles_df['cat_code'].map(cat_code_category_dict)

cols_to_convert = ['found', 'processed']
for col in cols_to_convert:
    allfiles_df[col] = pd.to_numeric(allfiles_df[col], errors='coerce')

allfiles_df['pct_found'] = allfiles_df['found'] / allfiles_df['processed']

allfiles_df.loc[allfiles_df.subcat_code == 'avg_tcts',
                'pct_found'] = allfiles_df['found']

allfiles_df.loc[allfiles_df.subcat_code == 'avg_tcts',
                'processed'] = allfiles_df['processed'].max()

allfiles_df.update(allfiles_df['pct_found'].fillna(0))

allfiles_df['batch'] = batch_df.iloc[0, 0]

allfiles_df['fecha_cosecha'] = pd.to_datetime(allfiles_df.batch, format='%d%m%Y')

allfiles_df['fecha_cosecha'] = allfiles_df['fecha_cosecha'].dt.strftime('%m/%d/%Y')

allfiles_df = allfiles_df.drop('batch', axis=1)

allfiles_df = allfiles_df[(allfiles_df.processed != 0) | (allfiles_df.pct_found != 0)]

allfiles_df = allfiles_df[allfiles_df['subcategory'].notna()]

cols_to_convert = ['yesmp', 'nomp']
for col in cols_to_convert:
    allfiles_df[col] = pd.to_numeric(allfiles_df[col], errors='coerce')

allfiles_df['primary_key'] = allfiles_df['subcat_code'] + allfiles_df['fecha_cosecha']

allfiles_df = allfiles_df[['found', 'processed', 'yesmp', 'nomp', 'yesptp',
                          'noptp', 'process_date', 'subcat_code', 'cat_code',
                           'subcategory', 'category', 'pct_found',
                           'fecha_cosecha', 'primary_key']]


allfiles_df.to_csv('agencias_Cat_Sub_Dash.csv', index=False)
