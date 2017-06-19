#!/bin/bash

ResourceDir=/root/res
MachineIp=$(ip addr | grep inet | grep eth0 | awk '{print $2;}' | sed 's|/.*$||')
MachineName=$(cat /etc/hosts | grep ${MachineIp} | awk '{print $2}')

build_cpp_framework(){

  echo "build cpp framework ...."
  ##Tars数据库环境初始化
  mysql -h${DBIP} -P${DBPort} -u${DBUser} -p${DBPassword} -e "grant all on *.* to 'tars'@'%' identified by 'tars2015' with grant option;"
  mysql -h${DBIP} -P${DBPort} -u${DBUser} -p${DBPassword} -e "grant all on *.* to 'tars'@'localhost' identified by 'tars2015' with grant option;"
  mysql -h${DBIP} -P${DBPort} -u${DBUser} -p${DBPassword} -e "grant all on *.* to 'tars'@'${MachineName}' identified by 'tars2015' with grant option;"
  mysql -h${DBIP} -P${DBPort} -u${DBUser} -p${DBPassword} -e "flush privileges;"

  sed -i "s/192.168.2.131/${MachineIp}/g" `grep 192.168.2.131 -rl /root/Tars/cpp/framework/sql/*`
  sed -i "s/db.tars.com/${DBIP}/g" `grep db.tars.com -rl /root/Tars/cpp/framework/sql/*`

  cd /root/Tars/cpp/framework/sql/
  sed -i "s/proot@appinside/h${DBIP} -P${DBPort} -u${DBUser} -p${DBPassword} /g" `grep proot@appinside -rl ./exec-sql.sh`
  chmod u+x /root/Tars/cpp/framework/sql/exec-sql.sh
  /root/Tars/cpp/framework/sql/exec-sql.sh

  sed -i "s/192.168.2.131/${MachineIp}/g" `grep 192.168.2.131 -rl /usr/local/app/tars/*`
  sed -i "s/db.tars.com/${DBIP}/g" `grep db.tars.com -rl /usr/local/app/tars/*`
  sed -i "s/dbport=3306/dbport=${DBPort}/g" `grep 3306 -rl /usr/local/app/tars/*`
  sed -i "s/registry.tars.com/${MachineIp}/g" `grep registry.tars.com -rl /usr/local/app/tars/*`
  sed -i "s/web.tars.com/${MachineIp}/g" `grep web.tars.com -rl /usr/local/app/tars/*`

  chmod u+x /usr/local/app/tars/tars_install.sh
}

build_web_mgr(){

  echo "build web manager ...."

  ##安装web管理系统
  cd /root/Tars/web/
  sed -i "s/db.tars.com/${DBIP}/g" `grep db.tars.com -rl /root/Tars/web/src/main/resources/app.config.properties`
  sed -i "s/3306/${DBPort}/g" `grep 3306 -rl /root/Tars/web/src/main/resources/app.config.properties`
  sed -i "s/registry1.tars.com/${MachineIp}/g" `grep registry1.tars.com -rl /root/Tars/web/src/main/resources/tars.conf`
  sed -i "s/registry2.tars.com/${MachineIp}/g" `grep registry2.tars.com -rl /root/Tars/web/src/main/resources/tars.conf`
  sed -i "s/DEBUG/INFO/g" `grep DEBUG -rl /root/Tars/web/src/main/resources/log4j.properties`
  source /etc/profile
  mvn clean package
  cp /root/Tars/build/conf/resin.xml /usr/local/resin/conf/
  cp /root/Tars/web/target/tars.war /usr/local/resin/webapps/
}


build_cpp_framework

build_web_mgr
