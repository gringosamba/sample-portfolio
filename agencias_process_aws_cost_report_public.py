# RLudwig Updated March 2021
# This script to process AWS cost report and breakout different Caperio customer account costs

import pandas as pd
import os

os.chdir('C:\\Users\\roytl\\Stata to Python')

col_list = ["lineItem/LineItemDescription", "lineItem/ProductCode",
            "lineItem/UsageStartDate", "product/region",
            "lineItem/LineItemType", "lineItem/UnblendedCost",
            "lineItem/UnblendedRate", "lineItem/UsageAmount"]

df = pd.read_csv('AWS_First_Cost_Usage_Report-00001.csv', encoding='utf8',
                 usecols=col_list)

df.columns = ['type', 'start_date', 'product_code', 'seconds', 'cost',
              'awscharge', 'description', 'region']

df = df[(df["description"] != "free_tier") &
        (df["product_code"] == 'transcribe') & (df["region"] == 'us-east-1')
        & (df["type"].str.contains('usage', case=False))]

if df['product_code'].str.contains('transcribe').any():
    df['transdate'] = df.start_date.str[:10]
    pd.to_datetime(df['transdate'], errors='coerce')
    df = df.sort_values(by='transdate')

    df['caspiodate'] = df['transdate']
    df['caspiodate'] = pd.to_datetime(df.caspiodate, format='%Y-%m-%d')
    df['caspiodate'] = df['caspiodate'].dt.strftime('%m/%d/%Y')

    df['seconds'] = pd.to_numeric(df['seconds'], errors='coerce')

    df['minutes'] = df['seconds'].div(60).round(0)
    df['awscharge'] = df['awscharge'].groupby(df['caspiodate']).transform('sum')
    df['seconds'] = df['seconds'].groupby(df['caspiodate']).transform('sum')
    df['minutes'] = df['minutes'].groupby(df['caspiodate']).transform('sum')

    df = df.drop_duplicates(subset=['caspiodate'])

    df['caspiodate2'] = df['caspiodate']

    df = df[['caspiodate', 'awscharge', 'cost', 'seconds', 'minutes',
            'caspiodate2']]

    df.to_csv('aws_transcribe_costs_agencias_python.csv', index=False)
else:
    exit()
