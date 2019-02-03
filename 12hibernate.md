# Hibernate

  封装的jdbc与SQL的**数据访问层**框架  或 **持久层**框架

  持久层 ： 数据库之前,将数据存储到数据库

## hibernate的工作原理

  封装实现了对象与表的映射,即可以直接向数据库存储java对象，直接从数据库中取Java对象(高度自动化)

  1. 引入jar包
  2. 配置文件 hibernate.cfg.xml
  3. hibernate映射文件
  4. hibernate方法
    1. 获取session对象
    2. 创建transaction对象
        session对象操作数据

  POJO: Plain Old Java Object  简单的java对象

## 增删改查


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
  <!-- name对象的目录  table对应的表 -->
  
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
		conf.configure();
		factory = conf.buildSessionFactory();
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

		Transaction tx = session.getTransaction();
		tx.begin();
		
		session.save(user);
    //新增
		tx.commit();
		session.close();
	}

	public void delete(){
		Session session = HibernateUtil.openSession();
		User user = new User();
		user.setId(5);
		
		Transaction tx = session.beginTransaction();
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


### many-to-one  表关联

在 主表中  引入  附表类，  同时也在  附表中引入主表的类
且 get set


附表   对应的 在映射文件中配置  

<many-to-one name="main" class="main" column="main_fk">








	


