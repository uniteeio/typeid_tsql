IF EXISTS (
        SELECT *
        FROM sys.objects
        WHERE object_id = OBJECT_ID(N'[dbo].[typeId_BinaryToHex]')
        )
    DROP FUNCTION [dbo].[typeId_BinaryToHex]
GO
CREATE FUNCTION dbo.typeId_BinaryToHex (@binaryString VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @len INT
    DECLARE @i INT
    DECLARE @hexString VARCHAR(MAX)
    DECLARE @subString CHAR(4)
    DECLARE @decimalValue INT

    SET @len = LEN(@binaryString)
    SET @i = 1
    SET @hexString = ''

    -- Check if the binary string length is divisible by 4
    IF @len % 4 <> 0 SET @binaryString = RIGHT(REPLICATE('0', 4 - @len % 4) + @binaryString, @len + 4 - @len % 4)

    -- Reset the binary string length
    SET @len = LEN(@binaryString)

    WHILE (@i <= @len)
    BEGIN
        -- Take 4 bits (one hex character)
        SET @subString = SUBSTRING(@binaryString, @i, 4)
        
        -- Convert 4 bits to decimal value
        SET @decimalValue = 
            CAST(SUBSTRING(@subString, 4, 1) AS INT) * 1 +
            CAST(SUBSTRING(@subString, 3, 1) AS INT) * 2 +
            CAST(SUBSTRING(@subString, 2, 1) AS INT) * 4 +
            CAST(SUBSTRING(@subString, 1, 1) AS INT) * 8

        -- Convert decimal value to hex character
        SET @hexString = @hexString + 
            CASE 
                WHEN @decimalValue <= 9 THEN CHAR(@decimalValue + 48)
                ELSE CHAR(@decimalValue - 10 + 65)
            END
        
        SET @i = @i + 4
    END

    RETURN @hexString
END
