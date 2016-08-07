#!/bin/bash

# Build Zeppelin
cd /tmp
wget "http://archive.apache.org/dist/zeppelin/zeppelin-0.6.0/zeppelin-0.6.0.tgz"
tar xzf zeppelin-0.6.0.tgz
cd zeppelin-0.6.0
mvn package -Pdist,native -DskipTests -Dtar -Drat.skip=true
cd /tmp
sudo mv zeppelin-0.6.0 /root/zeppelin
