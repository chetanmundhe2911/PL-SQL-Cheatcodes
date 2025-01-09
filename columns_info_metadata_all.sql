--DO not change anything in below query just run it as it is

SELECT 
    m.name AS TableName,
    p.name AS ColumnName,
    p.type AS DataType
FROM 
    sqlite_master m
JOIN 
    pragma_table_info(m.name) p
WHERE 
    m.type = 'table'
ORDER BY 
    TableName, p.cid;
