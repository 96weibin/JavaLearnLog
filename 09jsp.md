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

要使用el表达式中的**标签**要在开头引入  文件

```jsp
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
```


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

        * ∴ 相当于  out.print(oUser.getName());

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

1. <c:if test="" var="" scope=""></c:if>

```jsp
<c:if test="flag">
    <!-- if flag equal true do something -->
</c:if>
```

    如果test为true 则 执行

属性 | 用法
-|-
test | val为 boolean true则执行标签体内容false则不执行
var  | 指定一个绑定名
scope| 指定绑定范围 (pageContext，request，session，application)

2. <c:choose>   <c:when test="">    <c:otherwise>

    很像if else
```jsp
<c:choose>
    <c:when test="${user.gendar == 'm'}">男</c:when>
    <c:otherwise>女</c:otherwise>
</c:choose>
```

3. <c:forEach var="" items"" varStatus="">

    很像 foreach

```jsp
<c:forEach var="user" items="${users}">
    <tr>
        <td>${user.name}</td>
        <td>${user.gendar}</td>
    </tr>
</c:forEach>
```

4. <c:rul>

当用户进制cookie后再地址后添加sessionId

```jsp
<a href="<c:url value='/jst.jsp/'>">访问jst.jsp</a>
```

5. <c:set var="" scope="" value="">

    绑定一个对象到指定的范围
```jsp
<c:set var="rs" scope="session" value="2">
<p>
    ${sessionScopt.rs} 
    <!-- 2 -->
</p>
<c:remove var="rs" scope="session">
<p>
    ${sessionScopt.rs} 
    <!--  -->
</p>
```

6. <c:catch var="">

```jsp
<c:catch var="msg">
    <%
        Integer.parseInt("123a");
    %>
</c:catch>
${msg}  
<!-- 输出报错 -->
```

7. <c:import url> 

    引入文件
8. <c:redirect url="">

    重定向

9. <c:out value="" default="" escapeXml="">

escapeXml="" 默认值为true 将value 中的特殊字符用实体字符替换


```jsp
    <c:out value="${str}" default="hello">

    <!-- 用于输出 el表达式的时候可以设置 默认值 -->
```