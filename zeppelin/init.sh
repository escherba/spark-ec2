#!/bin/bash

# Install Maven (for Hadoop)
# cd /tmp
# wget "http://archive.apache.org/dist/maven/maven-3/3.2.3/binaries/apache-maven-3.2.3-bin.tar.gz"
# tar xzf apache-maven-3.2.3-bin.tar.gz
# mv apache-maven-3.2.3 /opt/

sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven


# Edit bash profile
echo "export PS1=\"\\u@\\h \\W]\\$ \"" >> ~/.bash_profile
echo "export JAVA_HOME=/usr/lib/jvm/java-1.7.0" >> ~/.bash_profile
#echo "export M2_HOME=/opt/apache-maven-3.2.3" >> ~/.bash_profile
echo "export PATH=\$PATH:\$M2_HOME/bin" >> ~/.bash_profile

source ~/.bash_profile


# Build Zeppelin
cd /tmp
wget "http://archive.apache.org/dist/zeppelin/zeppelin-0.6.0/zeppelin-0.6.0.tgz"
tar xzf zeppelin-0.6.0.tgz
cd zeppelin-0.6.0

HADOOP_VERSION=`/root/ephemeral-hdfs/bin/hadoop version |  sed -n -e 's/^Hadoop //p'`
SPARK_VERSION=`/root/spark/bin/spark-submit --version 2>&1 |  sed -n -e 's/.*version //p'`
mvn clean package \
    -Pspark-${SPARK_VERSION%.*} -Phadoop-${HADOOP_VERSION%.*} \
    -Dspark.version=$SPARK_VERSION -Dhadoop.version=$HADOOP_VERSION \
    -Ppyspark -Pyarn -Pdist,native -DskipTests -Dtar -Drat.skip=true

cp conf/zeppelin-env.sh.template conf/zeppelin-env.sh
echo "export JAVA_HOME=/usr/lib/jvm/java-1.7.0" >> conf/zeppelin-env.sh
echo "export HADOOP_CONF_DIR=/root/ephemeral-hdfs/conf" >> conf/zeppelin-env.sh


cd /tmp
rm -rf /root/zeppelin
sudo mv zeppelin-0.6.0 /root/zeppelin
