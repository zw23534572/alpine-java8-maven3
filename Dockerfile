FROM registry.cn-shenzhen.aliyuncs.com/sjroom/alpine-java8

# 安装 git 
RUN apk add git 
RUN rm -rf /var/cache/apk/* && rm -rf /packages

# 本地安装 maven
ADD apache-maven-3.5.0 /export/servers/mvn
ENV MAVEN_HOME /export/servers/mvn
ENV PATH ${PATH}:${MAVEN_HOME}/bin
RUN echo "export MAVEN_HOME=/export/servers/mvn" >> /etc/profile

# 配置maven 可以执行权限
RUN chmod +x ${MAVEN_HOME}/bin/*

# 将中央仓库 修改为aliyun
RUN mkdir -p /root/.m2/
ADD m2 /root/.m2

# 添加部署的sh
ADD deploy.sh /export/deploy.sh
ADD service.sh /export/service.sh
RUN chmod +x /export/*.sh

RUN source /etc/profile


#启动、停止脚本(sprintboot)
RUN echo "sh /export/App/service.sh start" >> /export/servers/script/start.sh
RUN echo "sh /export/App/service.sh stop" >> /export/servers/script/stop.sh