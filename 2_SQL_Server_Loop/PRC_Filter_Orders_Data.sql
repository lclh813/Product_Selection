--�Ȧs��G#Orders
--1. 2019/6�X�f��ƥ[�W�ϩM�X��
--2. �X��2019/5-2019/6�X�f���
--�����GFiltered
--1. �ư��ܮw�G9,10
--2. �ư��X�f���O�G�w��,�W�j,�j��,���~
--3. �ư���֤��G5,6,7,8,9,10,11,22,23

ALTER PROC PRC_Filter_Orders_Data
AS
BEGIN

DROP TABLE IF EXISTS #Orders

; WITH Delivery_201906 AS (
	SELECT tb1.[�q��s��]
		  ,tb1.[�z�f�渹]
		  ,tb1.[�v�t��]
		  ,tb1.[�X�f�c��]
		  ,tb1.[�X�f�c��]
		  ,tb1.[�q��ɶ�]
		  ,tb1.[���ɶ�]
		  ,tb1.[�L�z�f��ɶ�]
		  ,tb1.[�ͪ����ɶ�]
		  ,tb1.[�X�w�ɶ�]
		  ,tb1.[�L�v�t��ɶ�]
		  ,tb1.[�X�f�ɶ�]
		  ,tb1.[�Ĥ@���t�F�ɶ�]
		  ,tb1.[�ӫ~ID]
		  ,tb1.[�z�f��w�O]
		  ,tb1.[���n(���F����)]
		  ,tb1.[���n(�e�F����)]
		  ,tb1.[���n(���F����)]
		  ,tb1.[�ӫ~�ƶq]
		  ,tb1.[�l���ϸ�]
		  ,tb1.[�X�f���O]
		  ,tb1.[�O�_�����q�q��]
		  ,tb2.[��ID]
		  ,tb2.[�ϦW��]
		  ,tb2.[�X��]
	FROM [dbo].[201906] AS tb1
	LEFT JOIN [dbo].[Sector] AS tb2
	ON LEFT(tb1.[�ӫ~ID], 4) = tb2.[��ID]
), Delivery_201905_201906 AS (
	SELECT *
	FROM Delivery_201906
	UNION ALL
	SELECT [�q��s��]
		  ,[�z�f�渹]
		  ,[�v�t��]
		  ,[�X�f�c��]
		  ,[�X�f�c��]
		  ,[�q��ɶ�]
		  ,[���ɶ�]
		  ,[�L�z�f��ɶ�]
		  ,[�ͪ����ɶ�]
		  ,[�X�w�ɶ�]
		  ,[�L�v�t��ɶ�]
		  ,[�X�f�ɶ�]
		  ,[�Ĥ@���t�F�ɶ�]
		  ,[�ӫ~ID]
		  ,[�z�f��w�O]
		  ,[���n(���F����)]
		  ,[���n(�e�F����)]
		  ,[���n(���F����)]
		  ,[�ӫ~�ƶq]
		  ,[�l���ϸ�]
		  ,[�X�f���O]
		  ,[�O�_�����q�q��]
		  ,[�Ͻs]
		  ,[�ϦW]
		  ,[����]
	FROM [dbo].[201905]
)

SELECT * 
INTO #Orders
FROM Delivery_201905_201906

--Delete�@�����R(�i�H�z��n�R�������)�ATruncate�O��iTable�@���R��(���i�H�z��n�R�������)
TRUNCATE TABLE Filtered

--��X�q��s���O�˳f��w�O IN 9 10 �� �X�f���O IN (�j�� ���~...) �� ��֮ɬq��[�¦W��]
; WITH black_list AS (
	SELECT DISTINCT [�q��s��]
	FROM #Orders
	WHERE [�z�f��w�O] IN (9, 10)
	OR ([�X�f���O] LIKE '%�w��%' OR 
		[�X�f���O] LIKE '%�W�j%' OR
		[�X�f���O] LIKE '%�j��%' OR
		[�X�f���O] LIKE '%���~%')
	OR DATEPART(HOUR, [�q��ɶ�]) NOT IN (5,6,7,8,9,10,11,22,23)
), filtered_orders AS (
	SELECT *
	FROM #Orders
	WHERE [�q��s��] NOT IN (SELECT [�q��s��] FROM black_list)
)

INSERT INTO Filtered
SELECT *
FROM filtered_orders

END