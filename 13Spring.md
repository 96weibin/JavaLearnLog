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
    //根据配置文件 UseBean 设置的  property name 是hello
    //所以在执行到这个 UseBean类的时候  会执行  setHello 方法
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
<beans xmlns="http://www.springframework.org/schema/beans"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:context="http://www.springframework.org/schema/context"
xmlns:tx="http://www.springframework.org/schema/tx"
xsi:schemaLocation="http://www.springframework.org/schema/beans 
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
    //获取配置文件
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
   在 xml中需要多次getBean的标签添加属性	scope="prototype"

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

  init-Method 		用于指定初始化方法
  destroy-method 	用于指定销毁方法 (仅适用于 singleton模式)


#### DI依赖注入（建立关系）

Spring 是具有IoC特性的框架，
Spring容器通过依赖注入DI   建立起对象、组件、bean之间的关系

* 两种方式

  1. setter方式注入
  2. 构造方式注入



## 注解方式配置

1. 在 配置文件中添加  如下代码 自动扫描组件
```xml
<context:component-scan base-package="com.wb.demo1"></context:component-scan>
```

2. 注解分类 

  1. 扫描Bean组件的注解

    注解 | 含义
    -|-
    @Service | Service业务组件
    @Controler | Action控制组件
    @Respository | DAO数据访问组件
    @Component | 其他组件

  @Service 默认生成的 bean 的id 是  类名首字母小写
  也可以  
  @Service('otherName')  更改生成bean的名字

  添加@Service就相当于添加  xml <id="" class="">  从而可以被 ac getBean

  添加 


  2. 依赖注入的注解

    注解 | 含义
    -|-
    @Resource |  JDK提供 按名称 @Resource(name="id名") 自动装配 
    @AutoWired | Spring提供 按名称自动装配	set
    @Autowired | 
    @Qualifier | @Qualifer("id名")
    自动装配 | 在配置xml中 声明bean？
    

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
    @Scope | 等价于 <bean Scope="">
    @PostConstruct | 等价于<bean init-method="">
    @PreDestory | 等价于 <bean destory-method="">


## AOP （Aspect Oriented Programming）

面向切面    记录日志功能  属于 切面功能


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

<!-- 在配置文件  beans中  多了个 xmlns:aop="http://www.springframework.org/schema/aop" 属性 -->

<bean id="optlogger" class="com.wb.aop.Optlogger"></bean>

<aop:config>
  
    <aop:pointcut expression="execution(* com.service.*.*(..)*)" id="servicepointcup"/>
    <!-- 设置切入点  experession  切入点表达式 -->	

  <aop:aspect id="loggeraspect" ref="optlogger">
  <!-- 配置切面bean -->

    <aop:before method="logger" pointcut-ref="servicepointcup"/>
    <!-- 采用before通知的方式 -->

  </aop:aspect>
</aop:config>
 </beans>
```

#### 通知方式

 通知方式 | 功能
 <aop:before> | 在调用之前执行，不会阻止后续执行，
 <aop:after-returning> | 方法调用执行完毕执行
 <aop:after > | 在目标方法调用之后执行，  正常、异常都执行
 <aop:after-throwing> | 异常通知
 <aop:around> | 环绕通知

### aop注解配置

在xml 中添加  

```xml
<aop:aspectj-autoproxy/>
```

在切面组件中使用

```java
@Aspect		//	切面
@Pointcut		//切入点
@Before、 @After、@AfterReturing、@AfterThrowing、@Around
```


//TODO		待补充

## Spring对数据库访问技术的支持

### Spring JDBC

### Spring Hibernate
