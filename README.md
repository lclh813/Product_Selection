# Product_Selection
## Part 1. Objective

To manage inventory with multiple locations by relocating products based on certain criteria to see if shipping costs can be reduced effectively.

## Part 2. Data
### 2.1. Background Information
> ***Product List and Corresponding Storage Location***

| Prouduct    | Shop       |
| :---        | :---       |
| Apple       | Shop 1     |
| Banana      | Shop 2     |
| Grapes      | Shop 3     |
| Lemon       | Shop 4     |
| Orange      | Shop 5     |
| Strawberry  | Shop 6     |

### 2.2. Original Data
> ***Transaction Records***

| Order ID | Product  | Quantity | Shop   |
| :---     | :---     | :---     | :---   |
| #001     | Apple    | 10       | Shop 1 |
| #002     | Apple    | 5        | Shop 1 |
| #002     | Banana   | 1        | Shop 2 |
| #003     | Apple    | 2        | Shop 1 |
| #003     | Banana   | 3        | Shop 2 |
| #003     | Orange   | 6        | Shop 5 |
| #004     | Apple    | 20       | Shop 1 |
| #005     | Apple    | 15       | Shop 1 |
| #006     | Apple    | 7        | Shop 1 |
| #006     | Banana   | 4        | Shop 2 |

### 2.3. Expected Result
> ***2.3.1. Concat Purchased Products by Order ID***

| Product               | Order ID          | # of Order | Cumulative # of Order | 
| :---                  | :---              | :---       | :---                  |
| Apple                 | #001, #004, #005  | 3          | 3                     |
| Apple, Banana         | #002, #006        | 2          | 5                     |  
| Apple, Banana, Orange | #003              | 1          | 6                     |


























## Spyder Project
<br>
<div align=center><img src="https://github.com/lclh813/Product_Selection/blob/master/0_Pic/P_0_Project_Structure.png"/></div>
<br>

- ```data_config.py``` Define constants.
- ```create_db.py``` Import csv files into SQL database.

  * ![#e2f0d9](https://placehold.it/15/e2f0d9/000000?text=+) ```Get_Origin``` Create a dataframe from csv files.
  * ![#e2f0d9](https://placehold.it/15/e2f0d9/000000?text=+) ```Time_Detect``` Find columns whose names contain "time" and convert the column type from string to datetime format.
  * ![#e2f0d9](https://placehold.it/15/e2f0d9/000000?text=+) ```Map_DB``` Data type mappings between Python and SQL Server.
  * ![#e2f0d9](https://placehold.it/15/e2f0d9/000000?text=+) ```Modify_DB``` Convert data type of columns that are misclassified as integer into string.
  * ![#e2f0d9](https://placehold.it/15/e2f0d9/000000?text=+) ```Auto_Create``` Create a new table in SQL Server and specify data type of each column. 
  * ![#e2f0d9](https://placehold.it/15/e2f0d9/000000?text=+) ```Insert_DB``` Insert data into SQL server.
  
- ```query_db.py``` Use ODBC driver to connect Python to SQL Server and create the expected table.

  * ![#e2f0d9](https://placehold.it/15/e2f0d9/000000?text=+) ```_Filter_Sqlstr``` Select columns that will be used. (Table 1)
  * ![#e2f0d9](https://placehold.it/15/e2f0d9/000000?text=+) ```_Cum_Sqlstr``` Select a list of products based on certain criteria. (Table 2)
  * ![#e2f0d9](https://placehold.it/15/e2f0d9/000000?text=+) ```Get_T1``` Return all rows and all columns from Table 1.
  * ![#e2f0d9](https://placehold.it/15/e2f0d9/000000?text=+) ```Get_T2``` Return all rows and all columns from Table 2.
  * ![#e2f0d9](https://placehold.it/15/e2f0d9/000000?text=+) ```Get_Both``` Return Table 1 and Table 2.
  * ![#e2f0d9](https://placehold.it/15/e2f0d9/000000?text=+) ```Comb_Range``` Create the expected result.

- ```main.py``` Contain all the execution codes.

## SQL - For Loop Statement


