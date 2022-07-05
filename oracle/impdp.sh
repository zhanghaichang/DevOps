
#!/bin/sh

# 删除表空间和用户
su - oracle <<eofIMP
sqlplus '/as sysdba'
	drop tablespace JTC including contents and datafiles cascade constraint;
	drop user jtcadmin cascade;
eofIMP

# 创建用户、表空间
su - oracle <<eofJTC
sqlplus '/as sysdba'
	CREATE TABLESPACE JTC DATAFILE '/u01/Myspace/JTC.DBF' 
	SIZE 32M AUTOEXTEND ON NEXT 32M MAXSIZE UNLIMITED 
	EXTENT MANAGEMENT LOCAL;
	CREATE USER jtcadmin IDENTIFIED BY 123456 ACCOUNT UNLOCK DEFAULT TABLESPACE JTC;
	GRANT CONNECT,RESOURCE TO jtcadmin;
	GRANT EXP_FULL_DATABASE,IMP_FULL_DATABASE TO jtcadmin;
	GRANT DBA TO jtcadmin;
eofJTC


# 创建目录
su - oracle <<eofImpdp
sqlplus '/as sysdba'
	create directory impdp_dmp as '/u01/Myspace';
	grant read,write on directory impdp_dmp to jtcadmin;
eofImpdp

# 导入数据
impdp jtcadmin/123456@localhost/orcl directory=impdp_dmp dumpfile=expdp.dmp logfile=expdp.log FULL=y
