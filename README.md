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
| Orange      | Shop 3     |

> ***2.1.2. Transaction Records***

| Order ID | Product  | Quantity | 
| :---:    | :---     | :---:    | 
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

| Product Set           | Order ID          | # of Order | Cumulative # of Order | % of Total Orders |
| :---                  | :---              | :---:      | :---:                 | :---:             |
| Apple                 | #001, #004, #005  | 3          | 3                     | 50%               |
| Apple, Banana         | #002, #006        | 2          | 5                     | 83%               | 
| Apple, Banana, Orange | #003              | 1          | 6                     | 100%              |

> ***2.3.2. Find Product Set Exceeding Given Thresholds***

| % of Total Orders | Product Set Moved to New Shop |
| :---:             | :---                          |
| 50%               | Apple                         |
| 60%               | Apple, Banana                 |
| 70%               | Apple, Banana                 |
| 80%               | Apple, Banana                 |
| 90%               | Apple, Banana, Orange         |
| 100%              | Apple, Banana, Orange         |

> ***2.3.3. Relocate Products Based on Given Thresholds***

| Order ID | Product  | Quantity | Meet 50% of Total Orders | Meet 70% of Total Orders | Meet 90% of Total Orders |
| :---:    | :---:    | :---:    | :---:                    | :---:                    | :---:                    |
| #001     | Apple    | 10       | New Shop                 | New Shop                 | New Shop                 |     
| #002     | Apple    | 5        | New Shop                 | New Shop                 | New Shop                 |
| #002     | Banana   | 1        | Shop 2                   | New Shop                 | New Shop                 |
| #003     | Apple    | 2        | New Shop                 | New Shop                 | New Shop                 |
| #003     | Banana   | 3        | Shop 2                   | New Shop                 | New Shop                 |
| #003     | Orange   | 6        | Shop 3                   | Shop 3                   | New Shop                 |
| #004     | Apple    | 20       | New Shop                 | New Shop                 | New Shop                 |
| #005     | Apple    | 15       | New Shop                 | New Shop                 | New Shop                 |
| #006     | Apple    | 7        | New Shop                 | New Shop                 | New Shop                 |
| #006     | Banana   | 4        | Shop 2                   | New Shop                 | New Shop                 |
  
> ***2.3.4. Compare Shipping Efficiency Befroe and After the Relocation***

| % of Total Orders | Product Set           | # of Shipping Before Relocation | # of Shipping After Relocation | 
| :---:             | :---                  | :---:                           | :---:                          |
| 50%               | Apple                 | 10                              | 10                             |
| 70%               | Apple, Banana         | 10                              | 7                              |
| 90%               | Apple, Banana, Orange | 10                              | 5                              |

- Number of Shipping **Before** Relocation = 1 (#001) +2 (#002) +3 (#003) +1 (#004) +1 (#005) +2 (#006) = 10
- Number of Shipping **After** Relocation (**50%**) = 1 (#001) +2 (#002) +3 (#003) +1 (#004) +1 (#005) +2 (#006) = 10
- Number of Shipping **After** Relocation (**70%**) = 1 (#001) +1 (#002) +2 (#003) +1 (#004) +1 (#005) +1 (#006) = 7 
- Number of Shipping **After** Relocation (**90%**) = 1 (#001) +1 (#002) +1 (#003) +1 (#004) +1 (#005) +1 (#006) = 5

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


