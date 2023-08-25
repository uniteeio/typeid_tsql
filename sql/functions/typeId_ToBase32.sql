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
    DECLARE @endIndex INT = 5 -- 5 bits à la fois
    DECLARE @currentBits VARCHAR(5)
    DECLARE @currentBitsValue INT
    DECLARE @len INT = LEN(@binaryString)

    WHILE @startIndex <= @len
    BEGIN
        -- Extraire 5 bits à partir de la chaîne binaire
        SET @currentBits = SUBSTRING(@binaryString, @startIndex, @endIndex)

        -- Convertir ces 5 bits en décimal
        DECLARE @decimalValue INT = 0
        SET @decimalValue = dbo.typeId_BinaryToInt(@currentBits)

        -- Utiliser la valeur décimale pour trouver le caractère correspondant dans le dictionnaire
        SET @result = @result + SUBSTRING(@dict, @decimalValue + 1, 1)

        -- Mettre à jour les indices de début et de fin pour la prochaine itération
        SET @startIndex = @startIndex + 5
        SET @endIndex = @endIndex + 5
    END

    RETURN @result
END
