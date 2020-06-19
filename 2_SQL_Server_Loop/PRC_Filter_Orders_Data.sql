--暫存表：#Orders
--1. 2019/6出貨資料加上區和旗標
--2. 合併2019/5-2019/6出貨資料
--實體表：Filtered
--1. 排除倉庫：9,10
--2. 排除出貨類別：安裝,超大,大陸,海外
--3. 排除跨併內：5,6,7,8,9,10,11,22,23

ALTER PROC PRC_Filter_Orders_Data
AS
BEGIN

DROP TABLE IF EXISTS #Orders

; WITH Delivery_201906 AS (
	SELECT tb1.[訂單編號]
		  ,tb1.[揀貨單號]
		  ,tb1.[宅配商]
		  ,tb1.[出貨箱號]
		  ,tb1.[出貨箱數]
		  ,tb1.[訂單時間]
		  ,tb1.[轉單時間]
		  ,tb1.[印揀貨單時間]
		  ,tb1.[嗶阿尼時間]
		  ,tb1.[出庫時間]
		  ,tb1.[印宅配單時間]
		  ,tb1.[出貨時間]
		  ,tb1.[第一次配達時間]
		  ,tb1.[商品ID]
		  ,tb1.[揀貨單庫別]
		  ,tb1.[材積(長；公分)]
		  ,tb1.[材積(寬；公分)]
		  ,tb1.[材積(高；公分)]
		  ,tb1.[商品數量]
		  ,tb1.[郵遞區號]
		  ,tb1.[出貨類別]
		  ,tb1.[是否為離島訂單]
		  ,tb2.[區ID]
		  ,tb2.[區名稱]
		  ,tb2.[旗標]
	FROM [dbo].[201906] AS tb1
	LEFT JOIN [dbo].[Sector] AS tb2
	ON LEFT(tb1.[商品ID], 4) = tb2.[區ID]
), Delivery_201905_201906 AS (
	SELECT *
	FROM Delivery_201906
	UNION ALL
	SELECT [訂單編號]
		  ,[揀貨單號]
		  ,[宅配商]
		  ,[出貨箱號]
		  ,[出貨箱數]
		  ,[訂單時間]
		  ,[轉單時間]
		  ,[印揀貨單時間]
		  ,[嗶阿尼時間]
		  ,[出庫時間]
		  ,[印宅配單時間]
		  ,[出貨時間]
		  ,[第一次配達時間]
		  ,[商品ID]
		  ,[揀貨單庫別]
		  ,[材積(長；公分)]
		  ,[材積(寬；公分)]
		  ,[材積(高；公分)]
		  ,[商品數量]
		  ,[郵遞區號]
		  ,[出貨類別]
		  ,[是否為離島訂單]
		  ,[區編]
		  ,[區名]
		  ,[路標]
	FROM [dbo].[201905]
)

SELECT * 
INTO #Orders
FROM Delivery_201905_201906

--Delete一筆筆刪(可以篩選要刪除的資料)，Truncate是整張Table一次刪掉(不可以篩選要刪除的資料)
TRUNCATE TABLE Filtered

--找出訂單編號是檢貨單庫別 IN 9 10 或 出貨類別 IN (大陸 海外...) 或 跨併時段內[黑名單]
; WITH black_list AS (
	SELECT DISTINCT [訂單編號]
	FROM #Orders
	WHERE [揀貨單庫別] IN (9, 10)
	OR ([出貨類別] LIKE '%安裝%' OR 
		[出貨類別] LIKE '%超大%' OR
		[出貨類別] LIKE '%大陸%' OR
		[出貨類別] LIKE '%海外%')
	OR DATEPART(HOUR, [訂單時間]) NOT IN (5,6,7,8,9,10,11,22,23)
), filtered_orders AS (
	SELECT *
	FROM #Orders
	WHERE [訂單編號] NOT IN (SELECT [訂單編號] FROM black_list)
)

INSERT INTO Filtered
SELECT *
FROM filtered_orders

END