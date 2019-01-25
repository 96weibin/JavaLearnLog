# 链接Mysql

## JDBC

### eclipse 引入 JDBC jar包（驱动）

1. [下载JDBC的jar包](mysql-connector-java-5.1.39-bin.jar);
2. 使用Eclipse 引入 jar包
    * 在项目下创建一个lib文件夹
    * 将jar包拖进lib文件夹
    * 项目右击 -> 构建路径 -> 配置构建路径
    * library -> add Jar -> 选择 lib 下的jar包->应用退出即可

### 链接数据库MySQL

* 引入Driver(注册驱动)

```java
    Class.forName(JDBC_DRIVER);
    //或
    DriverManager.registerDriver(new com.mysql.jdbc.Driver());
```

* Connection

```java
    Connection conn = (Connection) DirverManager.getConnection(url,dbUser,dbPassword);
```

* Statement(声明、报表、清单)

```java
    Statement stmt = conn.createStatement();
    //或
    //PreparedStatement perStmt = conn.prepareStatement(sql);

    ResultSet rs = stmt.executeQuery("select * from z_emp");
    int num = stmt.executeUpdate("insertSql");
    //select操作用 executeQuery执行
    while(rs.next()){
        String name = rs.getString("name");
    }

    //DML操作用  executeUpdate来执行，会返回int 代表影响的记录数
```

* close

```java
    if(rs != null) rs.close();
    if(stmt != null) stmt.close();
    if(conn != null) conn.close();
```

* demo

```java
package connect;
import java.sql.*;
public class MySQLDemo {
    static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";

    static final String DB_URL = "jdbc:mysql://10.20.2.9:3306/test";
    //mySql数据库url的格式
    static final String USER = "test";
    static final String PASS = "test";
    public static void main(String[] args)throws SQLException,Exception {
        Connection conn = null;
        Statement stmt = null;
        Class.forName(JDBC_DRIVER);
        System.out.println("连接数据库");
        conn = (Connection)DriverManager.getConnection(DB_URL, USER, PASS);
        System.out.println("实例化Statement对象");
        stmt = conn.createStatement();
        String sql;
        sql = "SELECT name FROM z_emp";
        ResultSet rs = stmt.executeQuery(sql);
        while(rs.next()) {
            String oName = rs.getString("name");
            System.out.println(oName);
        }
        rs.close();
        stmt.close();
        conn.close();
        System.out.println("Goodbye!");
    }
}
```

### 常见错误

### 增删改查

#### insert

```java

    String sql3 = "insert into z_emp(name,age) values('马云',58)";
    int n = stmt.executeUpdate(sql3);
    if(n == 1) {
        System.out.println("插入成功");
    }
```

#### PreparedStatement（SQL语句中添加变量）

```java
    PreparedStatement preStmt = null;
    String sql2 = "insert into z_emp (name,age) values(?,?)";
    preStmt = conn.prepareStatement(sql2);
    preStmt.setString(1, "马化腾");
    preStmt.setInt(2,45);
    int n = preStmt.executeUpdate();
    //executeQuery用于select  不影响数据源的
    if(n == 1) {
    System.out.println("数据插入成功");
    }
```
#### 关联查询(sql)

```sql
SELECT * 
from z_emp emp  -- 可以空格后加  声明 变量名
JOIN z_eba eba
	on emp.name = eba.name      --可以判断的条件应该还有  再用到的时候再补充
```

### 关闭

```java
rs.close()
stmt.close()
conn.close() //如果
```


### JDBC中的事务

    jdbc中默认的事务是自动提交的

```java
    conn.setAutoCommit(false);//true 自动提交
```

## 键表种类

名称 | 作用
-|-
主键 | 标记唯一的数据库中的一个字段
外键 | 在表内引入另一张表的主键,在这张表中就叫外键
主表 | 主键所在的表
从表 | 外键所在的表
关联表 | 关联查询

主表从表是相对的


## sql 语句创建表

```sql
CREATE TABLE t_user (
 t_id int(11) NOT NULL AUTO_INCREMENT,
 t_login_name varchar(50) DEFAULT NULL,
 t_password varchar(50) DEFAULT NULL,
 t_name varchar(100) DEFAULT NULL,
 PRIMARY KEY (t_id)
) ENGINE=InnoDB;    -- InnoDB是 mysql的一种引擎
```