### SQLite Table Schema Extraction Query
Overview
This query is designed to extract and display the schema details of all user-defined tables in an SQLite database. By running this query, you can efficiently list all table names, their associated column names, and each column's data type in the database.

This is particularly useful for database analysis, schema validation, and exploring table structures when working with SQLite databases.

Query Explanation

⌄
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

    
### Key Components of the Query
sqlite_master Table :
SQLite's system table contains metadata about all database objects like tables, views, and indexes.
The query uses this table to retrieve all table names.
PRAGMA Statement :
pragma_table_info(m.name): Returns details of columns (name, type, constraints, etc.) for a given table.
This is invoked dynamically for each table retrieved from sqlite_master.
WHERE Clause :
Filters only objects of type 'table', ensuring the query focuses solely on user-defined tables.
ORDER BY :
The output is sorted alphabetically by TableName and in schema-defined order (p.cid) for column definitions.
Output
The query returns the following columns:


### How to Use
Connect to SQLite : Open your SQLite database using a database management tool (e.g., DBeaver, SQLite CLI, or DB Browser for SQLite).
Run the Query : Copy and execute the query in the SQL querying interface.
Analyze the Data : Review the tabular output, which lists the schema details for all tables in the database.
Use Cases
Database Exploration : Quickly understand the structure of an SQLite database.
Schema Validation : Verify table structures during database development or migration.
Metadata Analysis : Analyze columns and their data types for creating reports or debugging.
Customizations
To tailor the query to include additional metadata, consider adding:

Primary Key Information : Add p.pk from pragma_table_info().
Nullable Columns : Include p.notnull for nullability status.
Example:

``` bash
SELECT
    m.name AS TableName,
    p.name AS ColumnName,
    p.type AS DataType,
    p.pk AS IsPrimaryKey,
    p.notnull AS IsNotNull
FROM
    sqlite_master m
JOIN
    pragma_table_info(m.name) p
WHERE
    m.type = 'table'
ORDER BY
    TableName, p.cid;
```
    
### Author
This snippet was developed to simplify schema analysis in SQLite databases. Contributions and suggestions are welcome. Feel free to adapt this query to suit your needs.

This README provides users with a clear understanding of your query, its purpose, and how to use it effectively. If you have additional requirements or examples, feel free to let me know!
