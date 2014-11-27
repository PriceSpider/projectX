import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

name='FRA_MEL_trial2.csv'
df = pd.read_csv(name,header=None,sep=',')
n_data = len(df)

col_dat = np.zeros(n_data)
column2bfilled1 = pd.DataFrame(col_dat,columns={4})
column2bfilled2 = pd.DataFrame(col_dat,columns={5})

df = pd.concat([df,column2bfilled1,column2bfilled2],axis=1)

print df

def convert_date(d):
    d=str(d)
    year=d[:-4]
    month=d[2:4]
    day=d[4:6]
    #return b+'/'+c+'/'+'20'+a
    return '20'+year+'-'+month+'-'+day

for row in range(n_data):
  print row
  
  #!!!cutting off 6 letters is only necessary in old data!!!
  date_clean = df[0].as_matrix()[row][:-6]

  df[0][row] = date_clean
  print date_clean

  dep = df[1].as_matrix()[row]
  ret = df[2].as_matrix()[row]

  dep_date =  convert_date(dep)
  ret_date =  convert_date(ret)
  
  departure = np.datetime64(dep_date)
  return_ = np.datetime64(ret_date)
  query = np.datetime64(date_clean)
  
  df[1][row] = dep_date
  df[2][row] = ret_date
  
  delta1 = return_-departure
  delta2 = departure-query
  delta1_r = round(delta1/np.timedelta64(1, 'm'))
  delta2_r = round(delta2/np.timedelta64(1, 'm'))
  
  df[4][row] = delta1_r
  df[5][row] = delta2_r
 
name2 = name[:-4]+'_timed.csv'
df.to_csv(name2, sep = ',', header=None,index=None)