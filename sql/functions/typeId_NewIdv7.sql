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
