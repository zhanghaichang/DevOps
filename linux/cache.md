## 清理缓存


`free -m` 看到buff/cache占用的内存非常大，这个时候可以使用一下命令去清除一下cache内存
```
echo 1 > /proc/sys/vm/drop_caches
echo 2 > /proc/sys/vm/drop_caches
echo 3 > /proc/sys/vm/drop_caches
```
