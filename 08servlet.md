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


## 重定向

* 重定向 ： 服务器向浏览器  发送302(暂时重定向)状态码以及 location 浏览器接收到后会立即请求location

* 重定向注意点：
    
    * 重定向之前不能  out.close() 或 out.flush()
    * 如果response对象有数据会被清空

* 重定向方法： 

    response.sendRedirect(String url); //url是重定向的地址

## 转发（jsp页面显示数据好像要用到的就是转发）

	一个web组件(servlet/jsp) 将未完成的处理交给另一个web组件处理,转发的各个组件共享 request 和response

* 如何转发

	1. 绑定数据

		```java
			request.setAttribute(String name,Object obj);
			
			//与绑定相关的另外两个方法
			Object request.getAttribute(String name);
			request.removeAttribute(String name);
			//如果name对应的值是不存在  返回null
		```
	2. 获得转发器

		```java
		RequestDispatcher rd = request.getRequestDispatcher(String uri);
										//获得 请求 分配器
		rd.forward(request,response);
		```
	3. 注意

		转发前不要out.close或者out.flush
		如果 response 中有数据会被清空
	
	4. 特点
		只能转发给同项目下的 web组件
		转发后浏览器地址栏 不变
		转发涉及的web组件  共享一个 request response




## Dao （Data Access Object）

    封装数据访问逻辑 减少冗余   有**道**啊！

### dao

* 实体类
* dao接口
* dao实现类
* dao工厂


## servlet demo  员工信息增删改查

### 目录结构

![](http://96weibin-blog.oss-cn-beijing.aliyuncs.com/18-12-25/97952630.jpg)


### entity包 下的 Employee （实体类）

    与数据库中数据对应的 实体类, 声明 数据库中所用到的数据  get set

```java
package entity;

//实体类
public class Employee {
	
	private long id;
	private String name;
	private double salary;
	private int age;
	
	
	
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	
	public double getSalary() {
		return salary;
	}
	public void setSalary(double salary) {
		this.salary = salary;
	}
	
	
	public int getAge() {
		return age;
	}
	public void setAge(int age) {
		this.age = age;
	}
}
```

### dao包 下的 EmployeeDAO （dao接口）

    dao接口，定义用到的方法

```java
package dao;

import java.util.List;
import entity.Employee;
	   
public interface EmployeeDAO {
	//dao的接口
	public List <Employee> findAll() throws Exception;
		
	public void delete(long id) throws Exception;
		
	public void save(Employee e) throws Exception;
	
	public Employee findById(long id) throws Exception;
	
	public void update(Employee e) throws Exception;
}
```

### dao包 下 impl包下 的 EmployeeDAOJdbcImpl（接口的实现）

    实现全部 Employee中的方法,调用 DBUtil的公共 打开 关闭数据库的方法

```java
package dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import util.DBUtil;
import dao.EmployeeDAO;
import entity.Employee;

public class EmployeeDAOJdbcImpl implements EmployeeDAO{
	//dao实现类

	@Override
	public List<Employee> findAll() throws Exception {
		Connection conn = DBUtil.getConnection();
		Statement stat = conn.createStatement();
		ResultSet res = stat.executeQuery("select * from z_emp");
		List<Employee> employees = new ArrayList<Employee>();
		while(res.next()){
			Employee e = new Employee();
			e.setId(res.getLong("id"));
			e.setName(res.getString("name"));
			e.setSalary(res.getDouble("salary"));
			e.setAge(res.getInt("age"));
			employees.add(e);
		}
		DBUtil.close(conn);
		return employees;
	}

	@Override
	public void delete(long id) throws Exception {
		Connection conn  = DBUtil.getConnection();
		PreparedStatement prep = conn.prepareStatement("delete from z_emp where id=?");
		prep.setLong(1,id);
		prep.executeUpdate();
		DBUtil.close(conn);
	}

	@Override
	public void save(Employee e) throws Exception {
		Connection conn = DBUtil.getConnection();
		PreparedStatement prep = conn.prepareStatement("insert into " + "z_emp(name,salary,age)" + "values(?,?,?)");
		prep.setString(1,e.getName());
		prep.setDouble(2,e.getSalary());
		prep.setDouble(3,e.getAge());
		prep.executeUpdate();
		DBUtil.close(conn);
	}

	@Override
	public Employee findById(long id) throws Exception {
		Connection conn = DBUtil.getConnection();
		PreparedStatement prep = conn.prepareStatement("select * from z_emp where id= ?");
		prep.setLong(1,id);
		ResultSet res = prep.executeQuery();
		Employee e = null;
		if(res.next()){
			e = new Employee();
			e.setId(id);
			e.setName(res.getString("name"));
			e.setSalary(res.getDouble("salary"));
			e.setAge(res.getInt("age"));
			
		}
		DBUtil.close(conn);
		return e;
	}

	@Override
	public void update(Employee e) throws Exception {
		Connection conn = DBUtil.getConnection();
		PreparedStatement prep = conn.prepareStatement("update z_emp" + " set name = ?, salary = ?, age = ? " + "where id = ?");
		
		prep.setString(1, e.getName());
		prep.setDouble(2, e.getSalary());
		prep.setInt(3, e.getAge());
		prep.setLong(4, e.getId());
		prep.executeUpdate();
		DBUtil.close(conn);
	}
}

```


### util包下 的 DBUtil (链接数据库关闭数据库的公共方法)

```java
package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
	//dao的方法  jdbc工具类
	public static Connection getConnection()
	throws Exception{
		Connection conn = null;
		try{
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://10.20.2.9:3306/test","test","test");
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		return conn;
	}
	public static void close(Connection conn){
		if(conn != null){
			try{
				conn.close();
			} catch (SQLException e){
				e.printStackTrace();
			}
		}
	}
	
	//测试用的
//	public static void main(String[] arguments) throws Exception{
//		System.out.println(getConnection());
//	}
	
}

```


### web包下的 ListEmpServlet （员工信息列表显示servlet）

    直接使用dao中的方法,与数据库进行交互 实现显示所有的员工信息

```java
package web;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.EmployeeDAO;
import dao.impl.EmployeeDAOJdbcImpl;
import entity.Employee;

public class ListEmpServlet extends HttpServlet {

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		try{
			EmployeeDAO dao = new EmployeeDAOJdbcImpl();
			List<Employee> employees = dao.findAll();
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println("<table border=1px; cellSpacing=0; bgColor=pink>");
			out.println("<tr>"
			+"<td>id</td>"
			+"<td>姓名</td>"
			+"<td>年龄</td>"
			+"<td>薪资</td>"
			+"<td>操作</td>"
			+"</tr>"
			);
			for(int i = 0; i < employees.size();i++){
				Employee e = employees.get(i);
				out.println("<tr>"
								+ "<td>"+e.getId()+"</td>"
								+ "<td>"+e.getName()+"</td>"
								+ "<td>"+e.getAge()+"</td>"
								+ "<td>"+e.getSalary()+"</td>"
								+ "<td>"
									+ "<a href='DelEmpServelet?id=" + e.getId() + "'>"+ "删除" +"</a>"
									+ "<a href='LoadEmpServlet?id=" + e.getId() + "'>"+ "修改" +"</a>"
								+ "</td>"
							+ "</tr>"
						);
				
			}
			out.println("</table>");
			out.println("<a href='addEmp.html'>" + "增加新雇员</a>");
			out.close();
		}catch(Exception e){
			e.printStackTrace();
			throw new ServletException(e);
		}
	}

}

```


### web包下的 addEmpServlet 

    接收addemp.html 表单提交的数据 调用 set 一个 实体类  调用  dao的 save方法 将实体类的数据传入数据库 从而添加了  一个员工的信息

```java
package web;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.EmployeeDAO;
import dao.impl.EmployeeDAOJdbcImpl;
import entity.Employee;

public class AddEmpServlet extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("utf-8");
		String name = request.getParameter("name");
		double salary = Double.parseDouble(request.getParameter("salary"));
		int age = Integer.parseInt(request.getParameter("age"));
		System.out.println("name" + name);
		System.out.println("salary" + salary);
		System.out.println("age" + age);
		try{
			EmployeeDAO dao = new EmployeeDAOJdbcImpl();
			Employee e = new Employee();
			e.setName(name);
			e.setAge(age);
			e.setSalary(salary);
			dao.save(e);
			response.sendRedirect("ListEmpServlet");
		} catch (Exception e){
			e.printStackTrace();
			throw new ServletException(e);
		}
	}
}
```

### web包下的 DelEmpServelet

    接收点击删除时传来的  id  调用 dao的 delete  实现删除 关于此 id 的数据

```java
package web;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.EmployeeDAO;
import dao.impl.EmployeeDAOJdbcImpl;

public class DelEmpServelet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		long id = Long.parseLong(request.getParameter("id"));
		try{
			EmployeeDAO dao = new EmployeeDAOJdbcImpl();
			dao.delete(id);
			response.sendRedirect("ListEmpServlet");
		} catch(Exception e){
			e.printStackTrace();
			throw new ServletException(e);
		}
	}

}
```

### web 包下的 LoadEmpServlet 

    根据传来的id 调用  dao的 findOne  显示 用表单显示 某一个员工的数据 ,如果 表单提交则提交 可能是改过的 员工信息到 ModifyEmpServlet

```java
package web;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.EmployeeDAO;
import dao.impl.EmployeeDAOJdbcImpl;
import entity.Employee;

public class LoadEmpServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		long id = Long.parseLong(request.getParameter("id"));
		try{
			EmployeeDAO dao = new EmployeeDAOJdbcImpl();
			Employee e = dao.findById(id);
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println("<form action= 'ModifyEmpServlet?id="+ id +"' method='post'>");
			out.println("id :" + id + "</br>");
			out.println("姓名：<input name='name' value='" + e.getName() +"'></br>");
			out.println("薪水：<input name='salary' value='" + e.getSalary() + "'></br>");
			out.println("年龄：<input name='age' value='" + e.getAge() + "'>");
			out.println("<input type='submit' value='确认'>");
			out.println("</from>");
			out.close();
			
		}catch(Exception e){
			e.printStackTrace();
			throw new ServletException(e);
		}
	}
}
```

### web 包下的 ModifyEmpServlet

    接收 LoadEmpservlet 中form表单提交过来的数据,通过dao 的 update 更新数据库

```java
package web;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.EmployeeDAO;
import dao.impl.EmployeeDAOJdbcImpl;
import entity.Employee;

public class ModifyEmpServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		long id = Long.parseLong(request.getParameter("id"));
		String name = request.getParameter("name");
		double salary =  Double.parseDouble(request.getParameter("salary"));
		int age = Integer.parseInt(request.getParameter("age"));
		try{
			EmployeeDAO dao = new EmployeeDAOJdbcImpl();
			Employee e = new Employee();
			e.setId(id);
			e.setAge(age);
			e.setName(name);
			e.setSalary(salary);
			dao.update(e);
			response.sendRedirect("ListEmpServlet");
		}catch(Exception e){
			e.printStackTrace();
			throw new ServletException(e);
		}	
	}
}
```

### dao的流程理解图




## dao工厂模式

	好尴尬,  打了一遍pdf上的 工厂模式    基本没有变化  就是把   获取 dao    new 实例的步骤放在  factory  然后每次调用factory  实现

```java
package util;

import dao.impl.*;

public class DAOFactory {
	public static Object getInstance (String type){
		Object obj = null;
		if(type.equals("EmployeeDAO")){
			obj = new EmployeeDAOHibernateImpl();
		}
		return obj;
	}
}

//在要使用 dao的地方  通过  调用函数执行  来获取 dao实例
//这是  如果更换 jdbcImpl 为 hibernateImpl 则只需要更改 这里的就好，
//不需要 挨个servlet 来更改。
EmployeeDAO dao = (EmployeeDAO) DAOFactory.getInstance("EmployeeDAO");
```


### 改进的工厂模式（没看懂）

* daoconfig.properties (配置文件)

```properties
EmployeeDAO = dao.impl.EmployeeDAOJdbcImpl
## EmployeeDAO = dao.impl.EmployeeDAOHibernateImpl
ABC = aaa
```

* configUtil.java (读取配置文件)

```java
package util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class ConfigUtil {

	private static Properties props = new Properties();
	static{
		ClassLoader loader = ConfigUtil.class.getClassLoader();
		InputStream ips = loader.getResourceAsStream("util/daoconfig.properties");
		try{
			props.load(ips);
		}catch(IOException e){
			e.printStackTrace();
		}
				
	}
	public static String getValue(String key){
		return props.getProperty(key);
	}
	public static void main(String[] args){
		System.out.println(getValue("ABC"));
	}
}
```

* DAOFactory.java

```java
package util;

public class DAOFactory {
	public static Object getInstance (String type){
		Object obj = null;
		//依据接口找对应的类名
		String className = ConfigUtil.getValue(type);
		//使用反射创建实例
		try{
			obj = Class.forName(className).newInstance();
		} catch (Exception e){
			e.printStackTrace();
		}
		
//		if(type.equals("EmployeeDAO")){
//			obj = new EmployeeDAOHibernateImpl();
//		}
		return obj;
	}
}
```



## 类加载器


```java
Student s = new Student();
s.play();
Student s2 = new Student();
```

* 内存空间

	jvm在操作系统中就是一个线程，系统会给其分配一块内存空间。
	这块内存分为三个区域  1、栈区 2、堆区 3、方法区

1. 程序执行 到第一行 Student

	此时jvm 查看  方法区  中是否有 Student对应的类,没有  调用 类加载器
	类加载器 通过 classPath 找到 Student物理位置的字节码文件
	类加载器 将 class文件变成 对象放入方法区。

2. 执行到 第一行 s

	将 s 放入栈空间

3. 执行 第一行 new Student();

	在堆空间创建对象 ， s 指向这个对象。   对象存储着  对象的属性
	对象的方法放在  方法区 

4. 执行 s.play();

	到方法区找到play方法执行

	![](http://96weibin-blog.oss-cn-beijing.aliyuncs.com/18-12-28/90000630.jpg)


5. 执行第三行 Student 

	已经存在 Student类。所以不调用类加载器。

6. 第三行  s2 

	将s2存入到栈区

6. new Student();

	在堆空间创建对象、对象存储着属性，方法任然是  方法区的 同一个方法。

	![](http://96weibin-blog.oss-cn-beijing.aliyuncs.com/18-12-28/8900073.jpg)

## 处理请求资源路径

	http://ip:port/appName/abc.html;

	webObject 对应的就是   appName 下面的 abc.html由  web.xml配置。

### xml配置可以请求的路径

rul-pattern | 匹配请求
-|-
/abc | 匹配精确的abc
/abc.html | 可以骗人，其实我请求的是一个servlet，<br>访问的url却是abc.html
/abc/* | 匹配 /abc/任何字符串(可以有空格)
*.do | 匹配任何以 .do 为后缀的

## Servlet处理多种请求


### 一个servlet接收多个请求

	通过拆分请求url 执行不同的逻辑
```java
String uri = request.getRequestURI();
String path = uri.substring(uri.lastIndexOf("/"),uri.lastIndexOf("."));
if(path.equals("list")){
	//dosomething
}else if(path.equals("add")){
	//dosomething
}
```

	请求不同的url 要设置  web.xml中   urlPattern  为 *.do

* 以我一个前端开发的经验，我写过的多个务求请求一个页面都是传不同的状态值，后台判断状态值，执行不同的逻辑


## servlet生命周期与核心接口与类

### 核心接口与类

1. Servlet 接口

	init(ServletConfig config)
	destory()
	service(ServletRequest res,ServletResponse rep)

2. GenericServlet抽象类

	实现了 Servlet接口中的  inti 和 destroy方法

3.  HttpServlet抽象类

	继承了GennericServlet实现了 service方法

4. ServletRequest 与 ServletResponse接口

5. HttpServletRequest 与 HttpServletRequest 接口

6. ServletConfig接口

	String getInitParameter(String paraName);


### servlet生命周期


	servlet 04   待补充


## 过滤器
















