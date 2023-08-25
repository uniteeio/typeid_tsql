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
    -- Converting to binary 
    DECLARE @binaryString VARCHAR(128)
    SET @binaryString = dbo.typeId_DecodeBinary(@typeid)


    IF (@binaryString = '')
        RETURN '' 

    -- Conversion to hexadecimal getting a 32 chars value
    DECLARE @Hexa VARCHAR(50) 
    SET @Hexa = dbo.typeId_BinaryToHex(@binaryString)

    -- Inserting decorating hyphens
    SET @Hexa = LEFT(@Hexa, 8) + '-' + SUBSTRING(@Hexa, 9, 4) + '-' + SUBSTRING(@Hexa, 13, 4) + '-' + SUBSTRING(@Hexa, 17, 4)
    + '-' + SUBSTRING(@Hexa, 21, LEN(@Hexa))

    RETURN @Hexa
END
GO
