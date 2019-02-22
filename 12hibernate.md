# Hibernate

  封装的jdbc与SQL的**数据访问层**框架  或 **持久层**框架

  持久层 ： 数据库之前,将数据存储到数据库

## ORM （Object Relational Mapping）

  ORM 的优点   业务访问对象,而不是数据库，隐藏SQL的查询细节

## Hibernate 中重要的类

* Configuration 装载配置文件
* SessionFactory 获取session
* Session 链接数据库,保存持久对象
* Transaction 事务
* Query 查询语句,返回结果
* Criteria  条件

## hibernate 会话

Session的主要功能 为 持久实体类 提供创建、读取、删除、的操作

### 映射实例的状态

1. 瞬时状态

    新的持久化实例，不关联session 且不关联 数据库
2. 持久状态

    关联session，不关联数据库
3. 托管状态

    关闭session 的持久化实例的状态

### Session接口方法

返回值 | 方法 | 说明
-|-|-
boolean | isConnected() | 检测session 是否连接
boolean | isDirty() | 判断 session 是否  必须与数据库同步更改
boolean | isOpen() | 检测session 是否开启
Transaction | beginTransction() | 开始，并返回关联事务对象
Transaction | getTransaction() | 获取该session关联的事务
void | cancelQuery() | 取消当前查询执行
void | clear() | 清除该会话
Connection | close() | 释放，清理jdbc 结束该会话
Query | createQuery(String querySting) | HQL查询字符创建新实例
SQLQuery | crateSQLQuery(String queryString) | SQL 查询 实例
void | delete(Object obj) |  从数据库中删除持久实例
void | delete(String entityName, Object object) | 从数据库中删除持久实例
Serilizable | save() | 分配生成表示， 保持 瞬时状态实例
void | saveOrUpdate(Object obj) | 保存或更新持久实例
void | update(Object obj) | 更新 托管状态下 的持久化实例
void | update(String eneityName,Object obj) | 更新 托管状态下 的持久化实例
Criteria | createCriteria(Class persistentClass) | 为指定的实体类的超超类创建一个新的 Criteria实例
Criteria | createCriteria(String eneityName) | 为给定的实体类创建一个新的 Criteria实例
Serializable | getIdentitier(Object obj) | 返回实体类关联会话的标识符
Query | crateFilter(Object collection,String QueryString) | 为过滤符创建新实例
Session | get(String entityName, Serializable id) | 返回指定名称，且带有表示的 实例
SessionFactory | getSessionFactory() | 获取创建该会话的工厂
void | refresh(Object obj) | 从基本数据库中重新读取实例状态

## Hibernate 映射类型

[连接](https://www.w3cschool.cn/hibernate/fzum1iem.html)

## ORM

[连接](https://www.w3cschool.cn/hibernate/wxm91ies.html)

### 集合映射

### 关联映射

### 组件映射

## hibernate的工作原理

  封装实现了对象与表的映射,即可以直接向数据库存储java对象，直接从数据库中取Java对象(高度自动化)

  1. 引入jar包
  2. POJO对象
  3. 配置文件 hibernate.cfg.xml
  4. hibernate映射文件
  5. hibernate方法

    * sessionFactory 获取session对象
    * 创建transaction对象 开启事务
    * session对象操作数据
    * 提交事务

  POJO: Plain Old Java Object  简单的java对象

### 目录结构

```html
src/
  com.wb/
    .pojo/
      User.java
      User.hbm.xml      //映射文件,与pojo名字要对应
    .test/
      HelloHibernate.java
      HibernateUtil.java  //获取session的公共方法
                          //不是 application里面的session
hibernate.cfg.xml         //hibernate配置文件
```

### 代码实现

#### User.java

要用到的属性封装到对象中  POJO

```java
package com.wb.po;

public class User {
  private Integer id;
  private String loginName;
  private String password;
  private String name;

  public Integer getId() {
    return id;
  }
  public void setId(Integer id) {
    this.id = id;
  }

  public String getLoginName() {
    return loginName;
  }
  public void setLoginName(String loginName) {
    this.loginName = loginName;
  }

  public String getPassword() {
    return password;
  }
  public void setPassword(String password) {
    this.password = password;
  }

  public String getName() {
    return name;
  }
  public void setName(String name) {
    this.name = name;
  }
  public User() {
    super();
  }
  public User(Integer id, String loginName, String password, String name) {
    super();
    this.id = id;
    this.loginName = loginName;
    this.password = password;
    this.name = name;
  }
}
```

#### User.hbm.xml

对应 对象的映射配置

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE hibernate-mapping PUBLIC
"-//Hibernate/Hibernate Mapping DTD 3.0//EN"
"http://hibernate.sourceforge.net/hibernate-mapping-3.0.dtd">
<!-- 映射配置对应的文本类型 -->
<hibernate-mapping>
  <class name="com.wb.po.User" table="t_user">
  <!-- POJO  对应的表 -->
  
    <id name="id" type="integer" column="t_id">
    <!-- id表示主键 -->
      <generator class="identity"></generator>
      <!-- identity 主键的生成方式 -->
    </id>

    <property name="loginName" type="string" column="t_login_name"></property>
    <property name="password" type="string" column="t_password"></property>
    <property name="name" type="string" column="t_name"></property>
    <!-- 属性名对应的列名 -->
  </class>
</hibernate-mapping>
```

##### 主键的生成方式

type | 方式
-|-
identity | 自动生成主键(Oracle不支持)
sequence | Oracle 用序列生成id主键
native | 根据配置文件中方言使用identity还是sequence
increment | 不常用 (增量、增加)
assigned | 不常用，手动生成id

#### hibernate.cfg.xml  配置文件

hibernate 的配置文件,同样也要放在 src目录下面

```xml
<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE hibernate-configuration PUBLIC
"-//Hibernate/Hibernate Configuration DTD 3.0//EN"
"http://hibernate.sourceforge.net/hibernate-configuration-3.0.dtd">
<!-- hibernate配置文件必须的 doctype 声明这是什么文本类型 -->


<hibernate-configuration>
  <session-factory>

    <property name="connection.url">jdbc:mysql://10.20.2.9:3306/test</property>
    <property name="connection.username">test</property>
    <property name="connection.password">test</property>
    <property name="connection.driver_class">com.mysql.jdbc.Driver</property>
    <!-- 配置数据库连接信息 -->

    <property name="dialect">org.hibernate.dialect.FirebirdDialect</property>
    <!-- 方言，  应该是对不同的数据库 有不同的方言，在这里定义就可以让hibernate通过hql生成对应的sql -->

    <property name="hibernate.show_sql">true</property>
    <!-- 是否在控制台显示sql  true 为显示 -->

    <mapping resource="com/wb/po/User.hbm.xml"></mapping>
    <!-- 关联映射文件 -->

  </session-factory>
</hibernate-configuration>
```

#### HibernateUtil.java

获取 hibernate session对象的公共方法

```java
public class HibernateUtil {
  private static Configuration conf;
  private static SessionFactory factory;
  static {
    conf = new Configuration();
    //装载配置文件

    conf.configure();
    //装载 在hibernate.cfg.xml中配置的映射文件  
    //conf.configure(new File("abc.xml"));      装载指定映射文件

    factory = conf.buildSessionFactory();
    //创建SessionFactory
  }
  //定义公共方法  获取  hibernate的session对象
  public static Session openSession(){
    return factory.openSession();
  }
}
```

#### HelloHibernate.java

```java

public class HelloHibernate {

  public void add(){
    User user = new User();
    user.setLoginName("weiBin");
    user.setName("伟斌");
    user.setPassword("123");

    Configuration conf = new Configuration();
    conf.configure();
    SessionFactory factory = conf.buildSessionFactory();
    Session session = factory.openSession();
    //获取session对象
    Transaction tx = session.getTransaction();
    //获得事务
    tx.begin();
    //开启事务

    session.save(user);
    //新增

    tx.commit();
    //提交事务

    session.close();
    //关闭session
  }

  public void delete(){
    Session session = HibernateUtil.openSession();
    User user = new User();
    user.setId(5);

    Transaction tx = session.beginTransaction();
    //开启事务  简写

    session.delete(user);
    //删除
    tx.commit();
    session.close();
  }
  public void upDate(){
    User user = new User();
    user.setId(3);
    user.setLoginName("ssh");
    user.setPassword("321");
    user.setName("xf");

    Session session = HibernateUtil.openSession();
    Transaction tx = session.beginTransaction();
    session.update(user);
    //更改
    tx.commit();
    session.close();
  }
  @Test
  public void select(){
    Session session = HibernateUtil.openSession();
    Query query = session.createQuery("from User");
    List<User>userList = query.list();

    for(User user : userList){
      System.out.println(user.getId()+"|"+user.getName()+"|"+user.getPassword());
    }
    session.close();
  }
}
```

### many-to-one  表关联  TODO 待补充

在 主表中  引入  附表类，  同时也在  附表中引入主表的类
且 get set

附表   对应的 在映射文件中配置  

```xml
<many-to-one name="main" class="main" column="main_fk">
```

## Hibernate注释

### 使用注解的环境需求

1. jdk > 5.0
2. hibernate 3.x

### 注解

注解 | 含义 | special
-|-|-
@Entity | 实体bean | 必须有 空构造
@Table(name="")  | 表名  |
@Id | 主键
@GeneratedValue | 主键生成策略
@Column | 指定某一列的细节 | name(列名)、 length(列的长度) 、nullable(非空)、unique(唯一)

## HQL

### 查询语句DQL

#### FROM语句

  取出一个完整的持久化实例

```java
  String hql = "FROM Employee"; //这里也可以写从 classpath 开始的 路径加文件名
  Query query = session.createQuery(hql);
  List result = query.list();
```

#### AS语句

给类 添加 别名

```java
  String hql = "FROM Employee AS E";
  //也可以不用 AS  直接 "FROM Employee E"
  Query query = session.createQuery(hql);
  List results = query.list();
```

#### SELECT语句

  取出持久化实例的 字段

```java
  String hql = "SELECT E.firstName From Employee E";
  Query query = session.createQuery(hql);
  List result = query.list();
```

#### WHERE语句

  添加条件

```java
  String hql = "FROM Employee E WHERE E.id = 10";
  Query query = session.createQuery(hql);
  List result = query.list();
```

#### ORDER By语句

  查询结果排序

```java
  String hql = "FROM Employee E WHERE E.id > 10 ORDER By E.salary DESC , E.age DESC"
  Query query = session.createQuery(hql);
  List result = query.list();
```

#### GROUP BY语句

在工资表中查找出某人 的总工资

将 相同的名字 整合到一组，  如下返回的是 某firstName - 此firstName对应的 salary的总和  

```java
  String hql = "SELECT  SUM(E.sqlary), E.firstName FROM Employee E" + "GROUP BY E.FirstName ";
  Query query = session.createQuery(hql);
  List result = query.list();
```

#### 聚合方法

方法 | 功能
-|-
avg() | 平均值
max() | 最大值
min() | 最小值
sum() | 总和
count() | 出现次数

#### 命名参数

```ajva
String hql = "FROM Employee E WHERE E.id = :employee_id";
Query query = session.createQuery(hql);
query.setParamter("employee_id",10);
List results = query.list();
```

#### distinct关键字

只计算 行  中的唯一值

```java
  String hql = "SELECT count(distinct E.firstName) From Employee E;
  Query query = session.createQuery(hql);
  List result = query.list();
```

#### 分页查询

返回值 | 方法 | 功能
-|-|-
Query | setFirstResult(int startPosition) | 通过设置 结果集中起始行行号
Query | setMaxResults(int maxResult) | 设置返回的行数

```java
String hql  = "FROM Employee";
Query query = session.createQuery(hql);
query.setFirstResult(1);
query.setMaxResults(10);
List results = query.list();
```

### 数据库操纵语言DML

#### UPDATE

```java
String hql = "UPDATE Employee set Salary = :salary" + "WHERE id = :employee_id";
Query.query = session.createQuery(hql);
query.setParameter = ("salary","999999");
query.setParameter = ("employee_id",1811109);
int result = query.executeUpdate();
System.out.println("update操作影响了" + result + "行");
```

#### INSERT语句

```java
String hql = "INSERT INTO Employee(firstName, lastName, salary)" + "SELECT firstName, LastName, salary FROM Employee";

Query query = Session.createQuery(hql);
int resut = query.executeUpdate();
System.out.println("insert操作影响了" + result + "行");
```

#### DELETE 语句

```java
String hql = "DELETE FROM Employee" + "WHERE id = :employee_id";
Query query = session.createQuery(hql);
query.setParameter("employee_id",1234);
int result = query.executeUpdate();
System.out.println("delete操作影响了" + result + "行");
```
