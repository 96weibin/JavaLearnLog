# String  

在java中字符串属于对象，

## 创建字符串

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

## 连接字符串

concat  或  +   链接

## 创建格式化字符串

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

## String方法 （java中字符串式对象，是否存储在堆空间？）

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










### copyValueOf

str.copyValueOf(charArr)  //将charArr 赋值给 str

str.copyValueOf(charArr,1,6); //将 charArr 的 1 向后 6项 赋值给 str

