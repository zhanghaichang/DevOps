# mysql 


### 随机查询

```sql
SELECT * FROM table1 WHERE id=(SELECT id FROM table1 ORDER BY rand() LIMIT 1)
```
