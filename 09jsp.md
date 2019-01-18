# Jsp (java server page)

    jsp文件包含前端页面与java、不需要编译，当客户访问某个jsp
    服务器会将这个jsp转换成 .java文件(servlet)

## jsp文件组成

1. html、css、js
2. java代码

    1. <% java代码 %>
    2. <%= java表达式 %>
3. 指令

    <%@ 指令名 属性名=属性值%>

    * page指令

        * import属性
            <%@page import="java.util.*,java.text.*"%>
        * contentType
            等价于response.setContentType()
        * pageEncoding
            告诉jsp文件保存时的编码
4. 隐含对象

    * out
    * request
    * response
## jsp文件转换成.java文件

* html转换为jsp
    放到service()里面使用out.write()输出
* java代码段
    放到service()方法里

## 写一个jsp文件





第五章

### el表达式

* jstl  

    java standard taglib  （java 标准 标签库）

#### el 表达式的基本语法

新建**bean**实体类、get&set,之后实例化对象 user,将user绑定到 request对象上面
    
    ```java
    request.setAttribute("oUser",user);
    ```

1. 访问bean的属性
    
    * ${oUser.name}  或  ${oUser["name"]}

        jsp引擎会从 pageContext -> request -> session -> application
        依次查找  名为  oUser的对象，找到后调用对象的 getName方法，并输出值(找不到输出空)
    * ${user[propname]}

        propname是变量名

    * 可以使用  pageScope、requestScope、sessionScope、applicationScope四个关键字制定查找范围

        ```jsp
            ${requestScope.oUser.name}
        ```
2. 获得请求参数

    * ${param.username}
        等价于 request.getParameter("username");
    * ${paramValues.interest}
        等价于 request.getParameterValues("interest");

3. 表达式

    ${"abc" eq "abc"}   或者其他表达式  eq 判断相等

#### el表达式核心标签

1. 



