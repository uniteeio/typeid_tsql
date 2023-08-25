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

