df.groupby(col1).agg(np.mean)

# ======= Filter ==========
# filter non digits account
df[~df.account.str.isdigit()] 

# find integer rows subset for col
df[df[col].apply(lambda x: isinstance(x, np.int))]

quit_data = data[~data['quit_date'].isnull()]

df['grammer'].str.contains("Python")

df['split'] = df['linestaion'].str.split('_')

df[df['popularity'] == df['popularity'].max()]

np.median(df['salary'])

df.set_index("createTime")

#Apply the max() across each row
df.apply(np.max,axis=1)

df['len_str'] = df['grammer'].map(lambda x: len(x))

df["test1"] = df["salary"].map(str) + df['education']

#Create a pivot table that groups by col1 and calculates the mean of col2 and col3
df.pivot_table(index=col1, values=[col2,col3], aggfunc=mean)

df.sort_values([col1,col2], ascending=[True,False])
df.sort_values('salary', ascending=False)

df[(df[col] > 0.6) & (df[col] < 0.8)]

df1.join(df2,on=col1, how='inner')

pd.merge(df1, df2, how='left', on=['key1', 'key2'])

#Add the columns in df1 to the end of df2 (rows should be identical)
pd.concat([df1, df2],axis=1)  　# 横向增加 columns；  如果需要纵向， axis=0


df.rename(columns={'old_name': 'new_ name'})

del df['categories']
# 等价于
df.drop(columns=['categories'], inplace=True)

# False : Mark all duplicates as True
condition = df.duplicated(subset=['A'], keep=False)
df[condition]

s.loc['index_one']: Selection by index
s.iloc[0]: Selection by position
df.iloc[0,:]: First row
df.iloc[0,0]: First element of first column


df.isnull().values.any()

df.isnull().sum()

df['education'].nunique()

df.dropna(axis=0, how='any', inplace=True)

df['col1'][~df['col1'].isin(df['col2'])]