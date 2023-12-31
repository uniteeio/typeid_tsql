IF EXISTS (
        SELECT *
        FROM sys.objects
        WHERE object_id = OBJECT_ID(N'[dbo].[typeId_IntToBinary]')
        )
    DROP FUNCTION [dbo].[typeId_IntToBinary]
GO
CREATE FUNCTION dbo.typeId_IntToBinary (@num INT)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @binaryStr VARCHAR(32)
    SET @binaryStr = ''

    WHILE @num > 0
    BEGIN
        SET @binaryStr = CAST(@num % 2 AS VARCHAR) + @binaryStr
        SET @num = @num / 2
    END

    IF @binaryStr = ''
        RETURN '0'
    RETURN @binaryStr
END
