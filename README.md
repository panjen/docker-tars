本镜像是Tars的docker版本，未安装mysql

在运行容器前请先安装数据库，并在运行容器时指定数据库的环境变量，默认用到的数据库端口是3306，用户是root

docker run -d -it --name tars --env DBIP=... --env DBPassword=password -v /data/:/data -p 8080:8080 tars
