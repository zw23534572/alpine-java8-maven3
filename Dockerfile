FROM registry.cn-shenzhen.aliyuncs.com/sjroom/alpine-java8

RUN apk add maven git

RUN rm -rf /var/cache/apk/* && rm -rf /packages