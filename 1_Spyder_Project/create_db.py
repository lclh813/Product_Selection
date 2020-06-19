from data_config import *
import pandas as pd
import numpy as np
from tqdm import tqdm

class Create_DB: 
    def __init__(self):
        self.add_col = ['Maintain Time','Maintain Staff']
        self.add_type = ['datetime','nvarchar(50)']
        self.staff_ID = 'Staff ID'         
        
    def Get_Origin(self) -> pd.DataFrame:
        db_folder = os.path.join(FOLDER_PATH, FOLDER_NAME)
        db_files = os.listdir(db_folder)
        db_src = [os.path.join(db_folder, file) for file in db_files]
        data = pd.DataFrame([])
        for file in db_src:
            try:            
                data = data.append(pd.read_csv(file, encoding='ANSI'))
            except: 
                data = data.append(pd.read_excel(file, encoding='ANSI'))
        
        data = data.reset_index(drop=True)                 
        origin_type = data.dtypes.astype(str)
        return data , origin_type
    
    def Time_Detect(self) -> list:
        df, origin_type = self.Get_Origin()
        get_bool = df.columns.str.contains('Time')
        for i, col_name, is_time in zip(range(df.shape[1]), df.columns, get_bool):
            if is_time:           
                origin_type[i] = 'datetime64[ns]'
        return origin_type
    
    def Map_DB(self) -> pd.Series:
        origin_type = self.Time_Detect()
        origin_str = ['object', 'int64', 'datetime64[ns]', 'float64']
        db_str = ['nvarchar(50)','int','datetime','float']
        type_map = dict(zip(origin_str, db_str))
        db_type = origin_type.apply(lambda x: type_map[x])
        return db_type
    
    def Modify_DB(self) -> pd.Series:
        db_type = self.Map_DB()
        get_bool = db_type.index.isin(['Column_A', 'Column_B'])
        for i, is_modify in zip(range(len(db_type.values)), get_bool):
           if is_modify:
               db_type[i] = 'nvarchar(50)'
        return db_type
    
    def Auto_Create(self):
        db_type = self.Modify_DB()
        col_name = list(db_type.index[1:]) + self.add_col
        col_type = list(db_type.values[1:]) + self.add_type
        conn = CONN
        cursor = CONN.cursor()
        sqlstr = f'CREATE TABLE "{TB_NAME}" ('
        sqlstr += ',\n'.join([f'[{i}] {j}' for i, j in zip(col_name, col_type)])
        sqlstr += ')'
        cursor.execute(sqlstr)
        conn.commit()
        cursor.close()
    
    def Insert_DB(self):
        df = self.Get_Origin()[0].iloc[:, 1:]
        maintain_time = str(datetime.datetime.today())[:16]        
        conn = CONN
        cursor = CONN.cursor()
        cursor.fast_executemany = True
        chunk = 1000
        for i in tqdm(range(0, len(df), chunk)):
            sqlstr = f'INSERT INTO "{TB_NAME}" VALUES'
            for row in df[i:i+chunk].itertuples(index=False, name=None): 
                sqlstr += '(' + str(list(row))[1:-1].replace("'NULL'", 'NULL')
                sqlstr += f", '{maintain_time}', '{self.staff_ID}'),"
            sqlstr = sqlstr[:-1] + ';'
            cursor.execute(sqlstr)
            conn.commit()
        cursor.close()