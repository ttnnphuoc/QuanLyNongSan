
Create PROCEDURE [dbo].[sp_FindStringInTable] @stringToFind NVARCHAR(Max), @schema sysname, @table sysname 
AS

BEGIN TRY
   DECLARE @sqlCommand NVARCHAR(max) = 'SELECT * FROM [' + @schema + '].[' + @table + '] WHERE ' 

   SELECT @sqlCommand = @sqlCommand + '[' + COLUMN_NAME + '] LIKE N''%' + @stringToFind+ '%'' OR '
   FROM INFORMATION_SCHEMA.COLUMNS 
   WHERE TABLE_SCHEMA = @schema
   AND TABLE_NAME = @table 
   --AND DATA_TYPE IN ('char','nchar','ntext','nvarchar','text','varchar')

   SET @sqlCommand = left(@sqlCommand,len(@sqlCommand)-3)
   EXEC (@sqlCommand)
  print @stringToFind
  print @sqlCommand
END TRY

BEGIN CATCH 
   PRINT 'There was an error. Check to make sure object exists.'
   PRINT error_message()
END CATCH 