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
