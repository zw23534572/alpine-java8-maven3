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
RUN mkdir -p ~/.m2/
ADD m2 ~/.m2/

RUN source /etc/profile
