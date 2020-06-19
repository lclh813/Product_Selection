from data_config import *
import pandas as pd
import numpy as np
from tqdm import tqdm

class Data_SRC:
    def __init__(self):
        self.conn = CONN             
    
    def _Filter_Sqlstr(self) -> str:
        sqlstr = '''
        SELECT [Col_1], [Col_14], [Col_15]
        FROM [dbo].[Filtered]
        '''
        return sqlstr
    
    def _Cum_Sqlstr(self) -> str:
        sqlstr = '''
        ; WITH unique_product_per_order AS (
        	SELECT [Col_1], [Col_14]
        	FROM [dbo].[Filtered]
        	GROUP BY [Col_1], [Col_14]
        ), unique_product_set_per_order AS (
        	SELECT [Col_1], STRING_AGG([Col_14], ',') WITHIN GROUP (ORDER BY [Col_14]) AS [Alias_1]
        	FROM unique_product_per_order
        	GROUP BY [Col_1]
        ), count_order_by_unique_product_set AS (
        	SELECT [Alias_1], COUNT(DISTINCT [Col_1]) AS [Alias_2]
        	FROM unique_product_set_per_order
        	GROUP BY [Alias_1]
        ), count_product_per_order AS (
        	SELECT *, LEN([Alias_1]) - LEN(REPLACE([Alias_1], ',', '')) + 1 AS [Alias_3]
        	FROM count_order_by_unique_product_set
        ), rank_by_num_order_desc AS (
        	SELECT *, ROW_NUMBER() OVER (ORDER BY [Alias_2] DESC, [Alias_1]) AS [Alias_4]
        	FROM count_product_per_order
        ), cumulative_sum_order AS (
        	SELECT tb1.[Alias_1], tb1.[Alias_2], tb1.[Alias_3],
        		   SUM(tb1.[Alias_2]) OVER (ORDER BY tb1.[Alias_4]) AS [Alias_6],
        		   ROUND(tb1.[Alias_2] / CAST(tb2.[Alias_5] AS FLOAT), 6) AS [Alias_7],
        		   ROUND(SUM(tb1.[Alias_2]) OVER (ORDER BY tb1.[Alias_4]) / CAST(tb2.[Alias_5] AS FLOAT), 6) AS [Alias_8]
        	FROM rank_by_num_order_desc AS tb1,
        		 (SELECT COUNT(DISTINCT [Col_1]) AS [Alias_5] FROM [dbo].[Filtered]) AS tb2
        )
        SELECT *
        FROM cumulative_sum_order
        '''
        return sqlstr
    
    def Get_T1(self) -> pd.DataFrame:
        sqlstr = self._Filter_Sqlstr()
        df =  pd.read_sql(sqlstr, self.conn)
        return df
    
    def Get_T2(self) -> pd.DataFrame:
        sqlstr = self._Cum_Sqlstr()
        df =  pd.read_sql(sqlstr, self.conn)
        return df
    
    def Get_Both(self) -> list:
        return [self.Get_T1(), self.Get_T2()]
    
    def Comb_Range(self) -> pd.DataFrame:
        df1 = self.Get_T1()
        df2 = self.Get_T2()        
        
        result_lst = [[] for i in range(7)]
        
        old_warehouse = len(df1.groupby('Col_1')['Col_15'].value_counts())
        num_order = df1['Col_1'].nunique()
        
        loop_len = 10      
        for bdd in tqdm([round(0.05 * (j+1), 2) for j in range(loop_len)]):
            row_ind = df2[df2['Alias_8'] >= bdd].index[0]
            prod_lst = list(df2.loc[:row_ind, 'Alias_1'])
            prod_lst = pd.Series(','.join(prod_lst).split(',')).unique()
            
            tmp = df1.copy()
            tmp['Alias_9'] = np.where(tmp['Col_14'].isin(prod_lst), '12', tmp['Col_15'])
            new_warehouse = pd.Series([(i, j) for i, j in zip(tmp['Col_1'], tmp['Alias_9'])]).nunique()            
            
            for k, l in enumerate([bdd, len(prod_lst), 
                                   old_warehouse, new_warehouse, num_order,
                                   round(old_warehouse/num_order,2), 
                                   round(new_warehouse/num_order,2)]):
                result_lst[k].append(l)
        result_df = pd.DataFrame(result_lst).T
        result_df.columns = ['Res_1', 'Res_2', 
                             'Res_3', 'Res_4', 'Res_5', 
                             'Res_6', 'Res_7']
        return result_df