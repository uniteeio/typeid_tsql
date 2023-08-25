IF EXISTS (
        SELECT *
        FROM sys.objects
        WHERE object_id = OBJECT_ID(N'[dbo].[typeId_ToBase32]')
        )
    DROP FUNCTION [dbo].[typeId_ToBase32]
GO

CREATE FUNCTION dbo.typeId_ToBase32 (
    @binaryString VARCHAR(130)
)
RETURNS VARCHAR(26)
AS
BEGIN
    DECLARE @result VARCHAR(90) = ''
    DECLARE @dict VARCHAR(32) = '0123456789abcdefghjkmnpqrstvwxyz'
    DECLARE @startIndex INT = 1
    DECLARE @endIndex INT = 5 -- 5 bits iterations
    DECLARE @currentBits VARCHAR(5)
    DECLARE @currentBitsValue INT
    DECLARE @len INT = LEN(@binaryString)

    WHILE @startIndex <= @len
    BEGIN
        -- Get 5 bits from the binary string
        SET @currentBits = SUBSTRING(@binaryString, @startIndex, @endIndex)

        -- Convert these 5 bits to decimal
        DECLARE @decimalValue INT = 0
        SET @decimalValue = dbo.typeId_BinaryToInt(@currentBits)

        -- Use the decimal value to find the corresponding character in the dictionary
        SET @result = @result + SUBSTRING(@dict, @decimalValue + 1, 1)

        -- Switch to the next 5 bits
        SET @startIndex = @startIndex + 5
        SET @endIndex = @endIndex + 5
    END

    RETURN @result
END
