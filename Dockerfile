# 使用JDK11启动
FROM openjdk:11-jre-slim

# 声明运行时提供服务的端口
EXPOSE 20000

# 拷贝fatjar
COPY eureka-server.jar /app/eureka-server/eureka-server.jar

# 容器启动入口
ENTRYPOINT ["java","-server","-Xms64m","-Xmx64m","-XX:MetaspaceSize=64M","-XX:MaxMetaspaceSize=64M","-XX:+DisableAttachMechanism","-Xlog:gc*,gc+ref=debug,gc+age=trace,gc+heap=debug:file=/app/eureka-server/logs/gc%p%t.log:tags,uptime,time:filecount=10,filesize=10m","-XX:+HeapDumpOnOutOfMemoryError","-XX:HeapDumpPath=/app/eureka-server/logs/heapdump.hprof","-Dlog.path=/app/eureka-server/logs","-Dlog.root.level=info","-jar","/app/eureka-server/eureka-server.jar"]
