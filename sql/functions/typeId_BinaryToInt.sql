IF EXISTS (
        SELECT *
        FROM sys.objects
        WHERE object_id = OBJECT_ID(N'[dbo].[typeId_BinaryToInt]')
        )
    DROP FUNCTION [dbo].[typeId_BinaryToInt]
GO
CREATE FUNCTION dbo.typeId_BinaryToInt (@binaryStr VARCHAR(256))
RETURNS BIGINT
AS
BEGIN
     WHILE LEFT(@binaryStr, 1) = '0'
    BEGIN
        SET @binaryStr = SUBSTRING(@binaryStr, 2, LEN(@binaryStr))
    END

    DECLARE @len INT
    DECLARE @decValue BIGINT
    DECLARE @power INT

    SET @len = LEN(@binaryStr)
    SET @decValue = 0
    SET @power = 0

    WHILE @len > 0
    BEGIN
        -- Get the rightmost bit
        DECLARE @bit CHAR(1) = SUBSTRING(@binaryStr, @len, 1)
        -- Add its value to the result value
        SET @decValue = @decValue + CONVERT(BIGINT, CAST(@bit AS SMALLINT) * CONVERT(bigint, POWER(2, @power)))
        
        -- Switch to the next bit
        SET @power = @power + 1
        SET @len = @len - 1
    END

    RETURN @decValue
END
