# intro to psql

This is an intro to psql class, and the file intro-psql.sql is a collection of query exercises for the psql dialect database.

**PostgreSQL** (often called psql when referring to its command-line interface) is a powerful, open-source relational database management system (RDBMS) that
extends the SQL language with many features, including:

•	Support for complex queries.
•	Full ACID compliance (Atomicity, Consistency, Isolation, Durability).
•	Extensive support for transactions.
•	Advanced indexing techniques (B-tree, Hash, GIN, GiST, etc.).
•	Support for JSON and JSONB for handling semi-structured data.
•	Extensions for full-text search, geospatial data, and more.
•	Multi-version concurrency control (MVCC) for handling simultaneous transactions.

## PSQL documentation

[PSQL DOCS](https://www.postgresql.org/docs/current/app-psql.html)

## Big O notation of the SQL (PSQL)

| **Operation**                  | **Index Type** | **Time Complexity** | **Description**                                                                |
| ------------------------------ | -------------- | ------------------- | ------------------------------------------------------------------------------ |
| **Sequential Scan**            | None           | O(n)                | Scans every row in the table for matches. Time grows linearly with table size. |
| **Equality Lookup**            | B-tree         | O(log n)            | B-tree indexes are used for equality and range queries (`=` or `BETWEEN`).     |
| **Equality Lookup**            | Hash Index     | O(1)                | Hash indexes provide constant-time lookups but only work for equality queries. |
| **Range Query**                | B-tree         | O(log n + m)        | Uses a B-tree index; `m` is the number of rows in the result set.              |
| **Primary Key Lookup**         | B-tree         | O(log n)            | PostgreSQL automatically creates a B-tree index for primary keys.              |
| **Join - Nested Loop**         | None/Index     | O(n \* m)           | Compares each row in one table with every row in another table.                |
| **Join - Hash Join**           | Hash Table     | O(n + m)            | Uses a hash table for one table and looks up rows from the other table.        |
| **Join - Merge Join**          | Sorted Input   | O(n + m)            | Efficient for sorted data, but sorting may add overhead.                       |
| **Aggregation**                | None/Index     | O(n)                | Aggregations scan the data. Indexes can improve performance.                   |
| **Full-Text Search**           | GIN            | O(log n)            | GIN indexes are used for full-text search and complex data types.              |
| **Caching (Repeated Queries)** | Cached Data    | O(1)                | If data is cached in memory, subsequent lookups can be almost instant.         |

## Order of exection of query commands SQL (PSQL)

| **Order** | **Clause**     | **Description**                                                          |
| --------- | -------------- | ------------------------------------------------------------------------ |
| 1         | `FROM`         | Retrieves the table(s) and applies any JOIN operations.                  |
| 2         | `WHERE`        | Filters rows based on conditions.                                        |
| 3         | `GROUP BY`     | Groups rows based on one or more columns for aggregation.                |
| 4         | `HAVING`       | Filters groups based on conditions (applies after aggregation).          |
| 5         | `SELECT`       | Selects the columns to return, applies functions and expressions.        |
| 6         | `DISTINCT`     | Removes duplicate rows from the result set.                              |
| 7         | `ORDER BY`     | Sorts the result set based on specified columns.                         |
| 8         | `LIMIT/OFFSET` | Limits the number of rows returned and skips a specified number of rows. |
