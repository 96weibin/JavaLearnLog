# Spring MVC

**SpringMVC**围绕 dispatcher**Servlet**来设计的、这个Servlet会把请求分发给各个处理器。

**处理器**注解了 @Controller 和@RequestMapping的类和方法

**设计原则**：对拓展开放、对修改闭合。

## 配置 Spring Web MVC

### 第一步、 新建 dispatcherServlet

* web.xml

```xml
<web-app>
    <servlet>
        <servlet-name>example</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <load-on-startup>1</load-on-startup>
    </servlet>

    <servlet-mapping>
        <servlet-name>example</servlet-name>
        <url-pattern>/example/*</url-pattern>
    </servlet-mapping>
</web-app>
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app version="2.5" xmlns="http://java.sun.com/xml/ns/javaee"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd">


  <!-- SpringMVC 配置servlet -->
  <!-- 配置 DispatcherServlet  将请求映射到对应的URl -->
  <servlet>
    <servlet-name>example</servlet-name>
    <!-- 指明的这个  配置servlet 叫做 example.servlet.xml   默认路径在 WEB-INF-->
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <load-on-startup>1</load-on-startup>
  </servlet>
  <servlet-mapping>
    <servlet-name>example</servlet-name>
    <url-pattern>/example/*</url-pattern>
     <!-- /example/*的请求    都会被 example的 DispatcherServlet处理 -->
  </servlet-mapping>
  
  
  
  <welcome-file-list>
    <welcome-file>index.jsp</welcome-file>
  </welcome-file-list>

  <session-config>
    <session-timeout>600</session-timeout>
  </session-config>

  <error-page>
    <error-code>400</error-code>
    <location>/pages/common/error.jsp</location>
  </error-page>

  <error-page>
    <error-code>404</error-code>
    <location>/pages/common/error.jsp</location>
  </error-page>

  <error-page>
    <error-code>405</error-code>
    <location>/pages/common/error.jsp</location>
  </error-page>

  <error-page>
    <error-code>500</error-code>
    <location>/pages/common/error.jsp</location>
  </error-page>
</web-app>

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
