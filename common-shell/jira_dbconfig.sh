#!/bin/bash
JIRA_DIR="/usr/local/jira_home"
DB_CONFIG="dbconfig.xml"
DB_CONFIG_BAK="dbconfig_bak.xml"
MYSQL_CONNECTOR="mysql-connector-java-8.0.22.jar"
JIRA_CONTAINER_NAME="jira"
sudo mkdir -pv ${JIRA_DIR}
#备份容器内部jira的dbconfig.xml文件，将容器内的文件复制到宿主机: docker cp 容器id:容器文件位置  需要拷贝到的宿主位置
docker cp ${JIRA_CONTAINER_NAME}:/var/atlassian/application-data/jira/dbconfig.xml ${JIRA_DIR}
sudo mv -fv ${JIRA_DIR}/${DB_CONFIG} ${JIRA_DIR}/${DB_CONFIG_BAK}
#
# 1. 动态创建Jira的数据库配置文件dbconfig.xml
#
sudo tee ${JIRA_DIR}/${DB_CONFIG} <<-'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<jira-database-config>
    <name>defaultDS</name>
    <delegator-name>default</delegator-name>
    <database-type>mysql8</database-type>
    <jdbc-datasource>
        <url>jdbc:mysql://192.168.40.132:33306/jiradb?serverTimezone=Asia/Shanghai&amp;useSSL=false&amp;allowPublicKeyRetrieval=true&amp;autoReconnect=true&amp;allowMultiQueries=true&amp;sessionVariables=default_storage_engine=InnoDB</url>
        <driver-class>com.mysql.cj.jdbc.Driver</driver-class>
        <username>root</username>
        <password>123456</password>

        <pool-min-size>20</pool-min-size>
        <pool-max-size>20</pool-max-size>
        <pool-max-wait>30000</pool-max-wait>
        <pool-max-idle>20</pool-max-idle>
        <pool-remove-abandoned>true</pool-remove-abandoned>
        <pool-remove-abandoned-timeout>300</pool-remove-abandoned-timeout>

        <validation-query>select 1</validation-query>
        <min-evictable-idle-time-millis>60000</min-evictable-idle-time-millis>
        <time-between-eviction-runs-millis>300000</time-between-eviction-runs-millis>

        <pool-test-while-idle>true</pool-test-while-idle>
        <pool-test-on-borrow>false</pool-test-on-borrow>
        <validation-query-timeout>3</validation-query-timeout>
    </jdbc-datasource>
</jira-database-config>
EOF
#
# 2. 操作jira容器使数据库配置文件dbconfig.xml生效
#
#将[mysql-connector-java.x.y.z.jar]上传到[/usr/local/jira_home]目录下
docker cp ${JIRA_DIR}/${MYSQL_CONNECTOR} ${JIRA_CONTAINER_NAME}:/opt/atlassian/jira/lib

#修改dbconfig.xml后，复制回jira容器
docker cp ${JIRA_DIR}/${DB_CONFIG} ${JIRA_CONTAINER_NAME}:/var/atlassian/application-data/jira

#进入Jira容器内部
#docker exec -it jira bash

docker restart jira
clear && docker logs -f jira
