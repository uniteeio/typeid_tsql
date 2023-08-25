IF EXISTS (
        SELECT *
        FROM sys.objects
        WHERE object_id = OBJECT_ID(N'[dbo].[typeId_HexToBinary]')
        )
    DROP FUNCTION [dbo].[typeId_HexToBinary]
GO
CREATE FUNCTION dbo.typeId_HexToBinary (@hexString VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @len INT
    DECLARE @i INT
    DECLARE @binaryString VARCHAR(MAX)
    DECLARE @hexChar CHAR(1)
    DECLARE @decimalValue INT

    -- Clean up the hex string from hyphens
    SET @hexString = REPLACE(@hexString, '-', '')
    
    SET @len = LEN(@hexString)
    SET @i = 1
    SET @binaryString = ''

    WHILE (@i <= @len)
    BEGIN
        -- Take next hex character
        SET @hexChar = SUBSTRING(@hexString, @i, 1)
        
        -- Convert hex character to decimal value
        SET @decimalValue = 
            CASE 
                WHEN @hexChar BETWEEN '0' AND '9' THEN ASCII(@hexChar) - 48
                WHEN @hexChar BETWEEN 'A' AND 'F' THEN ASCII(@hexChar) - 65 + 10
                WHEN @hexChar BETWEEN 'a' AND 'f' THEN ASCII(@hexChar) - 97 + 10
                ELSE NULL
            END

        -- Convert decimal value to binary string
        SET @binaryString = @binaryString +
            CAST((@decimalValue / 8) % 2 AS CHAR(1)) +
            CAST((@decimalValue / 4) % 2 AS CHAR(1)) +
            CAST((@decimalValue / 2) % 2 AS CHAR(1)) +
            CAST((@decimalValue / 1) % 2 AS CHAR(1))

        SET @i = @i + 1
    END

    RETURN @binaryString
END
