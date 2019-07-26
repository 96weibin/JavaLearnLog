# Spring MVC

## 一、SpringMVC基础部分

### SpringMVC的原理

  **SpringMVC**围绕 dispatcher**Servlet**来设计的、这个Servlet会把请求分发给各个处理器。

  **处理器**注解了 @Controller 和 @RequestMapping的类和方法

  **设计原则**：对拓展开放、对修改闭合。

### 配置 Spring Web MVC

#### 第一步、 配置 web.xml

* web.xml

  ```xml
  <!-- 类似servlet的设定 -->
  <web-app>
      <servlet>
          <servlet-name>example</servlet-name>
          <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
          <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>classpath:springMvc.xml</param-value>
            <!-- 设置 SpringMVC配置文件的位置 -->
          </init-param>
          <load-on-startup>1</load-on-startup>
          <!-- 服务器启动时加载 -->
      </servlet>

      <servlet-mapping>
          <servlet-name>example</servlet-name>
          <url-pattern>*do</url-pattern>
          <!-- *.do   的请求    都会被 example的 DispatcherServlet处理 -->
      </servlet-mapping>
  </web-app>
  ```

##### classpath

1. classpath与classpath* 的区别

classpath | classpath*
-|-
classes目录中查找 | classes及其子目录

##### 补充

* web.xml中的一些其他标签

  ```xml
      <!-- 错误码跳转对应异常页面 -->
      <error-page>
        <error-code>404</error-code>
        <location>/pages/common/error.jsp</location>
      </error-page>
      <!-- 欢迎页 -->
      <welcome-file-list>
        <welcome-file>index.jsp</welcome-file>
      </welcome-file-list>
      <!-- session超时 默认分钟 -->
      <session-config>
        <session-timeout>600</session-timeout>
      </session-config>
      <!-- 过滤器 -->
      <filter>
        <filter-name>encodingFilter</filter-name>
        <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
        <init-param>
          <param-name>encoding</param-name>
          <param-value>UTF-8</param-value>
        </init-param>
      </filter>
      <filter-mapping>
        <filter-name>encodingFilter</filter-name>
        <url-pattern>/*</url-pattern>
      </filter-mapping>
  ```

#### 第二步 配置 SpringMvc.xml

  ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context"
    xmlns:aop="http://www.springframework.org/schema/aop"
    xmlns:tx="http://www.springframework.org/schema/tx"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-2.5.xsd
    http://www.springframework.org/schema/context
    http://www.springframework.org/schema/context/spring-context-2.5.xsd
    http://www.springframework.org/schema/aop
    http://www.springframework.org/schema/aop/spring-aop-2.5.xsd
    http://www.springframework.org/schema/tx
    http://www.springframework.org/schema/tx/spring-tx-2.5.xsd">

      <bean id="loginControl" class="com.wb.control.LoginControl"></bean>
      <!-- 声明bean -->
      <bean id="urlMapping" class="org.springframework.web.servlet.handler.SimpleUrlHandlerMapping">
        <property name="mappings">
          <props>
            <prop key="login.do">loginControl</prop>
            <!-- login.do 的请求会  被 loginControl处理 -->
          </props>
        </property>
      </bean>
      <!-- 视图分配器，  ModelAndView 返回的 字符串路径拼接 -->
      <bean id="viewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <property name="viewClass" value="org.springframework.web.servlet.view.JstlView"></property>
        <!-- 后缀 -->
        <property name="suffix" value=".jsp"></property>
        <!-- 前缀 -->
        <property name="prefix" value="/WEB-INF/page/"></property>
      </bean>
    </beans>
  ```

#### 第三步 LoginControl

```java
package com.wb.control;

public class LoginControl implements Controller {

  @Override
  public ModelAndView handleRequest(HttpServletRequest req,
      HttpServletResponse res) throws Exception {
    // 获取  request的参数
    String email = req.getParameter("email");
    String password = req.getParameter("password");
    //绑定返回值 map
    ModelMap map = new ModelMap();

    if("1.1".equals(email)&& "123".equals(password)){
      // map 赋值
      map.put("msg", "log success :" + email);

      //modelAndView 跳转 ok路径,传递 map对象
      return new ModelAndView("ok",map);
    } else {
      map.put("msg", "登陆失败 ");
      return new ModelAndView("login",map);
    }
  }
}
```

## 二、 SpringMVC注解实现部分

* SpringMvc.xml

  ```xml
    <mvc:annotation-driven></mvc:annotation-driven>

    <!-- 配置自动扫描的包注册成bean  -->
    <context:component-scan base-package="eim.zwb">
      <!-- 包含 controller -->
      <context:include-filter type="annotation" expression="org.springframework.stereotype.Controller" />
      <!--
        SpringMVC 是围绕 servlet 处理请求的   MVC 框架中 C 从接收请求开始,调用  M 
        因为  M中不可能只做一个  数据库操作, 所以如果一个M中做多个数据库操作  就需要事务,进行回滚
        而 两个 Dao操作不能 封装到一个事务，所以  将  M 拆分为  DAO 与 Service

        Spring注解  @Service @Controler @Resource 应该是都会被扫描,
        这里  SpringMVC 只是C层  所以  扫描 Controller 
      -->
      <context:exclude-filter type="annotation" expression="org.springframework.stereotype.Service" />
      <context:exclude-filter type="annotation" expression="org.springframework.stereotype.Repository" />
    </context:component-scan>
  ```

* controller

  ```java
  @Controller //声明 controller
  @RequestMapping(value = "/demo")   //请求路径
  public class EmployeeControl {
    @Autowired      //DI注入
    public EmployeeService eservice;
    @Autowired
    public DepartmentService dservice;
    //登录
    @RequestMapping("/login") //子路径
    public String dologin(HttpServletRequest req) {   //servlet  req,res 返回字符串
      //do something ...
      return "url";
    }
  }
  ```

## SpcingMVC中的 拦截器 Interceptor

  拦截用户请求，并进行相应的处理 （权限验证、登陆验证）

### SpringMVC.xml中的配置

```xml
<mvc:interceptors>
  <!-- 日志拦截器 -->
  <mvc:interceptor>
    <mvc:mapping path="/**" />
    <mvc:exclude-mapping path="/static/**" />
    <bean class="拦截器类  路径" />
  </mvc:interceptor>
</mvc:interceptors>
```

* mvc:mapping 拦截器路径配置
* mvc:exclude-mapping 不需要 拦截的路径
* bean 拦截器类的路径

## 事务

对单表单个操作，使用默认事务即可，但是多表或多操作的时候，不能保证全部的操作都会正确，再对数据库进行操作，所以就需要 **事务处理**

因为没有办法在 将两个DAO 操作封装到一个事务，所以需要 将DAO与Service分开

### 事务的三种方式

1. 编程事务控制 (try catch)
2. 配置声明事务控制(xml)
3. 注解(@Transactional)

### 事务的参数与功能

参数名 | 功能 | demo
-|-|-
readOnly | 只读事务(**默认** 为读写事务) | @Transactional(readOnly=true)
rollbackFor | 异常回滚(当抛出对象中指定的错误类回滚) | @Transactional(rollbackFor={RuntimeException.class,Exception.class}) 退回某个 则不需要中括号
rollbackForClassName | 异常回滚(当抛出对象中指定的错误类名回滚) |@Transactional(rollbackForClassName={"runTimeException",...})
noRollbackFor | 不进行回滚(当抛出对象中指定的错误类不进行回滚) | @Transactional(onRollbackFor = {RuntimeException.class,Exception.class})
noRollbackForClassNAme | 不进行回滚(当抛出对象中指定的错误类名不进行回滚) | @Transactional(noRollbackForClassName={"runTimeException",...})
propagation | 传播行为(多个事务间关系) | @Transactional(propagation=Propagation.NOT_SUPORTED,readOnly=true)
isolation | 事务隔离等级,数据库有默认隔离等级，通常不用设置|
timeout | 设置超时秒 -1 永不超时 | @Transactional(timeout=-1)

#### 传播方式 参数含义

参数 | 功能 | demo
-|-|-
REQUIRED | (默认)如果有事务则加入事务，没有的话新建一个事务 | @Transactional(propagation=Propagation.REQUIRED)
NOT_SUPPORTED | 容器内某个方法不开启事务 | @Transactional(propagation=Propagation.NOT_SUPPORTED)
REQUIRES_NEW | 无论是否已经存在事务，有新的事务进来原来的挂起，执行新的事务，新的事务执行完毕，继续执行老的事务 |  @Transactional(propagation=Propagation.REQUIRES_NEW)
MANDATORY(强制、托管、命令) | 必须在 已有事务中执行 否则报错
NEVER | 必须在没有的事务中执行，否则报错
SUPPORTS | 如果其他bean调用这个方法，在其他bean中声明事务，就用事务，没有声明事务就不用事务

#### 事务隔离级别

参数 | 功能 | demo
-|-|-
READ_UNCOMMITED | 读取未提交数据(会出现脏读,不可重复读) | @Transactional(isolation = Isolation.READ_UNCOMMITTED)
READ_COMMITED | 读取已提交的数据(会出现幻读,不可重复读) | @Transactional(isolation = Isolation.READ_COMMITTED)
REPEATABLE_READ | 可重复读(会出现幻读) | @Transactional(isolation = Isolation.REPEATABLE_READ)
SERIALIZABLE | 串行化 | @Transactional(isolation = Isolation.SERIALIZABLE)

**脏读** : 一个事务读取到另一事务未提交的更新数据

**不可重复读** : 在同一事务中, 多次读取同一数据返回的结果有所不同, 换句话说,后续读取可以读到另一事务已提交的更新数据.

**可重复读**在同一事务中多次读取数据时, 能够保证所读数据一样, 也就是后续读取不能读到另一事务已提交的更新数据

**幻读** : 一个事务读到另一个事务已提交的insert数据

#### 不同数据库隔离等级的区别

*MYSQL* 默认隔离等级为  REPEATABLE_READ

*SQLSERVER* 默认隔离等级为 READ_COMMITTED

### 事务的注意点

1. 事务要用在 public 类、方法上 否则无效
2. 事务默认回滚 是遇到 RuntimeException

### MySQL默认事务的功能

当只写一个 @Transcational时 ： 读写事务、RuntimeException会回滚、隔离等级 REPEATABLE_READ、 传播方式REQUIRE

### java中异常

  ![异常等级图](http://96weibin-blog.oss-cn-beijing.aliyuncs.com/731178-20161015233821015-2049087584.jpg)

### SSH 中的事务

启用事务 需要在 xml的beans 中写

```xml
<beans xmlns:tx="http://www.springframework.org/schema/tx"
xsi:schemaLocation="http://www.springframework.org/schema/tx
 http://www.springframework.org/schema/tx/spring-tx-2.5.xsd">
```

ssh.xml

```xml
<bean id="txManager" class="org.springframework.orm.hibernate3.HibernateTransactionManager">
  <property name="sessionFactory" ref="mySessionFactory"></property>
</bean>

<tx:advice id="txAdvice" transaction-manager="txManager">
  <tx:attributes>
    <tx:method name="save*" propagation="REQUIRED"/>
    <tx:method name="update*" propagation="REQUIRED"/>
    <tx:method name="delete*" propagation="REQUIRED"/>
    <tx:method name="find*" read-only="true" propagation="NOT_SUPPORTED"/>
    <tx:method name="*" propagation="REQUIRED"/>
  </tx:attributes>
</tx:advice>
```

### 经典的事务

```java
Session session = factory.openSession();
Transaction tx = null;
try {
   tx = session.beginTransaction();
   // do some work
   ...
   tx.commit();
}
catch (Exception e) {
   if (tx!=null) {
      tx.rollback();
     }
    e.printStackTrace();
}finally {
   session.close();
}
```

### 事务注解

1. xml配置

    ```xml
    <bean id="txManager"class="org.springframework.orm.hibernate3.HibernateTransactionManager">
      <property name="sessionFactory"ref="mySessionFactory"></property>
    </bean>
    <tx:annotation-driven transaction-manager="txManager"/>
    ```

2. 在类的上面添加 注解

    ```java
    @Transactional(readOnly="true",propagation=Propagation.NOT_SUPPORTED)
    ```
