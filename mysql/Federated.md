### 第一步
在my.cnf中添加federated这一个属性就可开启.
下面就是在建表语句中加入Federated了.

### 第二步

声明引擎        连接属性          账号    密码      ip            port 数据库  表
ENGINE =FEDERATED CONNECTION='mysql://root:lizhenghua@192.168.137.148:3306/zskdb/cas_user';
 slave中创建表结构的时候加入上面引擎.
 
```
CREATE TABLE `cas_user` (
  `id` varchar(255) NOT NULL COMMENT 'id',
  `encryid` varchar(255) DEFAULT NULL COMMENT '加密后的用户id',
  `name` varchar(255) DEFAULT NULL COMMENT '用户名',
  `password` varchar(255) DEFAULT NULL COMMENT '密码',
  `mobile` varchar(40) DEFAULT NULL COMMENT '手机号码',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `sex` int(1) DEFAULT NULL COMMENT '性别（0：男，1：女）',
  `credit` double(11,2) DEFAULT '0.00',
  PRIMARY KEY (`oid`),
  UNIQUE KEY `upk_user_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='用户表'
ENGINE =FEDERATED CONNECTION='mysql://root:zhenghua@192.168.137.148:3306/zskdb/cas_user';
```
 从上面可以看出来, 我本身表就已经有啦innodb引擎, 我在后面再添加了一个.

 注意: 只要表结构就行, 数据会自动从master中映射过来的.

 演示:只要master中的cas_user表有操作,在slave中会显示同样的操作, 我在master中删除两条数据, 打开slave的cas_user会发现数据同样少了那被删的两条.
