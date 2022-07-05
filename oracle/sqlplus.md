# 基本查询命令

## 查询排序

```sql
所有自然顺序不可控，需要用户自己操作
既然ORDER BY在SELECT后执行，那你就意味着order by可以使用select子句定义的别名
字段排序两种形式（任意数据类型上进行）
1，升序：ASC(默认)
2，降序：DESC

工资又高到底排序
select *
from emp
order by sal DESC;

雇用日期由早到晚
select *
from emp
oRder by hiredate ASC;

按照工资由高到低排序，如果工资相同则按照雇用日期由早到晚排序
select *
from emp
oRder by sal DESC,hiredate ASC;

查询出所有办事员的编号，职位，年薪，按照年薪由高到低排序
select empno,job,sal
from emp
where job='CLERK'
order by sal desc;

总结：select控制列
      where控制行
      order by最后执行
```

## 练习题

```sql
选择部门30中的所有员工
select DEPTNO
FROM EMP
WHERE DEPTNO=30;


列出所有办事员的姓名，编号和部门编号
SELECT ENAME,EMPNO,DEPTNO
FROM EMP
WHERE JOB='CLERK';

找出佣金(comm)高于薪金60%的员工
select*
from emp
where comm>sal*0.6; 

找出部门10中所有经理和部门20中所有办事员所有资料
select *
from emp
where (deptno=10 and job='MANAGER') or (deptno=20 and job='CLERK'); 



找出部门10中所有经理和部门20中所有办事员所,既不是经理又不是办事员
其薪金大于2000
select *
from emp
where (deptno=10 and job='MANAGER') or (deptno=20 and job='CLERK') 
or(job<>'MANAGER,CLERK' AND SAL>200);
或者是
select *
from emp
where (deptno=10 and job='MANAGER') or (deptno=20 and job='CLERK') or (job not in ('MANAGER','CLERK') AND SAL>2000);

找出收取佣金的员工的不同工作
SELECT DISTINCT job
FROM EMP
WHERE COMM IS NOT NULL;

找出不收取佣金或收取佣金低于100的员工。
SELECT ename
FROM EMP
WHERE COMM<100 OR COMM IS NULL;

显示员工名字不带有R的员工
select ENAME
FROM EMP
WHERE ENAME NOT LIKE '%R%';

显示名字字段任何位置包含A，基本工资按高到低排序，如果工资相同则由雇佣年限由早到晚排序如果雇用日期相同，则按照职位排序
SELECT ENAME
FROM EMP
WHERE ENAME LIKE '%A%'
ORDER BY SAL DESC,HIREDATE,JOB;
```

## 限定查询

```sql
限定查询
查询不是办事员的雇员
where job<>或！='CLERK'

查询不是办事员但是工资低于3000
select *
from emp
where job<>'CLERK' and sal<3000;

查询不是办事员也不是销售
select *
from emp
where job<>'CLERK' AND job<>'SALESMAN';

查询办事员或者工资低于1200的办事员
select *
from emp
where job='CLERK' or sal<1200;

查询工资小于等于2000
select *
from emp
where not sal>2000;

二，范围运算
查询1500-3000工资的雇员
select *
from emp
where sal between 1500 and 3000;

查询出在1981年的雇佣信息
select *
from emp
where hiredate between '01-JAN-81' and '30-DEC-81';

查询出所有领取佣金的雇员信息（comm字段是佣金），如果领取comm内容不是null
select *
from emp
where comm is not null;

IN操作（范围操作）

IN
查出雇员信息是/不是7369 7566 7788 9999
select *
from emp
where empno in/not in (7369,7566,7788,9999)；

NOT IN不能出现空（null） 

模糊查询:LIKE
要想使用like,必须使用如下符号：
“_”:匹配任意一位符号
“%”：匹配任意符号（包含0,1，多位）

例：查看以字母A开头的雇员信息
select *
from emp
where ename LIKE 'A%';

查询第二个字母是M的雇员
select *
from emp
where ename LIKE '_M%';

查询任意位置有A的雇员
select *
from emp
where ename LIKE '%A%';

使用LIKE没有设定任何关键字时执行所有
LIKE可以在任意数据类型上使用（原生支持）,但是往往在字符串上使用
大部分系统是此语句实现的，但不包括搜索引擎。
```

# 单行函数

## 在ORACLE中函数使用结构如下

返回值 函数名称（列 | 数据）
而根据函数的特点，单行函数可以分以下几点
1，字符串函数
2，数值函数
3，日期函数
4，转换函数
5，通用函数



## 数值函数

针对数字处理的函数，有三个主要函数
1.ROUND()
2.trunc()
3.mod()



1,四舍五入操作
  语法：数字 round（列 | 数字，[,保留小数位]）如果不设置表示不保留小数位

测试四舍五入
select
      round(78915.67823823),     78916    小数点后直接四舍五入
      round(78915.67823823,2) ,  78915,68 保留小数点后两位
      round(78915.67823823,-2) , 78900    把不足5的数据取消了
      round(78985.67823823,-2) , 79000    如果超过了五则进位
      round(-15.65)              -16     
from dual;


2，截取小数，不进位，抹去小数
   语法:数字 TRUNC(列 | 数字 [, 小数位])

select
      trunc(78915.67823823),       78915 
      trunc(78915.67823823,2) ,    78915.67 
      trunc(78915.67823823,-2) ,   78900
      trunc(78985.67823823,-2) ,   78900
      trunc(-15.65)                15   
from dual;

3，求余数（求模）
   语法：数字 mod（列1|数字1， 列2|数字2）
select mod（10,3）from dual;

输出结果：MOD(10,3)

## 日期函数（oracle自己特色）

伪列：select ename,hiredate,SYSDATE FROM EMP;


日期时间提供三种计算模式  
1.日期 + 数字 = 日期 （若干天之后的日期）；
2.日期 - 数字 = 日期 （若干天之前的日期）；
3.日期 - 数字 = 数字 （两个日期间的天数）；

```sql 
SELECT SYSDATE+10,SYSDATE+120,SYSDATE+9999 from dual;
输出结果：SYSDATE+1 SYSDATE+1 SYSDATE+9

--------- --------- ---------

​          26-DEC-16 15-APR-17 02-MAY-44

1，计算两个日期间所经历的月数总和
   语法:数字 MONTHS_BETWEEN(日期1，日期2)

计算每一位雇员到今天为止的雇佣总月数
SELECT ENAME,HIREDATE,MONTHS_BETWEEN(SYSDATE,HIREDATE)FROM EMP;

实际上，已经存在月的数据就表示已经可以计算年的数据了，因为不过任何
年都只有12个月

计算每一个雇员到今天为止雇佣的年年限
SELECT ENAME,HIREDATE,
TRUNC(MONTHS_BETWEEN(SYSDATE,HIREDATE)/12) YEARS FROM EMP;

2，增加若干月之后的日期：
   语法：日期 ADD_MONTHS（日期，月数）。
测试ADD_MONTHS(可避免闰年)
SELECT ADD_MONTHS(SYSDATE,4),ADD_MONTHS(SYSDATE,9999) FROM DUAL;


计算还差一年满35年雇用日期的全部雇员
SELECT * FROM EMP
WHERE TRUNC(MONTHS_BETWEEN(SYSDATE,HIREDATE)/12)=34;


3，计算指定日期所在月的最后一天
语法：日期 LAST_DAY(日期)


计算当期日期所在月的最后一天
SELECT LAST_DAY(SYSDATE) FROM DUAL;

查出所有雇佣所在月倒数第二天被雇佣的雇员信息
SELECT ENAME,HIREDATE,LAST_DAY(HIREDATE),LAST_DAY(HIREDATE)-2
FROM EMP
WHERE LAST_DAY(HIREDATE)-2=HIREDATE;

输出结果：ENAME      HIREDATE  LAST_DAY( LAST_DAY(
          ---------- --------- --------- ---------
          MARTIN     28-SEP-81 30-SEP-81 28-SEP-81


4，计算下一个指定的星期
   语法：日期 next_day(日期，一周时间数)。

计算下一个周二
SELECT NEXT_DAY(SYSDATE,'TUESDAY') FROM DUAL;



综合分析
查出雇员编号，姓名，雇用日期，以及每一位雇员到今天为止所被雇佣的
年数，月数，天数
```

```sql
SELECT EMPNO,ENAME,HIREDATE,
       TRUNC(MONTHS_BETWEEN(SYSDATE,HIREDATE)/12) YEAR,
       TRUNC(MOD(MONTHS_BETWEEN(SYSDATE,HIREDATE),12)) MONTHS,
       TRUNC(SYSDATE-ADD_MONTHS(HIREDATE,MONTHS_BETWEEN(SYSDATE,HIREDATE))) DAY
FROM EMP;
```

输出结果：

     EMPNO ENAME      HIREDATE        YEAR     MONTHS        DAY
---------- ---------- --------- ---------- ---------- ----------
```shell
  7369 SMITH      17-DEC-80         35         11         29
  7499 ALLEN      20-FEB-81         35          9         26
  7521 WARD       22-FEB-81         35          9         24
  7566 JONES      02-APR-81         35          8         14
  7654 MARTIN     28-SEP-81         35          2         18
  7698 BLAKE      01-MAY-81         35          7         15
  7782 CLARK      09-JUN-81         35          6          7
  7788 SCOTT      19-APR-87         29          7         27
  7839 KING       17-NOV-81         35          0         29
  7844 TURNER     08-SEP-81         35          3          8
  7876 ADAMS      23-MAY-87         29          6         23

 EMPNO ENAME      HIREDATE        YEAR     MONTHS        DAY
```
---------- ---------- --------- ---------- ---------- ----------
```shell
  7900 JAMES      03-DEC-81         35          0         13
  7902 FORD       03-DEC-81         35          0         13
  7934 MILLER     23-JAN-82         34         10         23
```
## 常用函数


![image-20210113094820859](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20210113094820859.png)

![image-20210113094829161](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20210113094829161.png)

![image-20210113094839106](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20210113094839106.png)

![image-20210113094844461](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20210113094844461.png)

![image-20210113094850864](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20210113094850864.png)

![image-20210113094855903](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20210113094855903.png)

![image-20210113094902876](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20210113094902876.png)

# 复杂函数

##  表的连接  


表的连接：两张表进行多表查询对于消除笛卡尔积主要是依靠连接模式来处理的，而对于表的连接模式在数据库上定义有两种
1内连接：利用WHERE语句消除笛卡尔积，只有满足条件的才会出现
2外连接：分为三种：左外连接，右外连接，全外连接
   为了更好的观察连接的区别，已经在DEPT表中提供了没有雇员的部门（40部门），我们在表中添加一个没有部门的雇员

 ```sql
INSERT INTO EMP (EMPNO,ENAME,DEPTNO) VALUES (8989,’HELLO’,null); 
当前EMP表内容如下 ：select * from emp；
内连接实现效果:	
SELECT E.EMPNO,E.ENAME,D.DEPTNO,D.DNAME
FROM EMP E,DEPT D
WHERE E.DEPTNO=D.DEPTNO（+）;
 ```

![image-20210113095114823](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20210113095114823.png)


没有雇员的部门和没有部门的顾源没有出现，因为NULL的判断不满足

```SQL
使用左（连接），所有雇员信息都显示出来，几遍没有对应部门
SELECT E.EMPNO,E.ENAME,D.DEPTNO,D.DNAME
FROM EMP E,DEPT D
WHERE E.DEPTNO=D.DEPTNO（+）;
此时没有部门的雇员出现了（左表的数据全部显示了）

右外连接，显示所有部门连接
SELECT E.EMPNO,E.ENAME,D.DEPTNO,D.DNAME
FROM EMP E,DEPT D
WHERE E.DEPTNO（+）=D.DEPTNO;  此时没有雇员的部门出现了
总结：内连接指的是所有满足关联条件的数据出现，不满足的不出现，外连接指定一张数据表中的数据全显示，但是没有对应的其他数据，内容为null。在oracle使用“（+）”来控制连接方式：
左外连接：关联字段1=关联字段2（+);
右外连接：关联字段1（+）=关联字段2;
大部分人只会考率内连接，当发现数据不全时，考虑外连接
```

## SQL:1999语法定义

```sql
对于数据表的连接操作，从实际使用来讲，我们各个数据库都是有所支持的，对于所有数据库进行表连接是利用以下语法完成：
SELECT * 
FROM 表1
       [CROSS JOIN 表2 [别名]]
       [NATURAL JOIN 表2 [别名]]
       [	JOIN 表2[别名] ON [	条件] | USING(关联字段)]
       [LEFT | RIGHT | FULL OUTER JOIN ON (条件）表2]；
个人在进行表连接时，如果是内连接一定使用等值判断
1，交叉连接：目的是产生笛卡尔积
SELECT * 
FROM 表1 [CROSS JOIN 表2 [别名]]
实现交叉连接
SELECT *
FROM EMP CROSS JOIN DEPT ;

2，自然连接；利用关联字段自己进行笛卡尔积的消除（只要字段名称相同自己匹配）
SELECT * 
FROM 表1 [NATURAL JOIN 表2 [别名]]
实现自然连接(内连接)
SELECT *
FROM EMP NATURAL JOIN DEPT ;

3，使用自然连接需要两张表关联字段相同，如果不同或者两张表中有两组字段都是重名
所以这种时候用ON子句指定关联条件，利用USING子句设置关联字段
领用USING设置关联字段，实现自然连接

4，外链接
SELECT * 
FROM 表1[LEFT | RIGHT | FULL OUTER  JOIN表2 ON (条件）]；

实现左外连接：
SELECT * FROM EMP E LEFT OUTER JOIN DEPT D ON (E.DEPTNO=D.DEPTNO);
实现右外连接;
SELECT * FROM EMP E RIGHT OUTER JOIN DEPT D ON (E.DEPTNO=D.DEPTNO);
全外连接
SELECT * FROM EMP E FULL OUTER JOIN DEPT D ON (E.DEPTNO=D.DEPTNO);

多表查询
COUNT()函数，主要功能统计一张数据表中的数据量
SELECT COUNT(*) FROM DEPT;  (4行)
SELECT COUNT(*) FROM EMP;  (14行)
	
SELECT * FROM EMP,DEPT;      (56行记录)

数据库的产生的原理 ————数学的集合。会将两个集合（数据表）统一查询，作为乘法形式出现，结果一定会产生积————笛卡尔积。我们需要去消除笛卡尔积，若果想要消除积必须要有关联字段。
EMP和DEPT数据表中存在DEPTNO
消除笛卡尔积：SELECT * FROM EMP,DEPT WHERE EMP.DEPTNO=DEPT.DEPTNO;
只要是多表查询，必须存在关联关系

多表查询中使用别名：
SELECT E.*,D.DNAME
FROM EMP E,DEPT D
WHERE E.DEPTNO=D.DEPTNO; 
数据量过大多表查询会直接带来严重的性能问题
程序算法慢，CPU占用率高。数据库数据大，内存占用率高。
```

## 多表查询案例

```sql
一，查询出每个雇员的编号，姓名，职位，基本工资，部门名称，部门位置
  答：1.确定要使用的数据表和已知的关联字段
   Emp和dept表
   Deptno为关联字段
   第一步查询每个雇员的编号，姓名，职位，基本工资
   SELECT E.EMPNO,E.ENAME,E.JOB,E.SAL
   FROM EMP E;
   2.查询出每个雇员对应部门的信息，需要引入dept表，引入时一定要考虑有关联，这两张表可以直接利用deptno关联和where消除笛卡尔积
   SELECT E.EMPNO,E.ENAME,E.JOB,E.SAL,D.DNAME,D.LOC   
   FROM EMP E,DEPT D
   WHERE E.DEPTNO=D.DEPTNO;

二，要求查询出每个雇员的编号，姓名，职位，基本工资，工资等级
   1.确定要使用的数据表和已知的关联字段
SELECT * FROM SALGRADE;  SELECT * FROM EMP;
   2.确定已知的关联字段
雇员与工资等级:EMP,SAL BETWEEN SALGRADE.LOSAL AND SALGRADE.HISAL;

    第一步

第一步查询每个雇员的编号，姓名，职位，基本工资
SELECT E.ENAME,E.JOB,E.SAL,E.EMPNO,E.EMPNO
第二步，增加SALGRADE表，引入where消除笛卡尔积
SELECT E.ENAME,E.JOB,E.SAL,,E.EMPNO,S.GRADE
FROM EMP E,SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL;

三，查询每个雇员的编号，姓名，职位，基本工资，部门名称，工资等级
SELECT E.ENAME,E.EMPNO,E.JOB,E.SAL,D.DNAME,S.GRADE
FROM EMP E,DEPT D,SALGRADE S
WHERE (E.DEPTNO=D.DEPTNO) AND (E.SAL BETWEEN S.LOSAL AND S.HISAL);
```

## 数据集合操作

每一次操作都返回数据集合，所以返回的结果上可以使用UNION,UNION ALL,MINUS,
INTSECT实现我们的结合操作
语法：

![image-20210113095543529](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20210113095543529.png)

UNION|UNION ALL|MINUS|INTSECT

![image-20210113095549090](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20210113095549090.png)

UNION|UNION ALL|MINUS|INTSECT

![image-20210113095554660](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20210113095554660.png)

```sql
UNION:取消多余重复元素
SELECT * FROM EMP
UNION
SELECT * FROM EMP WHERE DEPTNO=10;

UNINO ALL:显示重复元素
INTESECT:只显示重复元素
MINUS:取消重复元素
由于集合操作合并查询，所以要求若干个查询结果所返回的数据结构必须相同

错误操作：
SELECT ENAME,JOB FROMEMP
INTESECT
SELECT EMPNO,DEPTNO FROM EMP;
```

# 分组统计

## 多表查询和分组统计

```sql
对于GROUP BY 子句而言，实在WHERE之后进行，所以在使用时可以使用限定查询和多表查询
查询出每个部门的名称，部门人数，平均工资
SELECT COUNT(*),AVG(E.SAL/12),D.DNAME
FROM EMP E,DEPT D
WHERE E.DEPTNO(+)=D.DEPTNO
GROUP BY DNAME;

范例：查询出每个部门的编号，名称，位置，部门人数，平均工资
SELECT D.DEPTNO,D.DNAME,D.LOC,COUNT(*),AVG(E.SAL)
FROM EMP E,DEPT D
WHERE E.DEPTNO(+)=D.DEPTNO
GROUP BY D.DEPTNO,D.DNAME,D.LOC;
```

![image-20210113095643458](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20210113095643458.png)

## HAVING子句

![image-20210113095753021](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20210113095753021.png)

```sql
查询出每个职位的名称和平均工资，要求平均工资超过2000
错误代码：
SELECT JOB,AVG(SAL)
FROM EMP
WHERE AVG(SAL)>200
GROUP BY JOB;
WHERE子句上不允许出现统计函数（分组函数）。因为GROUP BY 子句实在WHERE子句之后执行的那么此时执行WHERE语句时还没有分组，自然就无法分组统计。所以这种情况下只能用HAVING子句
SELECT JOB,AVG(SAL)
FROM EMP
GROUP BY JOB;
HAVING AVG(SAL)>2000;
HAVING是GROUP BY之后执行的子句


关于WHERE和HAVING的区别
WHERE子句是在GROUP BY分组之前进行筛选，指的是选出那些可以参与分组的数据，并且WHERE子句不允许使用统计函数
HAVING子句是在GROUP BY 分组之后执行的，可以使用统计函数


分组案例
1，显示所有非销售的工作名称以及从事同一工作的雇员的月工资总和，并且要求从事同一工作雇员的工资合计大于5000，显示的结果按照月工资的合计的升序排列
1查询所有非销售的信息 2按照职位分组 3分组后的数据
SELECT JOB,SUM(SAL) SUM
FROM EMP
WHERE JOB<>’SALESMAN’
GROUP BY JOB
HAVING SUM(SAL)>5000
ORDER BY SUM;

2,统计所有销售人员和非销售的人数，平均工资
SELECT COUNT(*) , AVG(SAL)
FROM EMP
WHERE COMM IS NOT NULL
UNION
SELECT COUNT(*) ,AVG(SAL)
FROM EMP
WHERE COMM IS NULL;
```

## 子查询

```sql
子查询：所有可能出现的子查询都需要（）去声明。所谓子查询就是查询嵌套，查询子句任意位置上都可以出现子查询。
WHERE子句：子查询返回单行单列，单行多列，多行单列
HAVING子句：子查询返回单行单列，而且要使用统计函数过滤
FROM子句：子查询返回多行多列
SELECT子句：一般返回单行单列

WHERE子查询
1，子查询返回单行单列
范例：要求查询出公司工资最低的雇员信息
SELECT * FROM EMP
WHERE SAL=(SELECT MIN(SAL) FROM EMP);

查出雇佣最早的雇员
SELECT * FROM EMP
WHERE HIREDATE=(SELECT MIN(HIREDATE) FROM EMP);

2，子查询返回单行多列
查询出与SCOOT工资相同，职位相同的所有雇员信息
SELECT * FRO EMP
WHERE (SAL,JOB)=(SELECT SAL,JOB FROM EMP WHERE ENAME=’SCOTT’)
        AND ENAME<>’SCOTT’     

3，子查询返回多行单列
如果子查询返回多行单列，那么就告诉客户一个操作范围，做范围判断，在WHERE子句里有3个判断符：IN,ANY,ALL
1，IN操作：内容可以在指定范围中存在
查询出工资和MANAGER一样的职员
SELECT * FROM EMP
WHERE SAL
IN (SELECT SAL FROM EMP WHERE JOB=’MANAGER’);

NOT IN 查询时保证数据没有空

2 ，ANY 操作
=ANY
SELECT * FROM EMP
WHERE SAL = ANY (SELECT SAL FROM EMP WHERE JOB=’MANAGER’);
(此操作与IN没有区别)

>ANY
SELECT * FROM EMP
WHERE SAL > ANY (SELECT SAL FROM EMP WHERE JOB=’MANAGER’);
显示比子查询最小的内容要大

<ANY 显示比子查询最大的内容要小

3，ALL操作
>ALL：比子查询返回最大的值要大
<ALL：比子查询返回最小的值要小

4，exists（）
如果子查询有数据返回（所有数据）就表示条件满足，那么就可以显示出所有数据，否则什么都不显示
Exists操作
SELECT * FROM EMP
WHERE EXISTS(
SELECT * FROM EMP WHERE DEPTNO=99);
因为此时的子查询没有返回任何的数据行，所以exists（）认为数据不存在，外部查询就无法查询出内容

SELECT * FROM EMP
WHERE EXISTS(
SELECT * FROM EMP WHERE EMPNO=7839);
如果有数据返回就会看到

SELECT * FROM EMP
WHERE EXISTS(
SELECT *‘hello’ FROM DUAL WHERE 1=1);
EXISTS（）只关心子查询里返回是否有行，至于什么行，它不关心

使用NOTEXISTS()
SELECT * FROM EMP
WHERE NOT EXISTS(
SELECT *‘hello’ FROM DUAL WHERE 1=2);
EXISTS要比IN性能高，因为EXITS只认行，而IN认数据

HAVING子句使用子查询
使用HAVING子句就必须有GROUP BY子句

统计出所有高于平均工资的部门编号，平均工资，部门人数
SELECT DEPTNO,COUNT(*),AVG(SAL) FROM EMP 
GROUP BY DEPTNO;
HAVING AVG(SAL)>(SELECT AVG(SAL) FROM EMP)

在SELECT中使用子查询（意义不大，性能不高）
查询每个雇员的编号，姓名，职业，部门名称
SELECT E.EMP,E.ENAME,E.JOB,(SELECT DNAME D FROM DEPT D WHERE D.DEPTNO=E.DEPTNO)
FROM EMP E;
在SELECT里出现的子查询的主要目的是行列转变

在FROM子句中出现子查询
查询出每个部门的编号，名称，位置，部门人数，平均工资
SELECT D.DNAME,D,LOC,D.DEPTNO,COUNT(*),AVG(SAL)
FROM EMP E,DEPT D
WHERE E.DEPTNO(+)=D.DEPTNO
GROUP BY D.DEPTNO,D.DNAME,D.LOC;
除了以上这种方式，也可以使用子查询完成
SELECT DEPTNO,COUNT(EMPNO),AVG(SAL)
FROM EMP
GROUP BY DEPTNO;
此时返回的是多行多列，就一定可以在FROM子句中出现
SELECT D.DEPTNO,D.DNAME,D.LOC,TEMP.COUNT,TEMP.AVG
FROM DEPT D,(
SELECT DEPTNO,COUNT(EMPNO) COUNT,AVG(SAL) AVG
FROM EMP
GROUP BY DEPTNO) TEMP
WHERE D.DEPTNO=TEMP.DEPTNO（+）;

这两种方式的区别：子查询主要是为了解决多表查询性能问题而产生的
```

## 复杂查询案例

```sql
1，列出薪金高于在部门30工作的所有员工的薪金的员工姓名和薪金，部门名称，部门人数

确定要使用的数据表
EMP表：姓名和薪金
DEPT表：部门名称
EMP表：统计部门人数

确定已知存在关联
员工与部门：E.DEPTNO=d.deptno
第一步：找出30部门的所有薪金
SELECT SAL FROM EMP WHERE DEPTNO=30;
第二部：以上查询中返回的是多行单列，那么此时就可以使用三种判断符判断：IN,ANY,ALL
所有员工那么使用ALL
SELECT E.ENAME,E.SAL
FROM EMP E
WHERE E.SAL >ALL (SELECT SAL FROM EMP WHERE DEPTNO=30);
所有大于30部门薪金的雇员姓名和工资就出来了
第三步：找到部门的信息，在FROM子句之后引入DEPT表，然后消除笛卡尔积
SELECT E.ENAME,E.SAL,D.DNAME
FROM EMP E	,DEPT D
WHERE E.SAL >ALL (SELECT SAL FROM EMP WHERE DEPTNO=30)
        AND E.DEPTNO=D.DEPTNO;
第四步：统计部门人数
1，如果进行部门人数统计，一定要按照部门分组
2，使用分组时，SELECT子句只能出现分组字段和统计函数
此时出现矛盾，SELECT子句中有其他字段，所以不可能直接使用GROUP BY分组，所以可以考虑使用子查询分组，即：在FROM子句之后使用子查询先进行分组统计，而后用临时表进行多表查询操作
SELECT E.ENAME,E.SAL,D.DNAME,TEMP.COUNT
FROM EMP E	,DEPT D，（
SELECT DEPTNO DNO,COUNT(EMPNO) COUNT
FROM EMP
GROUP BY DEPTNO）TEMP
WHERE E.SAL >ALL (SELECT SAL FROM EMP WHERE DEPTNO=30)
        AND E.DEPTNO=D.DEPTNO AND D.DEPTNO=TEMP.DNO;
2,列出与’SCOTT’从事相同工作的所有员工及部门名称，部门人数，领导姓名
确定要使用的数据表
EMP:员工信息
DEPT：部门名称
EMP：领导信息
确定关联字段
雇员与部门：E.DEPTNO=D.DEPTNO
雇员与领导:E.MGR=MEMP.EMPNO

第一步：确定SCOOT工作
SELECT JOB FROM EMP WHERE ENAME=’SCOTT’;
第二部：返回的是单行单列，所以只能在WHERE和HAVING中使用
对所有部门进行筛选，然后消除重名
SELECT E.EMPNO,E.ENAME,E.JOB
FROM EMP
WHERE JOB=(SELECT JOB FROM EMP WHERE ENAME=’SCOTT’)
        AND E.ENAME<>’SCOTT’;
第三步：部门名称需要DEPT表
SELECT E.EMPNO,E.ENAME,E.JOB,D.DNAME
FROM EMP E,DEPT D
WHERE JOB=(SELECT JOB FROM EMP WHERE ENAME=’SCOTT’)
        AND E.ENAME<>’SCOTT’
        AND E.DEPTNO=D.DEPTNO;
第四步：此时不能直接使用GROUP BY分组，所以需要使用子查询进行分组
SELECT E.EMPNO,E.ENAME,E.JOB,D.DNAME,TEMP.COUNT
FROM EMP E,DEPT D，（
      SELECT DEPTNO DNO,COUNT(EMPNO) COUNT
      FROM EMP
GROUP BY DEPTNO) TEMP
WHERE JOB=(SELECT JOB FROM EMP WHERE ENAME=’SCOTT’)
        AND E.ENAME<>’SCOTT’
        AND E.DEPTNO=D.DEPTNO;
        AND D.DEPTNO=TEMP.DNO;
第五步：找到对应的领导信息，直接使用自身关联
SELECT E.EMPNO,E.ENAME,E.JOB,D.DNAME,TEMP.COUNT,M.ENAME
FROM EMP E,DEPT D，（
      SELECT DEPTNO DNO,COUNT(EMPNO) COUNT
      FROM EMP
GROUP BY DEPTNO) TEMP，EMP M
WHERE E.JOB=(SELECT JOB FROM EMP WHERE ENAME=’SCOTT’)
        AND E.ENAME<>’SCOTT’
        AND E.DEPTNO=D.DEPTNO;
        AND D.DEPTNO=TEMP.DNO;
        AND E.MGR=M.EMPNO
3，列出薪金比SMITH或ALLEN多的所有员工编号，姓名，部门名称，其领导姓名，部门人数，平均工资，最高及最低工资
确定要使用的数据表：
EMP表：员工编号，姓名
DEPT表：部门名称
EMP表：领导姓名
Empb表：统计信息
确定已知的关联字段：
Deptno mgr=empno
第一步：知道smith或allen，这个查询返回的是多行单列（where中使用）
SELECT SAL
FROM EMP
WHERE ENAME IN (‘SMITH’,’ALLEN’);
第二步：现在应该比里面的任意一个多，但是要抛出SMITH ALLEN，由于是多行单列，所以使用>any完成
SELECT SAL
FROM EMP
WHERE E.SAL > ANY(SELECT SAL FROM EMP
WHERE ENAME IN (‘SMITH’,’ALLEN’))
AND E.ENAME NOT IN (‘SMITH’,’ALLEN’);
第三步：找到部门名称
SELECT E.SAL,E.ENAME,E.EMPNO, D.DNAME
FROM EMP
WHERE E.SAL > ANY(SELECT SAL FROM EMP
WHERE ENAME IN (‘SMITH’,’ALLEN’))
AND E.ENAME NOT IN (‘SMITH’,’ALLEN’)
AND D.DEPTNO=E.DEPTNO;
第四步：找到领导信息
SELECT E.SAL,E.ENAME,E.EMPNO, D.DNAME,M.ENAME
FROM EMP E,DEPT D,EMP M
WHERE E.SAL > ANY(SELECT SAL FROM EMP
WHERE ENAME IN (‘SMITH’,’ALLEN’))
AND E.ENAME NOT IN (‘SMITH’,’ALLEN’)
AND D.DEPTNO=E.DEPTNO
AND E.MGR=M.EMPNO(+);
第五步：找到部门人数，平均工资，最高及最低工资。整个查询不能直接使用GROUP BY，所以现在我们应该利用子查询进行统计操作
SELECT E.SAL,E.ENAME,E.EMPNO, D.DNAME,M.ENAME,TEMP.COUNT,TEMP.MAX,TEMP.MIN,TEMP.AVG
FROM EMP E,DEPT D,EMP M，(
SELECT DEPTNO DNO,COUNT(EMPNO) COUNT,AVG(SAL) AVG,MAX(SAL) MAX,MIN(SAL)
FROM EMP
GROUP BY DEPTNO) TEMP
WHERE E.SAL > ANY(SELECT SAL FROM EMP
WHERE ENAME IN (‘SMITH’,’ALLEN’))
AND E.ENAME NOT IN (‘SMITH’,’ALLEN’)
AND D.DEPTNO=E.DEPTNO
AND E.MGR=M.EMPNO(+)
AND D,DEPTNO=TEMP.DEPTNO;

第四题:列出受雇日期早于其直接上级的所有员工的编号，姓名，部门名称，部门位置，部门人数
确定要使用的数据表：
EMP：编号姓名
DEPT:部门名称位置
EMP：人数
EMP：领导
确定已知的关联字段：
MGR=EMPNO
DEPTNO
第一步：EMP表进行自身关联，而后除了设置消除笛卡尔积的条件之外，还要判断受雇日期
SELECT E.EMPNO,E.ENAME
FROM EMP E,EMP M
WHERE E.MGR=M.EMPNO(+) AND E.HIREDATE<M.HIREDATE;
第二步：找到部门名称
SELECT E.EMPNO,E.ENAME,D.DNAME,D.LOC
FROM EMP E,EMP M,DEPT D
WHERE E.MGR=M.EMPNO(+) AND E.HIREDATE<M.HIREDATE
AND D.DEPTNO=E.DEPTNO;
第三步：统计部门人数
SELECT E.EMPNO,E.ENAME,D.DNAME,D.LOC,TEMP.COUNT
FROM EMP E,EMP M,DEPT D,(
SELECT COUNT(EMPNO) COUNT,DEPTNO DNO
FROM EMP
GROUP BY DEPTNO) TEMP
WHERE E.MGR=M.EMPNO(+) AND E.HIREDATE<M.HIREDATE
AND D.DEPTNO=E.DEPTNO
AND D.DEPTNO=TEMP.DNO;

第五题：列出所有办事员的姓名及其部门名称，部门人数，工资等级(EMP.SAL BETWEEN SALGRADE.LOSAL AND SALGRADE.HISAL)
SELECT E.ENAME,D.DNAME,TEMP.COUNT,S.GRADE
FROM EMP E,DEPT D,(
SELECT COUNT(EMPNO) COUNT.DEPTNO DNO 
FROM EMP 
GROUP BY DEPTNO) TEMP,SALGRADE S
WHERE JOB=’CLERK’
AND D.DEPTNO=E.DEPTNO
AND D.DEPTNO=TEMP.DNO
AND E.SAL BETWEEN S.LOSAL AND S.HISAL;
```

# 数据的更新（增删改）

## 数据增加

```sql
复制EMP表
CREATE TABLE MYEMP AS SELECT * FROM EMP;
对于数据表肯定需要新数据的加入
增加操作语法：
INSERT INTO 表名称 【（字段名称，字段名称。。。。）】VALUES(数据，数据。。。)；
数据的定义问题：
字符串：使用单引号声明
数值：直接编写
日期：三种方式：1，设置当前日期SYSDATE 2，根据日期结构编写数据字符串 3，领用TO_DATE转换为date

范例：实现数据增加，保存新的内容
使用完整语法实现数据增加：明确的编写列
INSERT INTO MYEMP(EMPNO,JOB,SAL,HIREDATE,ENAME,DEPTNO,MGR,COMM)
VALUES (6667,'清洁工',2000,TO_DATE('1988-10-10','YYYY-MM-DD'),'王二',40,7369,NULL);
简化的格式：
INSERT INTO MYEMP VALUES (6688, '王三','清洁工,7369,TO_DATE('1988-10-10','YYYY-MM-DD'), 2000,40,NULL);

增加时绝对不能使用简化格式的，一定要写完整格式的数据增加。
```

## 数据修改

```sql
语法：UPDATE 表名称 SET 字段=内容，字段=内容，……. [WHERE 更新条件s]
范例：将7369的雇员工资修改为810，佣金改为100
UPDATE MYEMP SET SAL=810，COMM=100 WHERE EMPNO=7369;
范例：将工资最低的工资修改为平均工资
UPDATE MYEMP SET SAL=(SELECT AVG(SAL) FROM MYEMP)
WHERE SAL=(SELECT MIN(SAL) FROM MYEMP)；
范例：将所有在81年雇佣的日期修改为今天，工资增长20%
UPDATE MYEMP SET HIREDATE=SYSDATE,SAL=SAL*1.2
WHERE HIREDATE BETWEEN ’01-1月-1981’ AND ’31-12月-1981’;

如果在更新的过程，没有设置更新条件那么将更新全部条件(不建议使用)
UPDATE MYEMP SET COMM=NULL;
```

## 数据删除

```sql
删除数据语法：
DELETE FEOM 表名称 【where 删除条件s】；

范例：删除雇员编号为7369的信息
DELETE FROM MYEMP WHERE EMPNO=7369;
范例：删除若干个数据
DELETE FROM MYEMP WHERE EMPNO IN (7566,3242,3464);
范例：删除掉公司中工资最高的雇员
DELETE FROM MYEMP WHERE SAL=(SELECT MAX(SAL) FROM MYEMP);
```

## 事务处理

事务：保证数据完整性的手段。数据具备ACID原则，一个人更新数据是，其他人不能更新
在Oracle之中，sqlplus是一个客户端。但是对于oracle而言每一个SQLPLUS都是独立的，都是用SESSION描述

![image-20210113100304781](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20210113100304781.png)


在事务处理之中有两个核心命令：
提交事务：COMMIT:
回滚事务：ROLLBACK:
真正使用了COMMIT提交时候才表示更新操作是可以正常完成的，所有的更新操作都需要被事务所保护

总结：事务核心的处理命令：COMMIT,ROLLBACK;
      每一个SESSION具备独立的事务，并且在未提交前更新的数据行锁定

## ROWNUM,ROWID

```sql
行号：ROWNUM（伪列；开发核心）：在开发中使用可ROWNUM，那么会自动生成行号

范例：观察ROWNUM
SELECT ROWNUM,EMPNO,ENAME,JOB FROM EMP;
SELECT ROWNUM,EMPNO,ENAME,JOB FROM EMP WHERE DEPTNO=10;
此时行号是根据我们的查询结果计算出来的，所以每一个行号都不会与特定的记录捆绑
在实际的开发过程中ROWNUM可以做两件事情：
取得第一行数据
取得前N行数据
范例：查询EMP表记录，并取第一行数据
SELECT ROWNUM,EMPNO,ENAME,JOB FROM EMP WHERE DEPTNO=10 AND ROWNUM=1;
解释为什么NOTIN里面不能为空
NOTIN如果为NULL，如果某一列上就没有null，但是NOTIN作用是数据的部分筛选，结果因为自身错误导致查询全部就是灾难了
切换到SH用户：SELECT * FROM COSTS;

对于ROWNUM最重要特性为取得前N行记录
SELECT * FROM EMP WHERE ROWNUM<=5;
取得6到10条的记录(分页)
SELECT *
FROM (
SELECT ROWNUM RN,ENAME,EMPNO FROM EMP WHERE ROWNUM <= 10) TEMP
WHERE TEMP.RN > 5;


分页的参考格式(所有开发中都有此类程序，重点记住)
currentPage:表示当前所在页；
lineSize：表示每一页显示的数据行
SELECT *
FROM(
       SELECT ROWNUM RN,….,…. FROM 表
       WHERE ROWNUM<=currentPage*lineSize) TEMP
WHERE TEMP.RN>(currentPage-1)*lineSize ;

范例：假设现在在第三页（currentPage=3），每页显示5行记录（lineSize=5）
SELECT *
FROM(
       SELECT ROWNUM RN,EMPNO,ENAME FROM EMP
       WHERE ROWNUM<=15) TEMP
WHERE TEMP.RN>10;

ROWID:
ROWID：这对于每行数据提供的物理地址
范例:查看ROWID
SELECT ROWID,DEPTNO,DNAME,LOC FROM DEPT;

AAAR3qAAEAAAACHAAA：以这组数据为例，ROWID组成：
数据对象的编号：AAAR3q
数据文件编号：AAE
数据保存的块好：AAAACH
数据保存的行号：AAA

```

# 常用数据类型

## 截断表

事务处理本身是保护数据完整性的手段，但是在使用事务处理时，需要注意一点：在我们用户更新数据后，还未进行数据提交中，如果发生了DDL操作，那么所有事务都会自动提交

假如有一张表的数据不再需要了,们需要删除它，再删除时就会出现一种情况，由于事务控制，数据不会被立刻删除，就会出现资源被占用的情况。Oracle提供了截断表的概念，一旦表被截断，那么数据所占空间将被全部释放
语法：TRUNCATE TABLE 表名称
范例：截断MYEMP表

```sql
TRUNCATE TABLE MYEMP;
```

## 表的重命名

DDL属于数据对象定义语言，主要功能创建对象，所以创建单词为CREATE
当用户进行对象操作的时候ORACLE中提供一个数据字典用于记录所有对象状态，当用用户创建表时，会自动在数据字典里添加创建信息。整个过程是ORACLE自己维护的，只能够通过命令完成
数据库字典用户常用主要分为三类
USER_*:用户的数据字典信息
DBA_*:管理员的数据字典
ALL_*:所有人都可以看的数据字典
SELECT * FROM TAB;
此时可以使用‘user_tables’
SELECT * FROM USER_TABLES
这个数据字典之中记录了保存数据存储情况，占用的资源情况
实际上表的重命名就属于更新数据字典的过程，语法：RENAME 旧的表名称 TO 新的表名称
范例:将mermber更名为person
RENAME member to person;
作为ORACLE自己的特点，了解就行了

## 删除数据表

删除数据表属于数据对象操作，所以此时他支持的语法：
DROP TABLE 表名称：
范例：删除MYEMP
DROP TABLE MYEMP;
在最早的时候如果执行了删除语句，那么数据就会直接进行删除了，但是从oracle10g开始，对于删除的操作出现了挽救的机会，类似于回收站。，如果没有其他说明，那么会将表暂时会保存在回收站之中，可以进行回复或者彻底删除。称为闪回技术（FLASH BACK）
在任何数据库里面，都不可能提供任何批量删除操作。尽量不要删除表



闪回技术：FLSAH BACK,但是用户想要操作回收站，用户具备查看，恢复，清空，彻底删除几项操作
查看命令： （不一定支持）
SELECT * FROM USER_RECYCLEBIN;
恢复PERSON表：FLASHBACK TABLE PERSON TO BEFORE DROP;
彻底删除person：DROP TABLE PERSON PURGE;
删除回收站的一张表EMP30：PURGE TABLE EMP30;
清空回收站：PURGE RECYCLEBIN;
回收站的支持只是ORACLE数据提供的

## 修改表结构

当一张数据表已经正常建设完成，当一些表发现设计问题，才提供有对象修改操作。但从本身开发来讲，并不提倡数据表的修改。一部分数据库并不提供数据表结构的修改
如果要修改数据表，首先需要有一张表，在实际开发之中，为了方便数据使用，会给一个数据库脚本，后缀为*.sql。开发人元可以利用这个脚本对数据库进行快速恢复，内容如下：
删除原有数据表
重新创建新的数据表
创建测试数据
进行事务提交
	
下面基于脚本实现数据表修改操作
修改已有列
例如：在name字段没有设置默认值，增加新数据是不指定NAME时，数据为空。现增加默认值
范例：修改member表name列
ALTER TABLE MEMBER MODIFY(NAME VARCHAR2(30) DEFAULT '无名氏');
为表增加列语法如下
ALTER TABLE 表名称 ADD（列名称 类型 [DEFAULT 默认值]，……列名）；
范例：增加一个ADDRESS列，这个列上不设置默认值
ALTER TABLE MEMBER ADD(ADDRESS VARCHAR2(30));
范例：增加一个SEX列，设置默认值
ALTER TABLE MEMBER ADD(SEX VARCHAR2(10) DEFAULT '男');
发现一旦有默认值，每一行的SEX内容都会出现。相当于更新了所有行。
删除表中的列
任何情况下，删除操作都是非常危险的。
语法：ALTER TABLE 表名称 DROP COLUMN 列名称;
范例：删除SEX列
ALTER TABLE MEMBER DROP COLUMN SEX;

# 数据约束

## 数据约束

数据满足若干条件后才能操作
数据库中约束一共六种：数据类型，非空约束，唯一约束，主键约束，检查约束，外键约束
但是约束是一把双刃剑，约束可以保证合法后保存，若是在数据库里一张表里设置过多的约束，更新速度会慢。所以在开发过程中，某一些验证操作交给程序



## 非空约束(NOT NULL,NK)

```sql
表中的某一字段内容不允许为空，如果使用非空约束，只需要在每列后面NOT NULL声明即可
CREATE TABLE MEMBER (
        MID           NUMBER ,
        NAME          VARCHAR2(20)  NOT NULL
);
范例：正确增加语句
INSERT INTO MEMBER(MID,NAME) VALUES (1，'张三');
范例：错误增加
INSERT INTO MEMBER(MID,NAME) VALUES （3，'null');
INSERT INTO MEMBER(MID) VALUES (3); 
执行完语句会出现错信息
ORA-01400: 无法将 NULL 插入 ("SCOTT"."MEMBER"."NAME")
在设置了非空约束之后，如果出现了违反非空约束的操作，那么会自动准确的定位到哪个模式，哪张表，哪个字段
```

## 唯一约束（UNIQUE）

```sql
是在某一个列上的内容不允许出现重复
范例：使用唯一约束
CREATE TABLE MEMBER (
        MID           NUMBER ,
        NAME          VARCHAR2(20)  NOT NULL,
        EMAIL          VARCHAR2(20)   UNIQUE
);

范例：保存正确的数据
INSERT INTO MEMBER(MID,NAME,EMAIL) VALUES (1，'张三','2522@QQ.COM');
范例：保存重复数据
INSERT INTO MEMBER(MID,NAME,EMAIL) VALUES (3，'三','2522@QQ.COM');
此时代码出现错误，错误提示为
第 1 行出现错误:
ORA-00001: 违反唯一约束条件 (SCOTT.SYS_C0011237)
在oracle之中约束本身也成为一个对象，也就是说只要你设置了约束，那么oracle会自动为你创建已知相关的对象信息，而这些过程都是自动完成的。那么既是对象，所以对象就会在数据字典之中进行保存。
字典应该使用：USER_CONS_COLUMNS;
范例：查询USER_CONS_COLUMNS;数据字典
SELECT * FROM USER_CONS_COLUMNS;
发现唯一约束并不像非空约束那样，可以很明确的告诉用户是哪列上出现问题，所以采用约束简写_字段，例如：唯一约束的简写是’UK’,那么现在在email字段上设置’UK_EMAIL’来作为次约束的名字，如果要指定名字，则必须在约束创建的时候完成，利用CONSTRAINT关键字定义
范例：创建唯一约束，同时设置约束名称
CREATE TABLE MEMBER (
        MID           NUMBER ,
        NAME          VARCHAR2(20)  NOT NULL,
        EMAIL         VARCHAR2(20)  ，
        CONSTRAINT UK_EMAIL UNIQUE(EMAIL)
);
如果此时出现了唯一约束问题，则提示为：
ORA-00001: 违反唯一约束条件 (SCOTT.UK_EMAIL)
从现在开始，只要进行数据表创建时，约束一定要设置名字。约束的名字绝对不能够重复
如果说设置了唯一约束，但是保存的是空呢？null并不在唯一约束的判断范畴之中
```

## 主键约束（PRIMARY KEY,PK）

```sql
主键约束=非空约束+唯一约束   不能为空不能重复
范例：定义主键约束
CREATE TABLE MEMBER (
        MID           NUMBER ,
        NAME          VARCHAR2(20)  NOT NULL,
        CONSTRAINT PK_MID PRIMARY KEY(MID)
);

范例：增加正确的数据
INSERT INTO MEMBER(MID,NAME) VALUES (3，'三');
范例：增加错误数据。将主键内容设置为空和重复
INSERT INTO MEMBER(MID,NAME) VALUES (3，'四');
INSERT INTO MEMBER(MID,NAME) VALUES (NULL，'李四');
错误信息如下：
违反唯一约束条件 (SCOTT.PK_MID)
无法将 NULL 插入 ("SCOTT"."MEMBER"."MID")
通过两个错误信息我们知道主键就是两个约束的集合体。在99%情况下，一张表只能定义一个主键信息，从SQL语法的角度来讲是允许定义多个列为主键，这样操作称为复合主键，则表示若干个列完全重复的时候才称为违反约束。
数据库第一原则，不要使用复合主键。即：一张表就一个主键约束
```

## 检查约束（CHECK,CK）

```sql
检查约束指的是在数据列上设置一些过滤条件，当满足过滤条件才进行保存，如果不满足则出现错误
例如：如果设置年龄信息，年龄0-250，性别：男，女。
范例：设置检查约束
CREATE TABLE MEMBER (
        MID           NUMBER ,
        NAME          VARCHAR2(20)  NOT NULL,
        AGE           NUMBER(3),           
        CONSTRAINT PK_MID PRIMARY KEY(MID),
        CONSTRAINT CK_AGE CHECK (AGE BETWEEN 0 AND 250)
);
范例：保存正确数据
INSERT INTO MEMBER(MID,NAME，AGE) VALUES (3，'四',30);
范例：保存错误数据
INSERT INTO MEMBER(MID,NAME，AGE) VALUES (2，'六',998);
错误信息：违反检查约束条件 (SCOTT.CK_AGE)
从实际的开发来讲，检查约束往往不会设置，检查往往都会通过程序设置
```

## 外键约束

```sql
主要是在父子表关系中体现的一种约束操作，通过操作观察为什么会有外键操作的存在。例如：一个人有多本书，如果要设计表现在需要设计两张数据表。则初期设计如下
范例：初期设计如下
-- 删除数据表
DROP TABLE MEMBER PURGE;
DROP TABLE BOOK   PURGE;
-- 清空回收站
PURGE RECYCLEBIN;
-- 创建数据表
CREATE TABLE MEMBER (
        MID           NUMBER ,
        NAME          VARCHAR2(20),
        CONSTRAINT PK_MID PRIMARY KEY(MID)
);
CREATE TABLE BOOK(
        BID           NUMBER,
        TITLE         VARCHAR(20),
        MID           NUMBER
);
下面为表增加相关的数据
增加正确数据：
INSERT INTO MEMBER(MID,NAME) VALUES (1，'张三');
INSERT INTO MEMBER(MID,NAME) VALUES (2，'李四');
INSERT INTO BOOK(BID,TITLE,MID) VALUES (10,'java开发'，1);
INSERT INTO BOOK(BID,TITLE,MID) VALUES (11,'oracle开发'，1);
INSERT INTO BOOK(BID,TITLE,MID) VALUES (12,'android开发'，2);
INSERT INTO BOOK(BID,TITLE,MID) VALUES (13,'object-ca开发'，2);
但是此时也有可能会增加如下信息
INSERT INTO BOOK(BID,TITLE,MID) VALUES (20,'GAY'，9);
此时MEMBER表中没有9号信息，但是由于此时没有设置约束，即使父表（member）中没有此编号，子表（book）也可以使用，但是这是一个错误。
BOOK表中MID取值应由member表中mid决定，所以现在需要外键约束解决此问题
在设置外键约束的时候必须要设置指定的外键列（BOOK.MID）需要哪张表的哪个列有关联
增加外键约束：
CONSTRAINT FK_MID FOREIGN KEY(MID) REFERENCES MEMBER(MID)
增加正确数据没有问题，但是增加错误数据出现：
ORA-02291: 违反完整约束条件 (SCOTT.FK_MID) - 未找到父项关键字


对于外键约束而言是大量的限制
限制1：再删除父表之前需要先删除掉它所对应的全部子表后才可以删除
MEMBER是父表，如果BOOK表不删除那么MEMBER无法删除
DROP TABLE MEMBER
出现如下错误信息：
ORA-02449: 表中的唯一/主键被外键引用
所以需要改变删除顺序，先删BOOK后删MEMBER
但是有些时候A表和B表互相为父子表，导致无法删除，为此在ORACLE里专门提供了一个专门提供强制删除父表的操作，删除后不关心子表。
强制删除：DROP TABLE MEMBER CASCADE CONSTRAINT;
但是从实际开发来讲，那么尽量按照先后顺序删除表

限制2：如果要作为子表外键的父表列，那么必须设置唯一约束或主键约束

限制3：如果现在主表中的某一行数据有对应的子表数据，那么必须先删除子表中的全部数据之后，才可以删除父表中的数据
范例;现在的脚本
-- 清空回收站
PURGE RECYCLEBIN;
-- 创建数据表
CREATE TABLE MEMBER (
        MID           NUMBER ,
        NAME          VARCHAR2(20),
        CONSTRAINT PK_MID PRIMARY KEY(MID)  
);
CREATE TABLE BOOK(
        BID           NUMBER,
        TITLE         VARCHAR(20),
        MID           NUMBER,
        CONSTRAINT FK_MID FOREIGN KEY(MID) REFERENCES MEMBER(MID) 
);
-- 测试数据
INSERT INTO MEMBER(MID,NAME) VALUES (1，'张三');
INSERT INTO MEMBER(MID,NAME) VALUES (2，'李四');
INSERT INTO BOOK(BID,TITLE,MID) VALUES (10,'java开发'，1);
INSERT INTO BOOK(BID,TITLE,MID) VALUES (11,'oracle开发'，1);
INSERT INTO BOOK(BID,TITLE,MID) VALUES (12,'android开发'，2);
INSERT INTO BOOK(BID,TITLE,MID) VALUES (13,'object-ca开发'，2);

此时MID为1在BOOK表里有对应关联
删除数据：DELETE FROM MEMBER WHERE MID=1;
出现以下错误：ORA-02292: 违反完整约束条件 (SCOTT.FK_MID) - 已找到子记录
由于BOOK表有子记录，所以父表的记录就无法删除了。
若不想收到子记录的困扰，就可以使用级联的操作关系。级联有两种：级联删除，级联更新
级联删除：在父表数据已经被删除的情况下，对应删除其子表的数据，在定义外键的时候使用DELETE CASCADE即可
范例:级联删除
CREATE TABLE BOOK(
        BID           NUMBER,
        TITLE         VARCHAR(20),
        MID           NUMBER,
        CONSTRAINT FK_MID FOREIGN KEY(MID) REFERENCES MEMBER(MID) ON DELETE CASCADE
);
删除父表数据时，子表对应记录的数据也被删除

级联更新：
如果说删除父表数据，那么对应的资表数据就设置为NULL。使用：ON DELETE SET NULL
范例：设置级联更新
CREATE TABLE BOOK(
        BID           NUMBER,
        TITLE         VARCHAR(20),
        MID           NUMBER,
        CONSTRAINT FK_MID FOREIGN KEY(MID) REFERENCES MEMBER(MID) ON DELETE SET NULL
);
删除父表数据时，子表对应的记录数据为NULL
```

## 修改约束

```sql
如果表结构的修改还可以在可以容忍的范畴之内，那么约束的修改是100%禁止的。所有约束一定要在表创建的时候就设置完整
实际约束可以进行后期的添加及删除操作，那么必须保证有约束名称
范例：数据库脚本
CREATE TABLE MEMBER (
        MID           NUMBER ,
        NAME          VARCHAR2(20)
);
INSERT INTO MEMBER(MID,NAME) VALUES (1，'张三');
INSERT INTO MEMBER(MID,NAME) VALUES (1，'李四');
INSERT INTO MEMBER(MID,NAME) VALUES (2，null);
增加约束：ALTER TABLE 表名称 ADD CONSTRAINT 约束名称 约束类型（字段） 选项….
范例：为MEMBER表曾加主键约束
ALTER TABLE MEMBER ADD CONSTRAINT PK_MID PRIMARY KEY(MID);
报错：ORA-02437: 无法验证 (SCOTT.PK_MID) - 违反主键
因为表中已经存在重复的MID数据，所以无法添加约束
通过以上的约束我们可以实现四种约束的增加：主键，唯一，检查，外键。但是不包含非空约束，若想修改只能够依靠修改表的结构的方式完成
范例：增加非空约束
ALTER TABLE MEMBER MODIFY (NAME VARCHAR2(20) NOT NULL);
但是要保证表内NAME列没有NULL值
删除约束
ALTER TABLE 表名称 DROP CONSTRAINT 约束名称
范例：删除主键约束
ALTER TABLE MEMBER DROP CONSTRAINT PK_MID;

总结：创建表，约束要一起完成；重要的约束：PRIMARYKEY,FOREIGN KEY,NOT NULL
```

## 例子

```sql
需要考虑的问题在于数据类型的选择。列的数据类型通过我们具体数据来推出
范例：编写数据库的脚本
--删除数据表
DROP TABLE PURCASE PURGE;
DROP TABLE PRODUCT PURGE;
DROP TABLE CUSTOMER PURGE;

--创建数据表
CREATE TABLE PRODUCT(
       PRODUCTID       VARCHAR2(5),
       PRODUCTNAME   VARCHAR2(20),
       UNITPRICE     NUMBER,
       CATEGORY      VARCHAR2(50),
       PROVIDER      VARCHAR2(50),
       CONSTRAINT PK_PRODUCTID PRIMARY KEY(PRODUCTID),
       CONSTRAINT CK_UNITPRICE CHECK (UNITPRICE>0)
);
CREATE TABLE CUSTOMER（
       CUSTOMERID     VARCHAR2(5),
       NAME           VARCHAR2(20) NOT NULL,
       LOCATION       VARCHAR2(50),
       CONSTRAINT PK_CUSTOMERID PRIMARY KEY(CUSTOMERID)
);
CREATE TABLE PURCASE(
       CUSTOMERID     VARCHAR2(5),
       PRODUCTID      VARCHAR2(5) ,  
       QUANTITY       NUMBER,
       CONSTRAINT FK_CUSTOMERID FOREIGN KEY(CUSTOMERID) REFERENCES CUSTOMER(CUSTOMERID) ON DELETE CASCADE,
       CONSTRAINT FK_PRODUCTID FOREIGN KEY(PRODUCTID) REFERENCES PRODUCT(PRODUCTID) ON DELETE CASCADE，
       COMSTRAINT CK_QUANTITY CHECK (QUANTITY BETWEEN 0 AND 20)
);
这个创建过程都是学习过的语法。设置外键字段在主表之中必须是主键或是唯一约束

测试数据
测试数据

增加商品信息
INSERT INTO PRODUCT(PRODUCTID,PRODUCTNAME,UNITPRICE,CATEGORY,PROVIDER) VALUES('M01','佳洁士',8.00,'牙膏','宝洁');
INSERT INTO PRODUCT(PRODUCTID,PRODUCTNAME,UNITPRICE,CATEGORY,PROVIDER) VALUES('M02','高露洁',6.50,'牙膏','高露洁');
INSERT INTO PRODUCT(PRODUCTID,PRODUCTNAME,UNITPRICE,CATEGORY,PROVIDER) VALUES('M03','洁诺',5.00,'牙膏','联合利华');
INSERT INTO PRODUCT(PRODUCTID,PRODUCTNAME,UNITPRICE,CATEGORY,PROVIDER) VALUES('M04','舒肤佳',3.00,'香皂','宝洁');
INSERT INTO PRODUCT(PRODUCTID,PRODUCTNAME,UNITPRICE,CATEGORY,PROVIDER) VALUES('M05','夏士莲',5.00,'香皂','联合利华');
INSERT INTO PRODUCT(PRODUCTID,PRODUCTNAME,UNITPRICE,CATEGORY,PROVIDER) VALUES('M06','雕牌',2.50,'洗衣粉','纳爱斯');
INSERT INTO PRODUCT(PRODUCTID,PRODUCTNAME,UNITPRICE,CATEGORY,PROVIDER) VALUES('M07','中华',3.50,'牙膏','联合利华');
INSERT INTO PRODUCT(PRODUCTID,PRODUCTNAME,UNITPRICE,CATEGORY,PROVIDER) VALUES('M08','汰渍',3.00,'洗衣粉','宝洁');
INSERT INTO PRODUCT(PRODUCTID,PRODUCTNAME,UNITPRICE,CATEGORY,PROVIDER) VALUES('M09','碧浪',4.00,'洗衣粉','宝洁');

增加用户信息
INSERT INTO CUSTOMER(CUSTOMERID,NAME,LOCATION) VALUES('C01','DENNIS','海淀');
INSERT INTO CUSTOMER(CUSTOMERID,NAME,LOCATION) VALUES('C02','JOHN','朝阳');
INSERT INTO CUSTOMER(CUSTOMERID,NAME,LOCATION) VALUES('C03','TOM','东城');
INSERT INTO CUSTOMER(CUSTOMERID,NAME,LOCATION) VALUES('C04','JENNY','东城');
INSERT INTO CUSTOMER(CUSTOMERID,NAME,LOCATION) VALUES('C05','RICK','西城');
3，增加购买记录
INSERT INTO PURCASE(CUSTOMERID,PRODUCTID,QUANTITY) VALUES('C01','M05',2);
INSERT INTO PURCASE(CUSTOMERID,PRODUCTID,QUANTITY) VALUES('C01','M08',2);
INSERT INTO PURCASE(CUSTOMERID,PRODUCTID,QUANTITY) VALUES('C02','M02',5);
INSERT INTO PURCASE(CUSTOMERID,PRODUCTID,QUANTITY) VALUES('C02','M06',4);
INSERT INTO PURCASE(CUSTOMERID,PRODUCTID,QUANTITY) VALUES('C03','M01',1);
INSERT INTO PURCASE(CUSTOMERID,PRODUCTID,QUANTITY) VALUES('C03','M05',1);
INSERT INTO PURCASE(CUSTOMERID,PRODUCTID,QUANTITY) VALUES('C03','M06',3);
INSERT INTO PURCASE(CUSTOMERID,PRODUCTID,QUANTITY) VALUES('C03','M08',1);
INSERT INTO PURCASE(CUSTOMERID,PRODUCTID,QUANTITY) VALUES('C04','M03',7);
INSERT INTO PURCASE(CUSTOMERID,PRODUCTID,QUANTITY) VALUES('C04','M04',3);
INSERT INTO PURCASE(CUSTOMERID,PRODUCTID,QUANTITY) VALUES('C05','M06',2);
INSERT INTO PURCASE(CUSTOMERID,PRODUCTID,QUANTITY) VALUES('C05','M07',8);

最后一定要提交事务，否则不会保存到数据库（COMMIT）

数据查询
确定已知的数据表，确定已知的关联关系
求购买了供应商’宝洁’产品的所有顾客
SELECT *
FROM CUSTOMER
WHERE CUSTOMERID IN (
SELECT CUSTOMERID
FROM PURCASE
WHERE PRODUCTID IN （
SELECT PRODUCTID
FROM PRODUCT
WHERE PROVIDER='宝洁'）);

求购买了商品包含了顾客‘DENNIS’所购买的所有商品顾客（姓名）
SELECT *
FROM CUSTOMER CA
WHERE NOT EXISTS(
SELECT P1.PRODUCTID
FROM PURCASE P1 
WHERE CUSTOMERID=(
SELECT CUSTOMERID
FROM CUSTOMER
WHERE NAME='DENNIS')
MINUS
SELECT P2.PRODUCTID 
FROM PURCASE P2
WHERE CUSTOMERID=CA.CUSTOMERID)
AND CA.NAME<>'DENNIS';

3,求牙膏卖出数量最多的供应商
SELECT PROVIDER
FROM PRODUCT
WHERE PRODUCTID=( 
SELECT PRODUCTID
FROM PURCASE
WHERE PRODUCTID IN(
SELECT PRODUCTID FROM PRODUCT WHERE CATEGORY='牙膏')
GROUP BY PRODUCTID
HAVING SUM(QUANTITY)=(
SELECT MAX(SUM(QUANTITY))
FROM PURCASE
WHERE PRODUCTID IN(
SELECT PRODUCTID FROM PRODUCT WHERE CATEGORY='牙膏')
GROUP BY PRODUCTID));


数据更新

将所有牙膏商品单价增加10%
UPDATE PRODUCT SET UNITPRICE=UNITPRICE*1.1 WHERE CATEGORY='牙膏';
删除从未购买的商品记录
```

## 序列的使用	

```sql
在许多数据库都存在数据增长列的数据类型，他能够创建流水号，以前并没有提供这样的自动增长列，但自从oracle 12c开始出现了自动增长列。如果想要实现自动增长列，就可以使用序列方式完成
语法：
CREATE SEQUENCE 序列名称
[MAXVALUE 最大值 | NOMAXVALUE]
[MINVALUE 最小值 | NOMINVALUE]
[INCREMENTBY 步长] [START WITH 开始值]
[CYCLE | NOCYCLE]
[CACHE 缓存个数| NOCACHE]

序列属于数据库的创建过程，属于DDL的分类范畴，都会在数据字典中表现
范例：CREATE SEQUENCE MYSEQ;
查询user_sequences的数据字典。
Select * from user_sequences
数据字典分析如下
```

![捕获](C:\Users\Administrator\Desktop\捕获.PNG)

```sql
若想要使用序列，需要使用如下两个伪列
Nextval:取得序列下一个内容，每一次调用序列的值都会增长
Currval：表示取得当前序列内容，每一次调用序列的值都不会增长
在使用CURRVAL伪列之前必须先使用NEXTVAL
如果想要在实际开发之中使用序列进行开发操作，那么必须手工在数据增加时进行处理，而数据表的定义与之前没有任何区别
CREATE TABLE MYTAB(
     ID        NUMBER,
     NAME    VARCHAR2(50),
     CONSTRAINT PK_ID PRIMARY KEY(ID)
);

增加数据
INSERT INTO MYTAB(ID,NAME) VALUES (MYSEQ.NEXTVAL,'HELLO');
以上的操作作为序列在实际开发中使用最多的一种情况，但是从序列的创建语法来讲不是这么简单
首先解决缓存的作用是什么？
SELECT MYSEQ.NEXTVAL FROM DUAL;
SELECT SEQUENCE_NAME,CACHE_SIZ
```



# 视图和同义词

## 视图的创建与使用

```sql
利用视图可以实现复杂SQL语句的封装操作，视图创建语法
CREATE [OR REPLACE] VIEW 视图名称 AS 子查询；
范例：创建视图
先为SCOTT赋予权限
CONN sys/change_on_install AS SYSDBA;
GRANT CREATE VIEW TO scott;
CONN scott/tiger;
创建视图
CREATE VIEW MYVIEW AS SELECT * FROM EMP WHERE DEPTNO=10;
查看视图信息：查询到具体语法
SELECT*FROM USER_VIEWS;
查询试图：SELECT *  FROM MYVIEW;


可以用视图包装一个复杂的查询
范例：CREATE OR REPLACE VIEW MYVIEW
      AS 
SELECT D.DEPTNO,D.DNAME,D.LOC,TEMP.COUNT
      FROM DEPT D,(
      SELECT DEPTNO DNO,COUNT(*) COUNT
      FROM EMP
      GROUP BY DEPTNO) TEMP
      WHERE D.DEPTNO=TEMP.DNO(+);

实际视图只是包含查询语句的临时数据，默认情况下创建的视图是可以修改的
范例：CREATE OR REPLACE VIEW MYVIEW
      AS
      SELECT * FROM EMP WHERE DEPTNO=20;
默认情况下，此查询时可以修改的
UPDATE MYVIEW SET DEPTNO=30 WHERE EMPNO=7369;

发现此时更新视图，导致emp表的内容也发生了变化。所以在改变视图时可以在创建视图的时候使用WITHCHECK OPTINO子句：
CREATE OR REPLACE VIEW MYVIEW
      AS
      SELECT * FROM EMP WHERE DEPTNO=20
WITH CHECK OPTION;
此时若更新会出现：ORA-01402: 视图 WITH CHECK OPTION where 子句违规

但是视图中不光有创建条件的字段，还可能会包含其他字段。可是现在的操作中可以修改视图中的其他内容
修改其他字段：
UPDATE MYVIEW SET SAL=80000 WHERE EMPNO=7369;

所以在创建视图时都是临时数据，所以建议创建一个只读试图:WITH READ ONLY
范例：创建只读视图
CREATE OR REPLACE VIEW MYVIEW
      AS
      SELECT * FROM EMP WHERE DEPTNO=20
WITH READ ONLY；

从实际开发中视图包装单表没有意义
```

## 创建同义词语法

CREATE [PUBLIC] SYNONYM 同义词名称 FOR 模式表名称
范例：将scott.emp映射为semp
CREATE SYNONYM SEMP FOR SCOTT.EMP;
但是此同义词只能被sys用户使用

# 索引

索引的定义，作用和使用

观察如下程序：
SELECT * FROM SCOTT.EMP WHERE SAL>1500;
于是通过此语句来分析数据库做了什么。
为了观察方便，打开追踪器：CONN sys/change_on_install AS SYSDBA
                          SET AUTOTRACE ON;
打开之后直接在sys 用户中进行信息查询，此时的查询除了返回结果之外，还会返回一些分析信息：TABLE ACCESS FULL
此时直接描述的是进行全表扫描，就属于逐行扫描。而且最为关键的问题在于，如果现在emp表数据有50W，可能在第20902条之后就没有任何的雇员记录可以满足于此条件，那么这个时候以上的语句会继续向后差，这就是一种浪费，影响性能。那么该如何解决呢？数据最好的排列是根据树排列
树排列的原则：选取一个数据作为结点，比此节点大的数据在右子树，比此节点小的放在左子树。本程序使用的SAL字段，所以用SAL操作索引。

![image-20210113105840161](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20210113105840161.png)

所以这时就可以进行索引的创建已实现以上的操作结构
范例：为SCOTT.EMP在SAL上创建索引
CREATE INDEX EMP_SAL_IND ON SCOTT.EMP(SAL);
在查询发现不在使用全表扫描，而是查询了所需要的范围特点
如果不想重复维护树，那么就必须保证数据的不变和唯一，所以会在主键约束上自动增加一个索引。
在现实的开发中保证用户的回应速度快，没有延迟，支持大量用户更新操作。若想查询速度快，必须使用索引。如果想保证更新速度，那么就不能使用索引，所以最好的做法就是牺牲实时性。等于两个数据可，一个负责给用户查询使用，另一个负责更新。

# 数据库的设计范式

## 第一范式(单表)

数据表中每一个列不可再分

![image-20210113111227114](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20210113111227114.png)

第一范式核心意义使用常用数据类型：NUMBER,DATE,VARCHAR2,CLOB
两个注意：
对于日期描述不能拆分为：年，月，天
对于姓名字段与国外是不同的

## 第二范式（多对多）

数据表中不存在非关键字段对任意一候选关键字段的部分函数依赖。
对于概念有两个层次的解释：
先通过函数关系进行描述，假设添加一张订单表

![image-20210113111250386](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20210113111250386.png)

此时存在有函数关系：总价=商品单价*购买数量



函数依赖：某几个字段集合是否可以推导出其他列的内容

![image-20210113111259994](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20210113111259994.png)

多对多的数据查询需要三张表一起查询，所以是个复杂查询

## 第三样式(一对多设计)

数据表之中不存在非关键字段对任意一候选关键字段传递函数依赖

范例：现在一个学校有多个学生。如果现在使用第一范式，学校信息重复，如果使用第二设计范式，可以描述一个学校有多个学生和一个学生对用多个学校，所以我们要用第三范式来解决

![image-20210113111339492](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20210113111339492.png)

这就是之前DEPT和EMP关系