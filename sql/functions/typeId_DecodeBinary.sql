IF EXISTS (
        SELECT *
        FROM sys.objects
        WHERE object_id = OBJECT_ID(N'[dbo].[typeId_DecodeBinary]')
        )
    DROP FUNCTION [dbo].[typeId_DecodeBinary]
GO
CREATE FUNCTION typeId_DecodeBinary(@typeid VARCHAR(90)) RETURNS VARCHAR(128)
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
   
    RETURN @binaryString
END
GO
