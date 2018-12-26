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


## 重定向&&

* 重定向 ： 服务器向浏览器  发送302(暂时重定向)状态码以及 location 浏览器接收到后会立即请求location

* 重定向注意点：
    
    * 重定向之前不能  out.close() 或 out.flush()
    * 如果response对象有数据会被清空

* 重定向方法： 

    response.sendRedirect(String url); //url是重定向的地址

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
			e.setSalary(salary);dao.update(e);
			response.sendRedirect("ListEmpServlet");
		}catch(Exception e){
			e.printStackTrace();
			throw new ServletException(e);
		}	
	}
}
```


## dao工厂模式




































