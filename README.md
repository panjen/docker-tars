本镜像是Tars的docker版本，未安装mysql

本镜像根据https://github.com/luocheng812/docker_tars修改；

在运行容器前请先安装数据库，并在运行容器时指定数据库的环境变量，数据库环境变量，如下：

DBIP 127.0.0.1

DBPort 3306

DBUser root

DBPassword password

创建容器时务必指定数据库地址和密码，如下：

docker run -d -it --name tars --env DBIP=... --env DBPassword=password -v /data/:/data -p 8080:8080 tars
