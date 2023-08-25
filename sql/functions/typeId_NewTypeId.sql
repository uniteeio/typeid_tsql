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
