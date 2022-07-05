#!/bin/sh

su - oracle <<eofExpdp
sqlplus '/as sysdba'
	drop directory impdp_dmp;
	drop directory expdp_dmp;
	create directory expdp_dmp as '/u01/Myspace';
	select *from dba_directories;
	grant read,write on directory expdp_dmp to jtcadmin;
eofExpdp

# 删除备份数据
rm -r /u01/Myspace/expdp*

# 导出数据
expdp jtcadmin/123456@localhost/orcl directory=expdp_dmp dumpfile=expdp.dmp logfile=expdp.log


export NLS_LANG=american_america.ZHS16GBK

expdpdate=`date +"%Y%m%d"`;
#expiredate=$(perl -e "use POSIX qw(strftime); print strftime '%Y%m%d',localtime(time()-3600*24*6)")
echo "  *****expdp backup start  time ${expdpdate} ******* "

expdp for_dump/for_dump8GTJ directory=expdp_backup schemas=rt_from,gis,sm,houseplatform,afsin,rt_to,ttia,surveycache,pubr,tt,ap,archive,ttfehcashia,pb,tt_contract,digitalscan,ati dumpfile=expdp_16_${expdpdate}.dmp logfile=expdp_16_${expdpdate}.log

cd /backup/expdp_backup
gzip expdp_16_${expdpdate}.dmp

endDate=`date +%Y-%m-%d" "%H:%M:%S`;
echo "ÒµÎñÉú²ú¿âµ¼³öÍê±Ïend time ${endDate}";
