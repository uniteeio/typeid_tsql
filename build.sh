#!/bin/bash
cat sql/views/typeId_UuidV7Data.sql > typeid_tsql.generated.sql
echo "GO" >> typeid_tsql.generated.sql

cat sql/functions/typeId_BinaryToHex.sql >> typeid_tsql.generated.sql
echo "GO" >> typeid_tsql.generated.sql

cat sql/functions/typeId_HexToBinary.sql >> typeid_tsql.generated.sql
echo "GO" >> typeid_tsql.generated.sql

cat sql/functions/typeId_BinaryToInt.sql >> typeid_tsql.generated.sql
echo "GO" >> typeid_tsql.generated.sql

cat sql/functions/typeId_IntToBinary.sql >> typeid_tsql.generated.sql
echo "GO" >> typeid_tsql.generated.sql

cat sql/functions/typeId_NewIdv7.sql >> typeid_tsql.generated.sql
echo "GO" >> typeid_tsql.generated.sql

cat sql/functions/typeId_ToBase32.sql >> typeid_tsql.generated.sql
echo "GO" >> typeid_tsql.generated.sql

cat sql/functions/typeId_FromBase32.sql >> typeid_tsql.generated.sql
echo "GO" >> typeid_tsql.generated.sql

cat sql/functions/typeId_Encode.sql >> typeid_tsql.generated.sql
echo "GO" >> typeid_tsql.generated.sql

cat sql/functions/typeId_DecodeBinary.sql >> typeid_tsql.generated.sql
echo "GO" >> typeid_tsql.generated.sql

cat sql/functions/typeId_Decode.sql >> typeid_tsql.generated.sql
echo "GO" >> typeid_tsql.generated.sql

cat sql/functions/typeId_DecodeDate.sql >> typeid_tsql.generated.sql
echo "GO" >> typeid_tsql.generated.sql

cat sql/functions/typeId_NewTypeId.sql >> typeid_tsql.generated.sql
echo "GO" >> typeid_tsql.generated.sql

