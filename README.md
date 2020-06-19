# Product_Selection
## Part 1. Objective

To manage inventory with multiple locations by relocating products based on certain criteria to see if shipping costs can be reduced effectively.

## Part 2. Data
### 2.1. Original Data
> ***2.1.1. Product List and Corresponding Storage Location***

| Prouduct    | Shop       |
| :---        | :---       |
| Apple       | Shop 1     |
| Banana      | Shop 2     |
| Grapes      | Shop 3     |
| Lemon       | Shop 4     |
| Orange      | Shop 5     |
| Strawberry  | Shop 6     |

> ***2.1.2. Transaction Records***

| Order ID | Product  | Quantity | 
| :---     | :---     | :---     | 
| #001     | Apple    | 10       | 
| #002     | Apple    | 5        |
| #002     | Banana   | 1        | 
| #003     | Apple    | 2        |
| #003     | Banana   | 3        |
| #003     | Orange   | 6        | 
| #004     | Apple    | 20       | 
| #005     | Apple    | 15       |
| #006     | Apple    | 7        | 
| #006     | Banana   | 4        | 

### 2.3. Expected Result
> ***2.3.1. Concat Purchased Products by Order ID***

| Product               | Order ID          | # of Order | Cumulative # of Order | % of Total Orders |
| :---                  | :---              | :---       | :---                  | :---              |
| Apple                 | #001, #004, #005  | 3          | 3                     | 50%               |
| Apple, Banana         | #002, #006        | 2          | 5                     | 83%               | 
| Apple, Banana, Orange | #003              | 1          | 6                     | 100%              |

> ***2.3.2. Find Product Sets that Satisfy Given Thresholds***

| % of Total Orders | Product               |
| :---              | :---                  |
| 50%               | Apple                 |
| 60%               | Apple, Banana         |
| 70%               | Apple, Banana         |
| 80%               | Apple, Banana         |
| 90%               | Apple, Banana, Orange |
| 100%              | Apple, Banana, Orange |

> ***2.3.3. ***





























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


