import pandas as pd
import csv
import datetime
import re
import sys


input_filename = sys.argv[1]
output_filename = sys.argv[2]

data = pd.read_csv(input_filename, sep=",")
df = data[['Time', 'Bucket', 'Bucket Owner', 'Remote IP', 'Requester',
       'Request ID', 'Operation', 'Key', 'Request-URI', 'HTTP status',
       'Error Code', 'Bytes Sent', 'Object Size', 'Total Time',
       'Turn-Around Time', 'Referer', 'User-Agent', 'Version Id', 'Host Id',
       'Signature Version', 'Cipher Suite', 'Authentication Type',
       'Host Header', 'TLS version', 'Access Point ARN', 'aclRequired']]


df['Date'] = 0
for i in range(len(df.Time)):
    df.Time.loc[i] = re.sub('[\[\]]',' ',df.Time.loc[i])
    df.Time.loc[i] = re.sub('\:',' ',df.Time.loc[i])
    df.Time.loc[i] = re.sub('\+(\d){4} ','',df.Time.loc[i])
    df.Time.loc[i] = df.Time.loc[i].strip()
    df.Time.loc[i] = datetime.datetime.strptime(df.Time.loc[i],"%d/%B/%Y %H %M %S")
    df['Date'].loc[i] = df['Time'].loc[i].strftime("%d%m%y")
    df['Time'].loc[i] = df['Time'].loc[i].strftime("%H%M%S")

df = df[['Date','Time', 'Bucket', 'Bucket Owner', 'Remote IP', 'Requester',
       'Request ID', 'Operation', 'Key', 'Request-URI', 'HTTP status',
       'Error Code', 'Bytes Sent', 'Object Size', 'Total Time',
       'Turn-Around Time', 'Referer', 'User-Agent', 'Version Id', 'Host Id',
       'Signature Version', 'Cipher Suite', 'Authentication Type',
       'Host Header', 'TLS version', 'Access Point ARN', 'aclRequired']]

for i in range(len(df)):
    df['Request ID'].loc[i] = ''
    df['Bytes Sent'].loc[i] = ''
    df['Object Size'].loc[i] = ''
    df['Total Time'].loc[i] = ''
    df['Turn-Around Time'].loc[i] = ''
    df['Host Id'].loc[i] = ''
    if df['Key'].loc[i] == '' :
        df['Key'].loc[i] = '0'
    else:
        df['Key'].loc[i] = '1'

cols = ['Bucket', 'Bucket Owner', 'Remote IP', 'Requester',
       'Request ID', 'Operation', 'Key', 'Request-URI', 'HTTP status',
       'Error Code', 'Bytes Sent', 'Object Size', 'Total Time',
       'Turn-Around Time', 'Referer', 'User-Agent', 'Version Id', 'Host Id',
       'Signature Version', 'Cipher Suite', 'Authentication Type',
       'Host Header', 'TLS version', 'Access Point ARN', 'aclRequired']
df['Content'] =df[cols].apply(lambda row: ' '.join(row.values.astype(str)), axis=1)
df = df.drop(['Bucket', 'Bucket Owner', 'Remote IP', 'Requester',
       'Request ID', 'Operation', 'Key', 'Request-URI', 'HTTP status',
       'Error Code', 'Bytes Sent', 'Object Size', 'Total Time',
       'Turn-Around Time', 'Referer', 'User-Agent', 'Version Id', 'Host Id',
       'Signature Version', 'Cipher Suite', 'Authentication Type',
       'Host Header', 'TLS version', 'Access Point ARN', 'aclRequired'],axis=1)

df.to_csv(output_filename, sep = ',', index=False)
import os
os.getcwd()
