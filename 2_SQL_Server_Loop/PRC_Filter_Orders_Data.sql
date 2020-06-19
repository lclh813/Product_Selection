ALTER PROC PRC_Filter_Orders_Data
AS
BEGIN

DROP TABLE IF EXISTS #Orders

; WITH Table_Alias_1 AS (
	SELECT tb1.[Col_1]
		  ,tb1.[Col_2]
		  ,tb1.[Col_3]
		  ,tb1.[Col_4]
		  ,tb1.[Col_5]
		  ,tb1.[Col_6]
		  ,tb1.[Col_7]
		  ,tb1.[Col_8]
		  ,tb1.[Col_9]
		  ,tb1.[Col_10]
		  ,tb1.[Col_11]
		  ,tb1.[Col_12]
		  ,tb1.[Col_13]
		  ,tb1.[Col_14]
		  ,tb1.[Col_15]
		  ,tb1.[Col_16]
		  ,tb1.[Col_17]
		  ,tb1.[Col_18]
		  ,tb1.[Col_19]
		  ,tb1.[Col_20]
		  ,tb1.[Col_21]
		  ,tb1.[Col_22]
		  ,tb2.[Col_4]
		  ,tb2.[Col_3]
		  ,tb2.[Col_2]
	FROM [dbo].[Table_1] AS tb1
	LEFT JOIN [dbo].[Table_2] AS tb3
	ON LEFT(tb1.[Col_14], 4) = tb2.[Col_4]
), Table_Alias_2 AS (
	SELECT *
	FROM Table_Alias_1
	UNION ALL
	SELECT [Col_1]
		  ,[Col_2]
		  ,[Col_3]
		  ,[Col_4]
		  ,[Col_5]
		  ,[Col_6]
		  ,[Col_7]
		  ,[Col_8]
		  ,[Col_9]
		  ,[Col_10]
		  ,[Col_11]
		  ,[Col_12]
		  ,[Col_13]
		  ,[Col_14]
		  ,[Col_15]
		  ,[Col_16]
		  ,[Col_17]
		  ,[Col_18]
		  ,[Col_19]
		  ,[Col_20]
		  ,[Col_21]
		  ,[Col_22]
		  ,[Col_23]
		  ,[Col_24]
		  ,[Col_25]
	FROM [dbo].[Table_2]
)

SELECT * 
INTO #Orders
FROM Table_Alias_2

TRUNCATE TABLE Filtered

; WITH Table_Alias_3 AS (
	SELECT DISTINCT [Col_1]
	FROM #Orders
	WHERE [Col_15] IN (9, 10)
	OR ([Col_21] LIKE '%Filter_1%' OR 
		[Col_21] LIKE '%Filter_2%' OR
		[Col_21] LIKE '%Filter_3%' OR
		[Col_21] LIKE '%Filter_4%')
	OR DATEPART(HOUR, [Col_6]) NOT IN (1, 2, 3, 4, 11, 12, 13, 14)
), Table_Alias_4 AS (
	SELECT *
	FROM #Table_Temp_1
	WHERE [Col_1] NOT IN (SELECT [Col_1] FROM Table_Alias_3)
)

INSERT INTO Filtered
SELECT *
FROM Table_Alias_3

END