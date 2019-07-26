# Spring

* IOC (inverse of Control)  反向控制

    对象的创建和使用由Spring容器来控制

* AOP (aspect oriented programming) 面向方面

xml配置文件与注解的作用：可以在不同的类内引入其他类、di注入，通过xml内配置 property 控制调用接口的时候是执行哪个实体类

bean 是什么： 初步理解  就是一个可以被 读写的  类

## helloWorld

  spring 通过配置文件，实现factory解耦的功能，

### 代码实现

#### HelloBean.java

接口

```java
public interface HelloBean {
  public abstract void sayHello();
}

```

#### EnHelloBean.java

接口的一个实现类

```java
public class EnHelloBean implements HelloBean {
  @Override
  public void sayHello() {
    System.out.println("hello the world!");
  }
  
}
```

#### ZhHelloBean.java

接口的另一个实现

```java
public class ZhHelloBean implements HelloBean {
  @Override
  public void sayHello() {
    System.out.println("世界你好");
  }
}
```

#### UseBean.java

实现对接口方法的调用

```java
public class UseBean {
  private HelloBean hello;
  //声明了  HelloBean这个 类型的  hello
  public void setHello(HelloBean hello){
    //根据配置文件 UseBean 设置的  property name 是 hello
    //而 hello 的  ref 是 zhhellobean 所以这里 执行的 hello 就是 zhhellobean
    //在执行到这个 UseBean类的时候  会自动执行  setHello 方法
    //从而 通过配置文件控制了   业务
    this.hello = hello;
  }
  public void show(){
    System.out.println("显示hello消息");
    hello.sayHello();
  }
  
}
```

#### applicationContext.xml

配置文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans
  xmlns="http://www.springframework.org/schema/beans"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:context="http://www.springframework.org/schema/context"
  xmlns:tx="http://www.springframework.org/schema/tx"
  xsi:schemaLocation="
  http://www.springframework.org/schema/beans
  http://www.springframework.org/schema/beans/spring-beans-2.5.xsd

  http://www.springframework.org/schema/context
  http://www.springframework.org/schema/context/spring-context-2.5.xsd

  http://www.springframework.org/schema/tx
  http://www.springframework.org/schema/tx/spring-tx-2.5.xsd">
 <!--创建Bean，有指定的id，对应的class-->

<bean id="usebean" class="com.wb.beans.UseBean">
  <property name="hello" ref="zhhellobean"></property>
    <!-- 当执行UseBean时,setHello  为 zhhellobean 即找到了  对应的类 -->
</bean>


<!-- 
  也可以用 name来定义名字，
  name与id的作用相同， 只是 name 允许存在 特殊字符
  <bean name="/login" class="com.wb.service.Login"></bean> 
  
-->


<bean id="enhellobean" class="com.wb.beans.EnHelloBean"></bean>
<bean id="zhhellobean" class="com.wb.beans.ZhHelloBean"></bean>

</beans>
```

#### Test.java

引入配置文件，通过 applicationContext 的 getBean方法  获取配置文件中对应的类

```java
public class Test {
    public static void main(String[] args){
    ApplicationContext ac = new ClassPathXmlApplicationContext("applicationContext.xml");
    //获取配置文件  默认路径  是 src 根目录，也可以通过 包名/xml名 来读取
    //例如 ： com/demo4/applicationContext.xml
        UserBean bean = (UserBean)ac.getBean("usebean");
        //根据配置文件获取bean
        bean.show();
        //执行bean的方法
  }
}
```

### 容器实例化的几种方法(获取appliction context)

容器实例化  就是 获取ac？  应用上下文

```java
    //根据在类中查找
public static void main(String[] arguments){
    private static final String CONFIGS = "com/wb/applicationContext.xml";
    //方式一
    ApplicationContext ac = new ClassPathXmlApplicationContext(CONFIGS);

    //方式二
    Resource resource = new ClassPathResource(CONFIGS);
    BeanFactory ac = new XmlBeanFactory(resource);



    UseBean bean = (UseBean)ac.getBean("usebean");
    bean.show();
}
```

```java
//在磁盘上查找
public static void main(String[] arguments){
    private static final String CONFIGS = "D:/applicationContext.xml";
    //方式一
    ApplicationContext ac = new FileSystemXmlApplicationContext(CONFIGS);

    //方式二
    Resource resource = new FileSystemResource(CONFIGS);
    BeanFactory ac = new XmlBeanFactory(resource);



    UseBean bean = (UseBean)ac.getBean("usebean");
    bean.show();
}

```

### Spring容器对Bean的管理

#### bean构造器的执行时机

配置文件中对应的 bean  默认的在 获取ApplicationContext的时候 会执行其中的构造器

可以给 xml中的 bean标签添加属性 lazy-init="true"

让其构造器延迟执行，在调用的时候(ac.getBean("xxx"))  构造器才执行

也可以在 xml中  beans标签 中添加属性   default-lazy-init="true"

#### bean创建的 单列模式

在Test中 以不同的变量名 声明 两个相同的getBean(""), 进行比较

```java
public class Test {
  public static final String[] CONFIGS = {"applicationContext.xml"};
  public static void main(String[] args){
    ApplicationContext ac = new ClassPathXmlApplicationContext(CONFIGS);
    MyBean bean1 = (MyBean)ac.getBean("mybean");
    MyBean bean2 = (MyBean)ac.getBean("mybean");
    System.out.println(bean1);
    System.out.println(bean1 == bean2); //true
        //通过结果发现 多次 getBean  生成的还是同一个
  }
}
```

* 解决方法
   在 xml中需要多次getBean的标签添加属性scope="prototype"

* scope属性  
  
  在web项目设置创建的bean对象的生命周期和rquest、session

  取值 | 作用
  -|-
  request | bean的生命周期和request的生命周期相同
  session | 和session的声明周期相同
  global session  | 生命周期与应用相同
  singleton | 单例
  prototype | 原型

#### bean对象的初始化和销毁

  ac.getBean() 即为初始化，ac.close()即为 销毁

  init-Method 用于指定初始化方法

  destroy-method 用于指定销毁方法 (仅适用于 singleton模式)

#### DI依赖注入（建立关系）

Spring 是具有IoC特性的框架，
Spring容器通过依赖注入DI   建立起对象、组件、bean之间的关系

* 两种方式

  1. setter方式注入(如上 的方式就是 setter)
  2. 构造方式注入(等着在研究吧)

##### setter 方式注入多种多个值

```xml
<bean id="b" class="com.demo4.B"></bean>
<bean id="a" class="com.demo4.A">
  <!-- 注入 bean -->
  <property name="b" ref="b"></property>
  <!-- 注入字符串 value可以写在 行内，也可以写在标签内 value 标签-->
  <property name="c" value="value"></property>
  <!-- 注入list -->
  <property name="city">
    <list>
      <value>北京</value>
      <value>上海</value>
    </list>
  </property>
  <!-- 注入set -->
  <property name="name">
    <set>
      <value>tom</value>
      <value>tony</value>
    </set>
  </property>
  <!-- 注入map -->
  <property name="book">
    <map>
      <entry>Spring框架开发</entry>
      <entry>Spring框架开发</entry>
    </map>
  </property>
  <!-- 注入 properties 连接数据库信息 -->
  <property name="params">
    <props>
      <prop key="username">root</prop>
      <prop key="password">root</prop>
      <prop key="driverClass">com.mysql.jdbc.Driver</prop>
      <prop key="url">jdbc:mysql://localhost3306/test</prop>
    </props>
  </property>
</bean>
```

## 注解方式配置

1. 在 配置文件中添加  如下代码 自动扫描组件

    ```xml
      <context:component-scan base-package="com.wb.demo1"></context:component-scan>
    ```

2. 注解分类

    * 扫描Bean组件的注解

      注解 | 含义
      -|-
      @Service | Service业务组件
      @Controller | Action控制组件
      @Respository | DAO数据访问组件
      @Component | 其他组件

    @Service 默认生成的 bean 的id 是  类名首字母小写也可以  
    @Service('otherName')  更改生成bean的名字

    添加@Service就相当于添加  xml <id="" class="">  从而可以被 ac getBean 添加

    * 依赖注入的注解

      一个接口有多个   实现类，通过依赖注入 name 值，决定使用哪个 实现类

      @Resouce

      注解 | 含义
      -|-
      @Resource |  JDK提供 按名称 @Resource(name="id名") 自动装配
      @AutoWired | Spring提供 按名称自动装配  set
      @Qualifier | @Qualifer("id名")

    @Resource 如果仅有额外的一个 bean可用的时候不需要写name
    有多个的时候    @Resource(name="id");  确定 依赖注入的是哪个 bean
    知道是哪个bean后  注解 还会自动 set且执行 set  
    这样声明的一个 接口就直接实现成某个 实现类

    @AutoWired 用于只有一个额外的 bean 的时候 如果有多个需要
    @Qualifier 来声明是哪个

    ```java
      @AutoWired
      @Qualifier("beanName")
      private HelloBean hello;
    ```

3. 其他注解

    设置bean的一些属性

    注解 | 含义
    -|-
    @Scope | 等价于 \<bean Scope="">
    @PostConstruct | 等价于 \<bean init-method="">
    @PreDestory | 等价于 \<bean destory-method="">

## AOP （Aspect Oriented Programming）

面向切面    记录日志功能  属于 切面功能

### UserService.java

```java
public interface UserService {
  public void update();
  public void delete();
  public void save();
}
```

### UserServiceImple.java

```java
package com.wb.service;

public class UserServiceImpl implements UserService {
  @Override
  public void update() {
    System.out.println("更新用户信息");
  }
  @Override
  public void delete() {
    System.out.println("删除用户信息");
  }
  @Override
  public void save() {
    System.out.println("保存用户信息");
  }
}
```

### opt.properties

unicode 编码设置的执行 对应方法的时候  输出对应的描述

```properties
com.wb.service.UserServiceImpl.update=\u7528\u6237\u66F4\u65B0\u64CD\u4F5C
com.wb.service.UserServiceImpl.save=\u7528\u6237\u4FDD\u5B58\u64CD\u4F5C
com.wb.service.UserServiceImpl.delete=\u7528\u6237\u5220\u9664\u64CD\u4F5C
```

### OptLogger.java

```java
public class OptLogger {
  public Object logger(ProceedingJoinPoint pjp) throws Throwable{
    //pjp  只支持 around 模式
    Object obj = pjp.proceed();
    // 通过pjp获取执行的方法名，类名
    String methodName = pjp.getSignature().getName();
    String clazzName = pjp.getTarget().getClass().getName();

    // 读取 配置文件
    PropertiesUtil.getInstance("com/wb/aop/opt.properties");
    String key = clazzName + "." + methodName;

    //读取  properties 进行输出
    System.out.println("TODO" + PropertiesUtil.getProperty(key));

    //直接输出  类名、 方法名
    System.out.println("执行" + clazzName + "的" + methodName + "方法");

    return obj;
  }
}
```

### aop.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:context="http://www.springframework.org/schema/context"
xmlns:aop="http://www.springframework.org/schema/aop"
xsi:schemaLocation="http://www.springframework.org/schema/beans
http://www.springframework.org/schema/beans/spring-beans-2.5.xsd
http://www.springframework.org/schema/context
http://www.springframework.org/schema/context/spring-context-2.5.xsd
http://www.springframework.org/schema/aop
http://www.springframework.org/schema/aop/spring-aop-2.5.xsd">
  
  <!-- 普通的bean -->
  <bean id="userserivce" class="com.wb.service.UserServiceImpl"></bean>

  <!-- 切面bean -->
  <bean id="optlogger" class="com.wb.aop.OptLogger"></bean>
  <aop:config>
    <!-- 配置切入点 -->
    <aop:pointcut id="servicepointcut" expression="execution(*  com.wb.service.*.*  (..))" />
    <!--
    不限定返回类型      com.wb.service包下面的所有方法     (不限定参数类型)
    -->

    <!-- 配置切面 bean -->
    <aop:aspect id="aspectbean" ref="properties">

      <!-- 前置通知
      <aop:before method="mybefore" pointcut-ref="servicepointcut1"/> 
      -->

      <!-- 后置通知
      <aop:after-returning method="myafterReturning" pointcut-ref="servicepointcut1"/>  
      -->
      <!-- 。。。。。 -->
    </aop:aspect>
  </aop:config>
</beans>
```

#### 通知方式

通知方式 | 功能
-|-
\<aop:before> | 在调用之前执行（如果不抛出异常，不会阻止后续执行）
\<aop:after-returning> | 方法调用执行完毕执行（无异常执行）
\<aop:after > | 在目标方法调用  之后执行（正常、异常都执行）
\<aop:after-throwing> | 异常通知  目标方法调用发生异常 之后执行
\<aop:around> | 环绕通知,在目标方法调用 之前和之后执行

#### 切入点表达式

//TODO 待了解

### 记录异常日志

添加jar log4j

### aop注解配置

在spring配置xml 中添加 AoP 注解配置

```xml
<aop:aspectj-autoproxy/>
```

在切面组件中使用

```java
@Aspect     //切面
@Pointcut   //切入点
@Before、 @After、@AfterReturing、@AfterThrowing、@Around
```

#### Spring 的 Ioc 与 Aop 通过注释实现

* schema.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:context="http://www.springframework.org/schema/context"
xmlns:aop="http://www.springframework.org/schema/aop"
xsi:schemaLocation="http://www.springframework.org/schema/beans
http://www.springframework.org/schema/beans/spring-beans-2.5.xsd
http://www.springframework.org/schema/context
http://www.springframework.org/schema/context/spring-context-2.5.xsd
http://www.springframework.org/schema/aop
http://www.springframework.org/schema/aop/spring-aop-2.5.xsd">

  <context:component-scan base-package="com.wb"></context:component-scan>
  <aop:aspectj-autoproxy/>
</beans>
```

* Service

  ```java
  package com.wb.service;
  public interface UserService {
    public void regist();
    public void update();
  }
  ```

  ```java
  package com.wb.service;
  @Service("userService") //为什么  声明service 要放在  impl上
  public class UserServiceImpl implements UserService {
    private UserDao userDao;

    @Resource(name="jdbcUserDao")
    public void setUserDao(UserDao userDao) {
      this.userDao = userDao;
    }

    @Override
    public void regist() {
      System.out.println("Service##用户注册处理");
      userDao.save();
    }

    @Override
    public void update() {
      System.out.println("Service##用户修改个人信息处理");
      userDao.update();
    }
  }
  ```

* DAO

  ```java
  package com.wb.dao;

  public interface UserDao {
    public void save();
    public void update();
  }
  ```

  ```java
  package com.wb.dao;

  @Service("jdbcUserDao")  //声明 service bean 也是放在 impl
  public class JDBCUserDAO implements UserDao {
    @Override
    public void save() {
      System.out.println("jdbc 保存用户信息");
    }
    @Override
    public void update() {
      System.out.println("jdbc 更新用户信息");

    }
  }
  ```

* aop
  * opt.properties

  ```properties
    com.wb.service.UserServiceImpl.update=\u7528\u6237\u66F4\u65B0\u64CD\u4F5C
    com.wb.service.UserServiceImpl.regist=\u7528\u6237\u4FDD\u5B58\u64CD\u4F5C
  ```

  * PropertiesUtil.java

  ```java
  package com.wb.util;

  public class PropertiesUtil {
    static Properties props = new Properties();

    private PropertiesUtil(){}

    public static Properties getInstance(String path) throws IOException{
      props.load(PropertiesUtil.class.getClassLoader().getResourceAsStream(path));
      return props;
    }
    public static String getProperty(String key){
      String val = "";
      if(props != null){
        String prop = props.getProperty(key);
        if(prop != null){
          val = prop;
        }
      }
      return val;
    }
  }
  ```

  * OptLogger.java

  ```java
  package com.wb.aop;

  @Component("optLogger")
  @Aspect
  public class OptLogger {

    @Pointcut("within(com.wb.service..*)")  //切入点
    public void servicePointcut(){};

    @Around("servicePointcut()")  //log方式
    public Object logger(ProceedingJoinPoint pjp) throws Throwable{
      //pjp  只支持 around 模式

      Object obj = pjp.proceed();
      String methodName = pjp.getSignature().getName();
      String clazzName = pjp.getTarget().getClass().getName();

      PropertiesUtil.getInstance("com/wb/aop/opt.properties");

      String key = clazzName + "." + methodName;
      System.out.println("key----" + key);
      System.out.println("TODO---" + PropertiesUtil.getProperty(key));
      return obj;
    }
  }
  ```

* Test.java

    ```java
    package com.wb.test;

    import com.wb.service.UserService;

    public class Test {
      public static void main(String[] args){
        ApplicationContext ac = new ClassPathXmlApplicationContext("schema.xml");
        UserService us = (UserService) ac.getBean("userService");
        us.regist();
        us.update();
      }
    }
    ```

## Spring对数据库访问技术的支持

### Spring JDBC

* 需要的jar

commons-dbcp.jar、commons-collections.jar、commons-pool.jar

#### 配置连接池

```xml
<!-- dao注入连接池 -->
<bean id="jdbcUserDao" class="com.wb.dao.JDBCUserDAO">
    <!--注意：只能写dataSource，别的名字不行-->
    <property name="dataSource" ref="dataSource"></property>
</bean>
<!-- 连接池 -->
  <bean id="dataSource" destroy-method="close" class="org.apache.commons.dbcp.BasicDataSource">
    <!-- destory-method 销毁 dataSource的方法，可以及时回收，非必需 -->

    <property name="driverClassName" value="com.mysql.jdbc.Driver"></property>
    <property name="url" value="jdbc:mysql://10.20.2.9/study"></property>
    <property name="username" value="test"></property>
    <property name="password" value="test"></property>
    <property name="maxActive" value="10"></property>
    <!-- 连接池最多同时创建  maxActive个 connection对象 -->

    <property name="initialSize" value="2"></property>
    <!-- initialSize 连接池 初始化时  connection的个数 -->

    <property name="minIdle" value="2"></property>
    <!-- 最小空闲数量， 空闲时 connection对象的最小数量 -->

    <property name="maxIdle" value="3"></property>
    <!-- 最大空闲数量，空闲时connection对象的最大数量 -->
  </bean>
```

#### jdbcUserDAO

```java
package com.wb.dao;

/*@Repository("jdbcUserDao")
@Resource(name="dataSource")*/
public class JDBCUserDAO extends JdbcDaoSupport implements UserDao {
  //继承 JdbcDaoSuport  完成 dataSource的注入
  /*
  * 如果不继承则可以通过  如下实现  原始的注入。
  * private JdbcTemplate template;
  * pbulic void setDataSource(DataSource dataSource){
  *   template = new JdbcTemplate(dataSource);
  * }
  **/

  @Override
  public void save(User user) {
    System.out.println("jdbc 保存用户信息");
    String sql = "insert into d_user " +
        "(email,nickname,password," +
        "user_integral,is_email_verify," +
        "email_verify_code,last_login_time,last_login_ip) " +
        "values (?,?,?,?,?,?,?,?)";
    this.getJdbcTemplate().update(sql,new Object[]{
        user.getEmail(),
        user.getNickname(),
        user.getPassword(),
        user.getUserIntegral(),
        user.isEmailVerify()?"Y":"N",
        user.getEmailVerifyCode(),
        user.getLastLoginTime(),
        user.getLastLoginIp()
    });
  }

  @Override
  public void update(User user) {
    System.out.println("jdbc 更新用户信息");
    String sql = "update d_user set email=?," +
        "nickname=?," +
        "password=?," +
        "user_integral=?," +
        "is_email_verify=?," +
        "email_verify_code=?," +
        "last_login_time=?," +
        "last_login_ip=? " +
        "where id=?";
    this.getJdbcTemplate().update(sql,new Object[]{
        user.getEmail(),
        user.getNickname(),
        user.getPassword(),
        user.getUserIntegral(),
        user.isEmailVerify()?"Y":"N",
        user.getEmailVerifyCode(),
        user.getLastLoginTime(),
        user.getLastLoginIp(),
        user.getId()
    });
  }
  public void deleteById(int id){
    String sql = "delete form d_user where id=?";
    this.getJdbcTemplate().update(sql,new Object[]{id});
  }
  @Override
  public User findById(int id) {
    String sql = "select * from d_user where id=?";
    User u = (User) this.getJdbcTemplate().queryForObject(sql, new Object[]{id},new UserMapper());
    System.out.println(u);
    return u;
  }

  @SuppressWarnings("unchecked")
  @Override
  public List<User> findAll() {
    String sql = "select * from d_user";
    List<User> list = this.getJdbcTemplate().query(sql, new UserMapper());
    return list;
  }

  @Override
  public int count() {
    String sql = "select count(*) from d_user";
    return this.getJdbcTemplate().queryForInt(sql);
  }

}
```

//TODO this.getJdbcTemplate()对数据的操作的几种方法待补充

### Spring Hibernate
