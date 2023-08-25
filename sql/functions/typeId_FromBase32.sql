IF EXISTS (
        SELECT *
        FROM sys.objects
        WHERE object_id = OBJECT_ID(N'[dbo].[typeId_FromBase32]')
        )
    DROP FUNCTION [dbo].[typeId_FromBase32]
GO

CREATE FUNCTION dbo.typeId_FromBase32 (
    @customBaseString VARCHAR(26)
)
RETURNS VARCHAR(230) -- 26 caractères x 5 bits = 130 bits
AS
BEGIN
    DECLARE @result VARCHAR(230) = ''
    DECLARE @dict VARCHAR(32) = '0123456789abcdefghjkmnpqrstvwxyz'
    DECLARE @len INT = LEN(@customBaseString)
    DECLARE @i INT = 1
    DECLARE @currentChar CHAR(1)
    DECLARE @currentCharIndex INT
    DECLARE @binaryValue VARCHAR(5)
    
    WHILE @i <= @len
    BEGIN
        -- Get the current character
        SET @currentChar = SUBSTRING(@customBaseString, @i, 1)

        -- Find its index in the dictionary
        SET @currentCharIndex = CHARINDEX(@currentChar, @dict) - 1

        -- Convert this index to binary
        SET @binaryValue = dbo.typeId_IntToBinary(@currentCharIndex)

        -- Add leading zeros if necessary and concatenate the result
        SET @result = @result + RIGHT(REPLICATE('0', 5) + @binaryValue, 5)

        -- Switch to the next character
        SET @i = @i + 1
    END

    RETURN @result
END
