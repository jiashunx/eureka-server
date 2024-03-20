
### Eureka注册中心（附Dockerfile及Docker部署步骤）

- 技术组件

   - SprintBoot: 2.7.8

   - SprintCloud: 2021.0.8

- 运行配置

   - 运行环境：JDK11+

   - 启动参数

   ```text
   # 指定不同环境配置文件（若不指定则默认dev，可指定参数值：dev|sit|prod）
   --spring.profiles.active=prod
   # 示例启动命令
   java -jar eureka-server.jar --spring.profiles.active=prod
   ```

   - JVM参数（参考）

   ```text
   -Xms64m
   -Xmx64m
   -XX:MetaspaceSize=64M
   -XX:MaxMetaspaceSize=64M
   -XX:+DisableAttachMechanism
   ```

- Docker部署文档

   - 构建可执行jar包（输出服务包名：eureka-server.jar）

   - Docker宿主机创建目录

   ```text
   # 构建&日志&数据存储目录
   mkdir -p /app/docker/eureka-server/{build,logs,config}
   ```

   - 拷贝 [Dockerfile](./Dockerfile) 及可执行jar包，上传至安装Docker的主机，存放目录：<b>/app/docker/eureka-server/build</b>

      - 备注：从容器访问宿主机，使用默认桥接模式访问主机（ip addr show docker0，可查看主机上Docker IP，默认：172.17.0.1）

   - 执行镜像构建命令：<b>docker build -t eureka-server:1.0.0 ./</b>

      - 镜像名称：eureka-server

      - 镜像版本：1.0.0

      - Dockerfile文件名称：参数<b>-f Dockerfile</b>，若不指定"-f"参数默认找"Dockerfile"

      - Dockerfile文件存放目录：<b>./</b>

      - 镜像构建完成后可查看镜像：<b>docker images</b>

   - 至此，Docker镜像已构建完成，以下为部署配置+启动步骤

   - 若需修改配置文件，可拷贝 [application.yaml](./src/main/resources/application.yaml) 及 [bootstrap.yaml](./src/main/resources/bootstrap.yaml) 至宿主机目录：<b>/app/docker/eureka-server/config</b>，然后按需修改

      - 注意: 若修改 [bootstrap.yaml](./src/main/resources/bootstrap.yaml) 文件则需修改 spring.profiles.active 参数为确定值

   - 创建并启动eureka-server容器

   ```text
   docker run -itd \
   -p 20000:20000 \
   -v /app/docker/eureka-server/logs:/app/eureka-server/logs \
   -v /app/docker/eureka-server/config:/app/eureka-server/config \
   --restart=always \
   --name eureka-server \
   eureka-server:1.0.0 \
   --spring.profiles.active=prod \
   --spring.config.location=/app/eureka-server/config/

   # 注意: 若不指定spring.profiles.active参数则默认dev
   # 注意: 若指定spring.config.location则需注意配置文件中的spring.profiles.active需自行修改
   ```

   - 访问eureka-server服务：http://宿主机IP:20000
