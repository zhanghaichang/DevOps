@echo off
echo.
echo [信息] 运行Web工程。
echo.

cd %~dp0
cd ../ruoyi-admin/target

set JAVA_OPTS=-Xms256m -Xmx1024m -XX:MetaspaceSize=512m -XX:MaxMetaspaceSize=1024m

java -jar %JAVA_OPTS% ruoyi-admin.jar

cd bin
pause
