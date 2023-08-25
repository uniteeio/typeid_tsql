IF EXISTS (
        SELECT *
        FROM sys.objects
        WHERE object_id = OBJECT_ID(N'[dbo].[typeId_UuidV7Data]')
        )
    DROP VIEW [dbo].[typeId_UuidV7Data]
GO
CREATE VIEW typeId_UuidV7Data AS 
SELECT 
    GETDATE() AS CurrentDate, 
    CONVERT(bigint, RAND() * POWER(2,13)) AS Random1, 
    CONVERT(bigint, RAND() * POWER(2,23)) AS Random2, 
    CONVERT(bigint, RAND() * POWER(2,30)) AS Random3

GO
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
GO
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
GO
IF EXISTS (
        SELECT *
        FROM sys.objects
        WHERE object_id = OBJECT_ID(N'[dbo].[typeId_BinaryToInt]')
        )
    DROP FUNCTION [dbo].[typeId_BinaryToInt]
GO
CREATE FUNCTION dbo.typeId_BinaryToInt (@binaryStr VARCHAR(32))
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
GO
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
GO
IF EXISTS (
        SELECT *
        FROM sys.objects
        WHERE object_id = OBJECT_ID(N'[dbo].[typeId_NewIdv7]')
        )
    DROP FUNCTION [dbo].[typeId_NewIdv7]
GO

CREATE FUNCTION typeId_NewIdv7 ()
RETURNS NVARCHAR(36)
AS
BEGIN
    DECLARE @uuid AS NVARCHAR(36)
    DECLARE @secondsPart VARCHAR(36)
    DECLARE @nanoSecondsPart VARCHAR(24)
    DECLARE @seqPart VARCHAR(14)
    DECLARE @randomPart VARCHAR(48)

    DECLARE @versionAndVariantBits VARCHAR(6)

    DECLARE @currentTime DATETIME
    DECLARE @random1 BIGINT, @random2 BIGINT, @random3 BIGINT

    -- Getting forbidden functions values from a vue
    SELECT @currentTime = CurrentDate, @random1 = Random1, @random2 = Random2, @random3 = Random3
    FROM typeId_UuidV7Data

    -- Number of seconds since 01/01/1970 on 36 bits
    SET @secondsPart = RIGHT(REPLICATE('0',36) + dbo.typeId_IntToBinary(DATEDIFF(SECOND, '19700101', @currentTime)) , 36)

    SET @nanoSecondsPart = 
        -- Milliseconds (max precision from datetime) are using first 10 bits (up to 1024)
        RIGHT(REPLICATE('0', 10) + dbo.typeId_IntToBinary(DATEPART(MILLISECOND, @currentTime)), 10) + 
        -- Then we use a random number simulating 50ns precision
        -- We'll get quasi unicity but not guaranted sequentiality
        RIGHT(REPLICATE('0', 14) + dbo.typeId_IntToBinary(@random1), 14)
    
    -- Sequence part - Randomized
    SET @seqPart = RIGHT(REPLICATE('0', 14) + dbo.typeId_IntToBinary(@random2), 14)

    -- Random part
    SET @randomPart = RIGHT(REPLICATE('0', 48) + dbo.typeId_IntToBinary(@random3), 48)

    -- Version and variant (7.2)
    SET @versionAndVariantBits = '011110'


    DECLARE @AllParts VARCHAR(128)
    -- We must have 128 bits (36 + 24 + 14 + 48 + 6)
    SET @AllParts = @secondsPart + @nanoSecondsPart + @seqPart + @randomPart + @versionAndVariantBits

    -- Conversion to hexadecimal getting a 32 chars value
    DECLARE @Hexa VARCHAR(50) 
    SET @Hexa = dbo.typeId_BinaryToHex(@secondsPart + @nanoSecondsPart + @seqPart + @randomPart + @versionAndVariantBits)

    -- Inserting decorating hyphens
    SET @Hexa = LEFT(@Hexa, 8) + '-' + SUBSTRING(@Hexa, 9, 4) + '-' + SUBSTRING(@Hexa, 13, 4) + '-' + SUBSTRING(@Hexa, 17, 4)
    + '-' + SUBSTRING(@Hexa, 21, LEN(@Hexa))

    RETURN @Hexa
END
GO
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
GO
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
GO
IF EXISTS (
        SELECT *
        FROM sys.objects
        WHERE object_id = OBJECT_ID(N'[dbo].[typeId_Encode]')
        )
    DROP FUNCTION [dbo].[typeId_Encode]
GO
CREATE FUNCTION typeId_Encode(@prefix VARCHAR(63), @uuid VARCHAR(36)) RETURNS VARCHAR(90)
AS
BEGIN
    RETURN LOWER(@prefix) + '_' + dbo.typeId_ToBase32('00' + dbo.typeId_HexToBinary(@uuid))
END
GO
GO
IF EXISTS (
        SELECT *
        FROM sys.objects
        WHERE object_id = OBJECT_ID(N'[dbo].[typeId_Decode]')
        )
    DROP FUNCTION [dbo].[typeId_Decode]
GO
CREATE FUNCTION typeId_Decode(@typeid VARCHAR(90)) RETURNS VARCHAR(36)
AS
BEGIN
    -- Checking suffix length - Must be 26
    DECLARE @suffixLength INT
    SET @suffixLength = CHARINDEX('_', REVERSE(@typeid)) - 1
    IF (@suffixLength <> 26)
        RETURN ''

    -- Getting suffix (last 26 chars)
    DECLARE @suffix VARCHAR(26)
    SET @suffix = RIGHT(@typeid, 26)

    -- Converting to binary and omitting the 2 trailing 0
    DECLARE @binaryString VARCHAR(130)
    SET @binaryString = RIGHT(dbo.typeId_FromBase32(@suffix), 128)
   
    -- Conversion to hexadecimal getting a 32 chars value
    DECLARE @Hexa VARCHAR(50) 
    SET @Hexa = dbo.typeId_BinaryToHex(@binaryString)

    -- Inserting decorating hyphens
    SET @Hexa = LEFT(@Hexa, 8) + '-' + SUBSTRING(@Hexa, 9, 4) + '-' + SUBSTRING(@Hexa, 13, 4) + '-' + SUBSTRING(@Hexa, 17, 4)
    + '-' + SUBSTRING(@Hexa, 21, LEN(@Hexa))

    RETURN @Hexa
END
GO
GO
IF EXISTS (
        SELECT *
        FROM sys.objects
        WHERE object_id = OBJECT_ID(N'[dbo].[typeId_NewTypeId]')
        )
    DROP FUNCTION [dbo].[typeId_NewTypeId]
GO
CREATE FUNCTION typeId_NewTypeId(@prefix VARCHAR(63)) RETURNS VARCHAR(90)
AS
BEGIN
    RETURN dbo.typeId_Encode(@prefix, dbo.typeId_NewIdv7())
END
GO
