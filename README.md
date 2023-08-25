

# Test 

--SELECT dbo.typeId_CreateFromUuid('test', dbo.typeId_NewIdv7())

CREATE TABLE test (
    id VARCHAR(90) NOT NULL DEFAULT dbo.typeId_NewTypeId('test'),
    label VARCHAR(100)
)
GO
INSERT INTO test (label) VALUES ('new label')
GO
SELECT * FROM test
GO
