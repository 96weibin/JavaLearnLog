# cookie && session

## cookie

* 创建cookie

    ```java
    //创建servlet 
    Cookie cookie = new Cookie("name", "value");
    Response.addCookie(cookie);
    ```

* 查询cookie

    ```java
    Cookie[] cookies = request.getCookies();
    String name = cookie.getName();
    String value = cookie.getValue();
    ```

* cookie保存时的编码问题

    cookie的值只能是 ascii字符，中文要转换  方法如下
    
    ```java
        URLEncoder.encode()
        URLDecoder.decode()
    ```

* cookie的保存时间

    ```java
        cookie.setMaxAge(int seconds);
        //seconds > 0 保存到硬盘，超时删除
        //seconds = 0 立即删除
        //seconds < 0 保存在内存，关闭浏览器删除
    ```
* 删除cookie

    ```java
        //新建一个 重名  且  maxAge是0的cookie
        Cookie c = new Cookie("username","");
        c.setMaxAge(0);
        response.addCookie(c);
    ```
* cookie路径

    浏览器想服务器请求时，会比较cookie路径与访问路径是否匹配，发送匹配的cookie
    可以通过 cookie.setPath(String path) 来配置

* cookie限制

    * 大小在4K左右
    * 浏览器约能保存 300个左右
    * cookie只能是字符串，且有编码问题
    * cookie 可以被禁止、不安全

## session

    浏览器访问服务器的时候，服务器 会创建一个 session对象， 和 sessionId唯一，
    在服务器缺省的情况下会将sessionId以 cookie 的机制发送给浏览器，
    在浏览器再次访问的时候 会将sessionId发送给服务器。
    服务器依据sessionId就可以找到对应的session对象。

    session 对象可以绑定数据，根据sessionId  查找各自的session 对象 读取其中数据，session 对象 不是一直激活的，在没有用到的时候他会保存早硬盘上（钝化），在需要的时候再激活

* 获取session对象 的两种方法

    ```java
    HttpSession session = request.getSession(boolean flag);
    //当 flag 为 true
        //服务器会查看请求中是否包含sessionId
        //如果没有则创建一个session对象，
        //如果有则依据sessionId找 session 对象，如果找到则返回
        //如果找不到则创建一个新的session对象
    //当 flag 为 false
        //服务器会先查看请求中是否包含sessionId
        //如果没有返回null
        //如果有 依据 sessionId 找 session对象，如果找到则返回
        //如果找不到 则返回null
        //
    ```

    ```java
    HttpSession session = request.getSession();
        //等价于  flag 为 ture 的情况
    ```

* HttpSession接口提供的方法

方法 | 用途
-|-
String session.getId() | 获取sessionId
session.setAttribute(String name,Object obj) | 绑定数据
Object session.getAttribute(String name) | 获取session对象，不存在返回null

* session超时

    * java设置  默认时间单位是 秒
    ```java
    session.setMaxInactiveInterval(int seconds);
                //不活跃 间隔
    ```

    * web.xml设置   默认时间单位是 分钟
    ```xml 
        <session-config>
            <session-timeout>30<session-timeout> 
        </session-config>
    ```

* 删除Session

```java
session.invalidate();
//在 登出操作的时候  就要删除session
```

#### session验证

登录成功后给 添加一个session   如果  user user

在访问页面的时候  在页面里  判断  getAttribute(user)   如果是null  则说明没有登录，重定向页面


## 用户禁止cookie 后如何使用session

    因为进制使用cookie 所以 在服务器返回sessionId的时候本地无法存储，那么在发送请求的时候无法判断是否是与 服务器对应的 所以在请求的时候

1. URL重写
    
    * 方法一、在jsp中重重写url
    ```jsp
    <a href="<%=reponse.encodeURL('action')%>">
    ```

    * 方法二、在重定向
    ```java
    /**
    *@class SomeServlet serclet
    */
    session.setAttribute("name","weibin);
    response.encodeRedirectURL(response.sendRedirectURL("other"));
    ```
    
    ```java
    /**
    *@class OtherServlet redirect to here
    */
    response.setContentType("text/html");
    PrintWriter out = response.getWriter();
    HttpSession session = request.getSession();
    String name = (String) session.getAttribute("name");
    out.println(name);
    out.close();
    ```



