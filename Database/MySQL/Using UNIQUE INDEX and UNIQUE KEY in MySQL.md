## Using UNIQUE INDEX and UNIQUE KEY in MySQL

In MySQL, `UNIQUE INDEX` and `UNIQUE KEY` are used to enforce uniqueness on one or more columns. They ensure that duplicate values cannot be inserted and also help improve query performance.

### Key Points

- Prevents duplicate values in the indexed column(s)
- Improves SELECT, JOIN, and ORDER BY performance
- Can be applied to a single column or multiple columns (composite index)

### Syntax Examples

**1. Create table with UNIQUE KEY**
```sql
CREATE TABLE users (
    id INT PRIMARY KEY,
    email VARCHAR(255),
    UNIQUE KEY uniq_email (email)
);
````

**2. Add UNIQUE INDEX to existing table**

```sql
ALTER TABLE users ADD UNIQUE INDEX uniq_username (username);
```

**3. Composite UNIQUE KEY**

```sql
ALTER TABLE orders ADD UNIQUE KEY uniq_order (user_id, product_id);
```

This prevents the same user from ordering the same product more than once.

### Notes

* `UNIQUE INDEX` and `UNIQUE KEY` are functionally the same in MySQL
* Attempting to insert duplicate values will return an error
* Most MySQL engines allow one NULL value in a UNIQUE column

Use UNIQUE indexes when you need both performance and data integrity on fields that must remain unique, such as email, username, or column combinations like (user\_id, product\_id).
