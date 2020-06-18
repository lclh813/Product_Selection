# Product_Selection

## Spyder Project
<br>
<div align=center><img src="https://github.com/lclh813/Product_Selection/blob/master/0_Pic/P_0_Project_Structure.png"/></div>
<br>

- ```data_config.py``` Define constants.
- ```create_db.py``` Import csv files into SQL database.

  * ![#e2f0d9](https://placehold.it/15/e2f0d9/000000?text=+) ```Get_Origin``` Create a dataframe from csv files.
  * ![#e2f0d9](https://placehold.it/15/e2f0d9/000000?text=+) ```Time_Detect``` Find columns whose names contain the word "time" and convert the column type from string to dtetime format.
  * ![#e2f0d9](https://placehold.it/15/e2f0d9/000000?text=+) ```Map_DB``` Data type mappings between Python and SQL Server.
  * ![#e2f0d9](https://placehold.it/15/e2f0d9/000000?text=+) ```Modify_DB``` Convert data type of columns that are misclassified as integer into string.
  * ![#e2f0d9](https://placehold.it/15/e2f0d9/000000?text=+) ```Auto_Create``` Create a new table in SQL Server and specify data type of each column. 
  * ![#e2f0d9](https://placehold.it/15/e2f0d9/000000?text=+) ```Insert_DB``` Insert data into SQL server.
  
- ```query_db.py``` Use ODBC drivers to connect Python to SQL Server and create the expected table.

  * ![#e2f0d9](https://placehold.it/15/e2f0d9/000000?text=+) ```_Filter_Sqlstr```
  * ![#e2f0d9](https://placehold.it/15/e2f0d9/000000?text=+) ```_Cum_Sqlstr```
  * ![#e2f0d9](https://placehold.it/15/e2f0d9/000000?text=+) ```Get_T1```
  * ![#e2f0d9](https://placehold.it/15/e2f0d9/000000?text=+) ```Get_T2```
  * ![#e2f0d9](https://placehold.it/15/e2f0d9/000000?text=+) ```Get_Both```
  * ![#e2f0d9](https://placehold.it/15/e2f0d9/000000?text=+) ```Comb_Range```

- ```main.py``` Contain all the execution codes.

## SQL - For Loop Statement


