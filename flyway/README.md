# Docker Flyway

Linux
```shell
docker run --rm -v $(pwd):/flyway/sql dhoer/flyway:alpine -url=jdbc:mysql://mydb -schemas=myschema -user=root -password=P@ssw0rd migrate

```
