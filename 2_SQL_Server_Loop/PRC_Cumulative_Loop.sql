ALTER PROC PRC_Cumulative_Loop
AS
BEGIN 

	DROP TABLE IF EXISTS #cumulative

	; WITH Table_Alias_5 AS (
		SELECT [Col_1], [Col_14]
		FROM [dbo].[Filtered]
		GROUP BY [Col_1], [Col_14]
	), Table_Alias_6 AS (
		SELECT [Col_1], STRING_AGG([Col_14], ',') WITHIN GROUP (ORDER BY [Col_14]) AS [Alias_1]
		FROM Table_Alias_5
		GROUP BY [Col_1]
	), Table_Alias_7 AS (
		SELECT [Alias_1], COUNT(DISTINCT [Col_1]) AS [Alias_2]
		FROM Table_Alias_5
		GROUP BY [Alias_1]
	), Table_Alias_8 AS (
		SELECT *, LEN([Alias_1]) - LEN(REPLACE([Alias_1], ',', '')) + 1 AS [Alias_3]
		FROM Table_Alias_7
	), Table_Alias_9 AS (
		SELECT *, ROW_NUMBER() OVER (ORDER BY [Alias_2] DESC, [Alias_1]) AS [Alias_4]
		FROM Table_Alias_8
	), Table_Alias_10 AS (
		SELECT tb1.[Alias_1], tb1.[Alias_2], tb1.[Alias_3],
			   SUM(tb1.[Alias_2]) OVER (ORDER BY tb1.[Alias_4]) AS [Alias_6],
			   ROUND(tb1.[Alias_2] / CAST(tb2.[Alias_5] AS FLOAT), 6) AS [Alias_7],
			   ROUND(SUM(tb1.[Alias_2]) OVER (ORDER BY tb1.[Alias_4]) / CAST(tb2.[Alias_5] AS FLOAT), 6) AS [Alias_8]
		FROM Table_Alias_9 AS tb1,
			 (SELECT COUNT(DISTINCT [Col_1]) AS [Alias_5] FROM [dbo].[Filtered]) AS tb2
	)

	SELECT *
	INTO #cumulative
	FROM Table_Alias_10

	DECLARE @iter FLOAT = 0.05
	WHILE @iter < 0.5
	BEGIN    
		DROP TABLE IF EXISTS #product_list

		SELECT tb1.[Alias_1]
		INTO #product_list
		FROM #cumulative AS tb1,
			 (SELECT TOP 1 *
			  FROM #cumulative
			  WHERE [Alias_8] >= @iter
			  ORDER BY [Alias_8]) AS tb2
		WHERE tb1.[Alias_8] <= tb2.[Alias_8]
		ORDER BY tb1.[Alias_8]

		DROP TABLE IF EXISTS #product_list_distinct

		SELECT DISTINCT VALUE AS [Col_14]
		INTO #product_list_distinct
		FROM #product_list
		CROSS APPLY STRING_SPLIT([Alias_1], ',')

		INSERT INTO Result
		SELECT @iter AS [Res_1],
			  (SELECT COUNT([Col_14]) FROM #product_list_distinct) AS [Res_2], 
			   SUM(Res_3) AS [Res_3],
			   SUM(Res_4) AS [Res_4],
			   COUNT([Col_1]) AS [Res_5],
			   ROUND(SUM(Res_3) / CAST(COUNT([Col_1]) AS FLOAT), 2) AS [Res_6],
			   ROUND(SUM(Res_4) / CAST(COUNT([Col_1]) AS FLOAT), 2) AS [Res_7]
		FROM (
			  SELECT [Col_1],
					 COUNT(DISTINCT [Alias_10]) AS [Res_3], 
					 COUNT(DISTINCT [Alias_9]) AS [Res_4]
			  FROM (	
					SELECT tb1.[Col_1], 
						   tb1.[Col_14], 
						   tb1.[Col_15] AS [Alias_10],
						   CASE WHEN tb2.[Col_14] IS NULL THEN tb1.[Col_15] ELSE '12' END AS [Alias_9]
					FROM [dbo].[Filtered] AS tb1
					LEFT JOIN  #product_list_distinct AS tb2
					ON tb1.[Col_14] = tb2.[Col_14]
					) AS change_warehouse
			GROUP BY [Col_1]
			) AS count_warehouse_per_order

		SET @iter += 0.05

	END

END
