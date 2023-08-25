# TypeId T-SQL (SQL Server)

[TypeId](https://github.com/jetpack-io/typeid) implementation in pure T-SQL.

## Install / Generate

Directly run the content of [typeid_tsql](https://github.com/uniteeio/typeid_tsql/blob/main/typeid_tsql.generated.sql) on
your server.

Regenerate the SQL by yourself using the script `./build.sh`

## Usage

```sql
CREATE TABLE MyTable (
    Id VARCHAR(90) NOT NULL DEFAULT dbo.typeId_NewTypeId('test'),
    Label VARCHAR(100)
)
GO

INSERT INTO MyTable (Label) VALUES ('new label')
GO

SELECT * FROM MyTable
GO
```

| Id                                 | Label         |
|----------------------------------- | ------------- |
| test_069t2trynchwpq50001pqtwnpy    | new label     |

## Caveat

It's not possible to generate a sub-millisecond timestamp in T-SQL. Thus, we generated the timestamp using a millisecond unix timestamp combined with
random data. That means that two typeid generated in the same millisecond won't be k-sortable.

I believe that it would be possible to combine the timestamp with a number coming from a [Sequence](https://learn.microsoft.com/fr-fr/sql/t-sql/statements/create-sequence-transact-sql?view=sql-server-ver16) to preserve the sequentiality and concurrency.
