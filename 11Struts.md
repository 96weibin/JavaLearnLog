# Struts2

## MVC

1. Model

    业务逻辑、包含数据和业务处理逻辑(实体类、DAO、Service)

2. View

    显示、交互，

3. Controler

    接收前端请求、做出响应 (servlet)

* MVC流程

    前端发送请求  请求到servlet，servlet获取数据 执行方法 读取Modle层，做出计算  将需要返回的数据  set 到 Request 再将 Request中数据分发到jsp页面进行显示

    所以我认为   servlet 开始就是 控制层
    控制层 只是一些流程、模型层实现方法，控制层调用

## Strus 访问返回

在src下   struts.xml  配置文件,访问 jsp页面 action为  ***.action(由配置文件配置路径)  执行其execute方法   返回字符串   配置文件中 result 判断返回字符串 将request 转发到 对应的jsp 且跳转jsp

action里面自动获取 input标签  name对应传来的数据

* 实现 访问 nameform.jsp 提交一个 name  页面显示  welcome:name

### 目录结构

```html
    src\
        com.tarena.outman\
            WelcomeAction.java
        struts.xml
    webRoot\
        jsp\
            nameform.jsp
            welcome.jsp
        WEB-INF\
            lib\
                commons-fileupload-1.3.2.jar
                commons-io-2.2.jar
                commons-lang3-3.2.jar
                freemarker-2.3.22.jar
                javassist-3.11.0.GA.jar
                ognl-3.0.19.jar
                struts2-core-2.3.33.jar
                xwork-core-2.3.33.jar
            web.xml
```

### 代码实现

* WelcomeAction.java

```java
package com.tarena.outman;
public class WelcomeAction {
  private String name;

  public String getName() {
    return name;
  }
  public void setName(String name) {
    this.name = name;
  }
  public String execute(){
    System.out.print("ex" + name);
    if("monster".equalsIgnoreCase(name)){
      return "fail";
    }
    return "success";
  }
}
```

* struts.xml

    *这里需要注意下*： WebRoot 浏览器直接访问则是访问的这个地方、但是  WEB-INF 这个文件夹是不能被直接访问的，在这个目录下创建的jsp  访问的时候回404  但是放在这里的jsp可以通过转发的方式来访问、所以为了不被随便访问，所以如果多个jsp  可以将不想被从浏览器get的jsp放在  WEB-INF 下面

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE struts PUBLIC "-//Apache Software Foundation//DTD Struts Configuration 2.1//EN" "http://struts.apache.org/dtds/struts-2.1.dtd">
<struts>
  <!-- struts 下 可有多个package  package的name 目前不知道啥作用 -->
  <package name="helloworld" extends="struts-default" namespace="/day01">
  <!-- 包名 helloworld、  继承struts-default、 action地址的命名空间 -->
    <action name="nameform.jsp">
            <result name="success">/WEB-INF/jsp/welcome.js</result>
        </action>
    <!-- 一个package可以包含多个 action -->
    <action name="welcome" class="com.tarena.outman.WelcomeAction">
    <!-- 请求的名字 welcome、 action类地址  -->
      <!-- action类返回那个 name则 转发到那个jsp -->
      <result name="success">/WEB-INF/jsp/welcome.jsp</result>
      <result name="fail">WEB-INF/jsp/nameform.jsp</result>
    </action>
  </package>
</struts>
```

* nameform.jsp

```jsp
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!DOCTYPE>
<html>
  <head>
    <title>formname</title>
  </head>
  <body>
    <form action="/struts01/day01/welcome.action">
      <input name="name" type="text"/>
      <input value="提交" type="submit"/>
    </form>
  </body>
</html>

```

* welcome.jsp

```jsp
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!DOCTYPE>
<html>
  <head>
    <title>welcome</title>
  </head>
  <body>
    <h1>welcome:${name}</h1>
  </body>
</html>
```

* web.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>

<web-app version="2.4"
xmlns="http://java.sun.com/xml/ns/j2ee"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://java.sun.com/xml/ns/j2ee
http://java.sun.com/xml/ns/j2ee/web-app_2_4.xsd">
  <filter>
    <filter-name>Struts2</filter-name>
    <filter-class>
      org.apache.struts2.dispatcher.ng.filter.StrutsPrepareAndExecuteFilter
    </filter-class>
  </filter>
  <filter-mapping>
    <filter-name>Struts2</filter-name>
    <url-pattern>/*</url-pattern>
  </filter-mapping>
</web-app>
```

//TODO 待补充   filter

## Struts2  链接数据库

* 实现一个从数据库读取数据显示到前端表单上，可以翻页

引入必要的jar包以及 jdbc包等

在action 中获执行 dao中的方法获取到来自数据库的数据，在action内声明get set，
这样在 jsp页面就可以用el表达式来取出来

### 目录结构2

```html
project\
  src\
    com.wb.cdb\
      dao\
        ProjectDao.java
      entity\
        Project.java
      util\
        ConnectionUtils.java
      ProjectListAction.java
  database.properties         //连接数据库的配置文件
  struts.xml                  //struts的配置文件
  WebRoot
    WEB-INF
      jsp
        projectlist.jsp
      web.xml
```

### 代码实现2

#### database.properties
  
  记录了 数据库的连接数据

```properties
username=test
password=test
driver=com.mysql.jdbc.Driver
url=jdbc\:mysql\://10.20.2.9\:3306/test
```

#### ConnectionUtils.java

  连接数据库用的，待研究

```java

public class ConnectionUtils {
  //貌似是  Spring  连接池   database.properties
  private static String url;
  private static String driver;
  private static String username;
  private static String password;
  
  static {
    Properties props = new Properties();
    try{
      props.load(ConnectionUtils.class.getClassLoader().getResourceAsStream("database.properties"));
    } catch (IOException e) {
      e.printStackTrace();
    }
    if(props != null){
      url = props.getProperty("url");
      driver = props.getProperty("driver");
      username = props.getProperty("username");
      password = props.getProperty("password");

      try{
        Class.forName(driver);
      } catch (ClassNotFoundException e){
        e.printStackTrace();
      }
    }
  }
  public static Connection openConnection() throws SQLException{
    return DriverManager.getConnection(url,username,password);
  }
  public static void closeConnection(Connection con){
    try{
      if(con != null){
        con.close();
      }
    } catch (SQLException e){
      e.printStackTrace();
    }
  }
  public static void closeStatement(Statement stmt) {
    try {
    if (stmt != null) {
    stmt.close();
    }
    } catch (SQLException e) {
    e.printStackTrace();
    }
    }
  public static void closeResultSet(ResultSet rs) {
    try {
      if (rs != null) {
        rs.close();
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
  }
  public static void main(String[] args) throws Exception {
    Connection con = openConnection();
    System.out.println(con);
  }
}

```

#### project.java

  会用到的数据读写类

```java
public class Project {
  private int id;
  private String name;
  private Date startDate;
  public int getId() {
    return id;
  }
  public void setId(int id) {
    this.id = id;
  }
  public String getName() {
    return name;
  }
  public void setName(String name) {
    this.name = name;
  }
  public Date getStartDate() {
    return startDate;
  }
  public void setStartDate(Date startDate) {
    this.startDate = startDate;
  }
  public Date getEndDate() {
    return endDate;
  }
  public void setEndDate(Date endDate) {
    this.endDate = endDate;
  }
  private Date endDate;
}

```

#### ProjectDao

  封装 操作数据库的某种方法  

```java
public class ProjectDao {
  private static final String findAll = "select id,name,start_date,end_date from t_project";
  //查询
  private static final String findPage = "select id,name,start_date,end_date from t_project limit ?,?";
  //查询分页

  public List<Project> findAll(){
    Connection con = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try{
      con = ConnectionUtils.openConnection(); //util中的方法
      stmt = con.prepareStatement(findAll);
      rs = stmt.executeQuery();
      List <Project> list = new ArrayList<Project>();
      while(rs.next()){
        Project project = new Project();
        project.setId(rs.getInt(1));
        project.setName(rs.getString(2));
        project.setStartDate(rs.getDate(3));
        project.setEndDate(rs.getDate(4));
        list.add(project);
      }
      return list;
    }catch (Exception e){
      e.printStackTrace();
      throw new RuntimeException(e);
    }
  }
  
  public List<Project> findAll(int page,int rowsPerPage){
    Connection con = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    try{
      con = ConnectionUtils.openConnection();
      stmt = con.prepareStatement(findPage);
      stmt.setInt(1, (page - 1) * rowsPerPage);
      stmt.setInt(2, rowsPerPage);
      rs = stmt.executeQuery();
      List<Project> list = new ArrayList<Project>();
      while(rs.next()){
        Project project = new Project();
        project.setId(rs.getInt(1));
        project.setName(rs.getString(2));
        project.setStartDate(rs.getDate(3));
        project.setEndDate(rs.getDate(4));
        list.add(project);
      }
      return list;
    }catch(Exception e){
      e.printStackTrace();
      throw new RuntimeException(e);
    }
  }
  public static void main (String[] args){
    ProjectDao dao = new ProjectDao();
    List <Project> list = dao.findAll(1,5);
    for(Project p :list){
      System.out.println(p.getName());
    }
  }
}
```

#### ProjectListAction.java

  struts 的 action,
  在其中 声明数据变量 相当于  request.getParamer这个变量,
  可以之间在action中使用，也可以在action中做出更改后,action执行完成根据返回的string
  struts.xml中配置 根据action返回的字符串,将action中的数据 绑定到requestScopt上  
  再转发到 对应的jsp上 在对应的jsp上通过el表达式实现相应

```java
  public class ProjectListAction {
  private List<Project> projectList;
  private int page = 1;
  public int getPage() {
    return page;
  }
  public void setPage(int page) {
    this.page = page;
  }
  public List<Project> getProjectList() {
    return projectList;
  }
  public void setProjectList(List<Project> projectList) {
    this.projectList = projectList;
  }
  
  public String execute(){
    ProjectDao projectDao = new ProjectDao();
    System.out.print(page);
    projectList = projectDao.findAll(page,5);
    return "success";
  }
}
```

#### projectlist.jsp

```jsp
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!-- 引入这个才能el表达式的标签的功能才能生效 -->
<html>
  <head>
    <title></title>
  </head>
  <body>
    <h1>
      Project List
    </h1>
    <h2>
      <a href="projectlist.action?page=${page-1}">上一页</a>
      <span>|第${page}页|</span>
      <a href="projectlist.action?page=${page+1}">下一页</a>
    </h2>
    <table width="90%" border="2">
      <tr>
        <td>ID</td>
        <td>Name</td>
        <td>Start Date</td>
        <td>End Date</td>
      </tr>
      <c:forEach var="p" items="${projectList}">
        <tr>
          <td>${p.id}</td>
          <td>${p.name}</td>
          <td>${p.startDate}</td>
          <td>${p.endDate}</td>
        </tr>
      </c:forEach>
    </table>
  </body>
</html>
```

#### web.xml

过滤器

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app version="2.4" xmlns="http://java.sun.com/xml/ns/j2ee"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://java.sun.com/xml/ns/j2ee
http://java.sun.com/xml/ns/j2ee/web-app_2_4.xsd">
  <filter>
    <filter-name>Struts2</filter-name>
    <filter-class>
      org.apache.struts2.dispatcher.ng.filter.StrutsPrepareAndExecuteFilter
    </filter-class>
  </filter>
  <filter-mapping>
    <filter-name>Struts2</filter-name>
    <url-pattern>/*</url-pattern>
  </filter-mapping>
</web-app>
```

## OGNL表达式

TODO 待补充
