FROM frolvlad/alpine-oraclejdk8:slim
EXPOSE 8080
VOLUME /tmp

ENV JVM_OPTS="\
-Xms1g -Xmx1g -verbose:gc \
-XX:+PrintGCDetails \
-XX:+PrintGCDateStamps \ 
-XX:+PrintGCTimeStamps \ 
-XX:ParallelGCThreads=3 \ 
-XX:ConcGCThreads=3 \
-XX:MaxPermSize=128m \
-Dcom.sun.management.jmxremote.port=9999 \
-Dcom.sun.management.jmxremote.ssl=false \
-Dcom.sun.management.jmxremote.authenticate=false"

ADD target/renren-fast.jar /app.jar
CMD java ${JVM_OPTS} -jar app.jar
