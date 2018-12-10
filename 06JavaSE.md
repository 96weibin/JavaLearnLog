# java SE

## String类


在java中字符串属于对象，

### 创建字符串

```java
//字面量
String greeting = "菜鸟教程";

//构造函数
char[] helloArray = {'a','b','c','d'};
String helloString = new String(helloArray);
System.out.println(helloString);
```

字符串对象创建后就不能改变

.length 获取字符串的长度

### 连接字符串

concat  或  +   链接

### 创建格式化字符串

使用 printf()  和 format()

System.out.printf("字符串模板",值,值);   //单次输出

String fs;
fs = String.format("字符串模板",值,值); //创建副本

```java
// 拼接字符串中通过 

// %f 表示插入为浮点类型
// %d 表示整数类型
// %s 表示为字符串类型

System.out.printf("浮点型变量的值为 " +
                  "%f, 整型变量的值为 " +
                  " %d, 字符串变量的值为 " +
                  "is %s", floatVar, intVar, stringVar);

//这些  + 号  不知道为什么要这么浪   多余的举动
```

### String方法 （java中字符串式对象，是否存储在堆空间？ 是的）

str.fun() 或者 String.fun()

方法 | 描述 | 返回类型 | demo
-|-|-|-
charAt(index) | 返回Str index位置对应的char值 | char | char cha = str.charAt(3);
compareTo(str) | 返回与str的比较值<br> 从第一位进行比较、如果有差值(ASCII)<br>则返回差值(原字符串大则返回正值、反之返回负值)<br>如果比较到某个字符串的尽头仍然相等<br>若有一方长度长，则返回长度差 | int | str.compareTo(str)
compareTolgnoreCase(str) | 比较字符串、不区分大小写 | int
contentEquals(StringBuffer sb) | 当str与StringBuffer偏序相同时返回true | boolean
static String copyValueOf(char[] data) | 见下面 | string
endsWith(str) | 判断字符串式否以 str结尾 | boolean
startsWith(str) | 判断以str开始 | boolean
equals() | 将字符串与指定对象比较 | boolean
equalslgnoreCase(str) | 与字符串进行比较，不考虑大小写
getBytes() | 将字符串编码为byte序列 | byte[]
getChars(begin,end,tarArr,tarArrBegin) | 将str从begin到end、插入 tarArr 的tarArrbeing | void
hashCode() | 返回字符串的hash值 | int
indexOf(str,index) | 返回 字符串从 index 开始 第一次出现 str 的位置，没有返回-1
lastIndexOf(str,index) | 
intern() | 返回字符串规范化表示形式(什么是不规范。。。感觉都一样) |  String
length() | 返回字符串长度
matches(reg) | 判断字符串是否匹配regExp | boolean
regionMatches() | 比较字符串片段 是否相等
regionMatches() |
replace(oldChar,newChar) | 替换字符串中的oldChar
replaceAll(regExp,str) | 用str替换所有符合reg的
split(regexp) | 根据reg 拆分字符串 | string[] | 与js相同可以拆出来数组
substring(begin,end) |  返回一个新的字符串、返回子字符串从 begin 截取到 end
toCharArray() | 返回字符数组 | char[]
toLowerCase() | 转换为小写
toString() | 返回此对象本身 
toUpperCase() | 转化为大写 | String | str.toUpperCase()
trim() | 忽略前面和后面的空格 | string | str.trim()
valueOf(x) | 返回x的字符串形式 | String | String.valueOf(x)


#### copyValueOf

str.copyValueOf(charArr)  //将charArr 赋值给 str

str.copyValueOf(charArr,1,6); //将 charArr 的 1 向后 6项 赋值给 str








## 正则表达式

### 创建

* 引入 java.util.regex;

* regex包 包括3个类

    * pattern（模式）类

    * Matcher（匹配器）类   

    * PatternSyntaxException（模式语法例外）类

```java
package regExp;
import java.util.regex.Pattern;
public class Start {
	public static void main(String[] args) {
		String str = "abc123defg";
		String template = "[a-z]*\\d*[a-z]*";
		boolean isMatch = Pattern.matches(template,str);
		//匹配相等 的时候 返回true
		System.out.println(isMatch); //trues
	}
}

```

### 分组

```java
package regExp;

import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class Group {
	public static void main(String[] args) {
		String str = "abc123defg";
		String template = "([a-z]*)(\\d*)([a-z]*)";
		Pattern r = Pattern.compile(template);
		Matcher m = r.matcher(str);
		if(m.find()) {
			System.out.println(m.group(0));
			System.out.println(m.group(1));
			System.out.println(m.group(2));
			System.out.println(m.group(3));
			
		} else {
			System.out.println("No Match");
		}
	}
}
```

### java中正则表达式语法

```java
在java中 \\ 表示 转义
以此类推
\\d 表示 数字
\\\\ 表示 \
```

### Matcher类的方法

#### 索引方法

方法 | 说明 | 返回值 | demo
-|-|-|-
start() | 返回以前匹配的初始索引 | int | 
end() | 返回最后匹配的偏移量

#### 研究方法

方法 | 说明 | 返回值 | demo
-|-|-|-
lookingAt() | 姜葱区域开头开始输入序列与模式的匹配
find() | 查找与模式匹配的输入序列的下一个子序列
matches() | 将整个取余与模式匹配

#### 替换方法

方法 | 说明 | 返回值 | demo
-|-|-|-
appendReplacement() | 实现非终端添加和替换步骤
appendTail() | 实现终端添加和替换步骤
replaceAll() | 
replaceFirst()|
quoteReplacement()|

### PatternSyntaxException类

方法 | 描述 | 返回值 | demo
-|-|-|-
getDescription() | 获取错误的描述 | String | 
getIndex() | 获取错误的索引 |int
getPattern() | 获取错误的正则表达式 | String
getMessage() | 获取错误信息 | String





## 线性表List

```java
package list;
import java.util.ArrayList;
public class ArrayListDemo {
	public static void main(String[] args) {
		ArrayList list = new ArrayList();
		list.add("真美好");//曾
		list.add(0,"世界");//插入
		System.out.println(list);
        //可以直接访问、更改
		list.remove(0);//删除
		System.out.println(list);
		String str = "真美好";
		list.remove(str);
		System.out.println(list);
	}
}
//[世界, 真美好]
//[真美好]
//[]
```
方法 | 介绍 | 返回值
-|-|-
clear() | 清空 | void
size() | 个数 | int
toArray() | 转化成Array | object[]
isEmpty() | 判断是否为空 | boolean
addAll() | 和 | list
removeAll() | 差 | list
retainAll() |  交集 | list
isEmpty() | 判断是否是空集 | boolean


## 散列表概念




### 散列表 Map (映射)

* 散列表概念

概念 | 描述
-|-
容量 | 散列表中散列数组大小
散列运算 | key -> 散列值(散列数组下标)的运算
散列桶 | 散列值相同的线性集合
加载因子 | 散列数组的加载率，一般小于75%性能比较理想<br>也就是元素数量/散列数组大小
散列查找 | 根据key计算列值，找到散列桶，在散列桶中顺序比较key<br>如果一样则返回value<br>散列表中key不同，Value可以重复

### HashMap

* key - value的形式存储对象 key唯一  

1. key和value 都可以是任何对象
2. key:value 成对放置在集合中
3. 重复的key 后来的覆盖
4. 根据key的散列值计算散列表,元素按照散列值(不可见)排序
5. HashMap 默认的容量16，默认加载银子  0.75
6. HashMap根据key检索查找value值


```java
package map;
import java.util.HashMap;
import java.util.Scanner;
public class Map {
	public static void main(String[] args) {
		HashMap users = new HashMap();
		users.put("tom",new User("tom","tomAbc",10));
		users.put("jim",new User("jim","jimAbc",10));
		
		users.put("Mark",new User("Mark","MarkAbc",10));
		users.put("mask",new User("maslk","tomAbc",10));
		System.out.println(users);
		Scanner s = new Scanner(System.in);
		while (true) {
			System.out.println("用户名");
			String name = s.nextLine();
			
			if(!users.containsKey(name)) {
				System.out.println("没有注册");
				continue;
			}
			System.out.println("密码");
			String pwd = s.nextLine();
			User user = (User)users.get(name);
			if(user.pwd.equals(pwd)) {
				System.out.println("欢迎" + user.name + "age:" + user.age);
				break;
			}
			
		}
	}
}
class User{
	String name;
	String pwd;
	int age;
	public User(String name, String pwd, int age) {
		this.name = name;
		this.age = age;
		this.pwd = pwd;
	}
	public String toString() {
		return name + ":" + name;
	}
}
```

map.containsKey(value)   判断value 是不是map的key   返回boolean
map.get(value)     从map中取出  name 对应的对象
String.equals(String)   判断两个字符串对象是否相等


常用方法 | 描述
-|-
containskey(key) | 判断是不是key
containsValue(value) | 判断是不是value
clear() | 清空
isEmpty() | 判断是不是空的
get(key) | 获取key对应的value
put(key,value) | 添加key，value
remove(key) | 删除某个key
size() | 对象内可以的个数

* HashMap && Hashtable

	HashMap   新 非线程安全，不检查锁，快

	Hashtable 旧 线程安全  ，检查锁  ，较慢

## 集合框架（Collection 和 map）


## 泛型

