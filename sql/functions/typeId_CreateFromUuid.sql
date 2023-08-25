IF EXISTS (
        SELECT *
        FROM sys.objects
        WHERE object_id = OBJECT_ID(N'[dbo].[typeId_CreateFromUuid]')
        )
    DROP FUNCTION [dbo].[typeId_CreateFromUuid]
GO
CREATE FUNCTION typeId_CreateFromUuid(@prefix VARCHAR(63), @uuid VARCHAR(36)) RETURNS VARCHAR(90)
AS
BEGIN
    RETURN LOWER(@prefix) + '_' + dbo.typeId_ToBase32('00' + dbo.typeId_HexToBinary(@uuid))
END
GO
