# Servlet

    在java页面接受前端数据、查询数据库、操作、返回给前端


通过 IDE 创建 web项目，在问项里面创建  servlet文件,  
在类中 继承  HttpServlet类  在类的里面 创建方法  获取 HttpServletRequest 的 request 和 HttpServletResponse 的 response 

request.getParamer("name")  获取  前端发来的数据

返回数据通过  

response.setContentType()设置返回值得类型


## 编码问题

1. html 页面设置 

```html
<meta charset="utf-8">
```

2. 设置服务器端接受  

```java
    request.setCharacterEncoding("utf-8");
```

3. 设置服务器端返回

```java
    response.setContentType("text/html;charset=utf-8");
```


//看到  servlet  第二章   链接 MySQL
