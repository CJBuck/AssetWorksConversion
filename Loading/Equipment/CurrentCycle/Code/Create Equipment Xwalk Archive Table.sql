--
BEGIN
	DECLARE
		@EquipTableName VARCHAR(100),
		@DropSql		VARCHAR(MAX),
		@CreateSql		VARCHAR(MAX)

	-- Build the new table name.
	SET @EquipTableName = 'dbo.TransformEquipmentLegacyXwalk_' + 
		CAST(DATEPART(YEAR, GETDATE()) AS VARCHAR) + RIGHT('000' + CAST(DATEPART(MONTH, GETDATE()) AS VARCHAR), 2) +
		RIGHT('000' + CAST(DATEPART(DAY, GETDATE()) AS VARCHAR), 2)

	-- Drop SQL
	SET @DropSql = 'IF OBJECT_ID(''' + @EquipTableName + ''') IS NOT NULL DROP TABLE ' + @EquipTableName

	-- Execute the drop SQL
	EXEC(@DropSql)
	
	-- Create/Copy SQL
	SET @CreateSql = 'SELECT * INTO ' + @EquipTableName + ' FROM TransformEquipmentLegacyXwalk'
	
	-- Execute the copy SQL.
	EXEC(@CreateSql)
END
