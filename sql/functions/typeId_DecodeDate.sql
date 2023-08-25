IF EXISTS (
        SELECT *
        FROM sys.objects
        WHERE object_id = OBJECT_ID(N'[dbo].[typeId_DecodeDate]')
        )
    DROP FUNCTION [dbo].[typeId_DecodeDate]
GO
CREATE FUNCTION typeId_DecodeDate(@typeid VARCHAR(90)) RETURNS DATETIME2
AS
BEGIN

    DECLARE @uuidBinary VARCHAR(128) = dbo.typeId_DecodeBinary(@typeid)

    DECLARE @secondsBinary VARCHAR(36) = LEFT(@uuidBinary, 36)
    DECLARE @seconds INT = dbo.typeId_BinaryToInt(@secondsBinary)

    DECLARE @result DATETIME2 = DATEADD(ss, @seconds, CONVERT(datetime, '01/01/1970' ))

    DECLARE @milliSecondsBinary VARCHAR(10) = SUBSTRING(@uuidBinary, 36, 10)
    DECLARE @milliSeconds INT = dbo.typeId_BinaryToInt(@milliSecondsBinary)

    SET @result = DATEADD(ms, @milliSeconds, @result)
    RETURN @result
END
GO
