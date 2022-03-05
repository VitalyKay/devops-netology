FROM centos:7

EXPOSE 9200
EXPOSE 9300

ENV ES_PATH_CONF=/etc/elasticsearch
ENV ES_HOME=/usr/share/elasticsearch

COPY elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo

RUN groupadd -g 1000 elasticsearch && useradd elasticsearch -u 1000 -g 1000

RUN rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
RUN yum install -y java-1.8.0-openjdk.x86_64 && \
    yum install -y --enablerepo=elasticsearch elasticsearch && \
    yum clean all

RUN chmod 777 $ES_PATH_CONF

RUN rm -f $ES_PATH_CONF/elasticsearch.keystore

RUN mkdir $ES_HOME/snapshots

RUN chmod 777 $ES_HOME/snapshots

COPY elasticsearch.yml $ES_PATH_CONF/elasticsearch.yml

WORKDIR $ES_HOME/bin

ENV PATH=$PATH:$ES_HOME/bin

USER elasticsearch

CMD [ "./elasticsearch" ]