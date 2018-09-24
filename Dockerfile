FROM registry.cn-shenzhen.aliyuncs.com/sjroom/alpine-java8

RUN apk add git

RUN rm -rf /var/cache/apk/* && rm -rf /packages

# 本地安装maven
ADD apache-maven-3.5.0 /export/servers/mvn
ENV MAVEN_HOME /export/servers/mvn
ENV PATH ${PATH}:${MAVEN_HOME}/bin

RUN chmod +x ${MAVEN_HOME}/bin/*

RUN echo "export MAVEN_HOME=/export/servers/mvn" >> /etc/profile
RUN source /etc/profile
