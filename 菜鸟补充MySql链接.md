# 链接Mysql

## eclipse 引入 JDBC jar包（驱动）

1. [下载JDBC的jar包](mysql-connector-java-5.1.39-bin.jar);
2. 使用Eclipse 引入 jar包
    * 在项目下创建一个lib文件夹
    * 将jar包拖进lib文件夹
    * 项目右击 -> 构建路径 -> 配置构建路径 
    * library -> add Jar -> 选择 lib 下的jar包->应用退出即可

## 链接数据库Oracle

```java
jdbc: oracle : thin: @192.168.0.26:1143:rarena
```
* 链接Oracle数据库的必要数据

类名 | 功能
-|-
ip | 服务器ip地址
sid | 数据库表示号
port | 数据库端口号
dbUser/dbPassword | 数据库账号



