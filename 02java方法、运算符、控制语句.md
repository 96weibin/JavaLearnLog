## java 的方法

### 方法的声明

```java
public static int f (int x) { //第一个int 是规定返回值得类型，第二个int 是 声明x 的类型
    int y = 3 * x +6; //运算
    return y; //返回值
}
```

### 方法的调用

```java
public static void main (String[] args) {
    int x = 3;
    int y = f(x);
}

```

### 调用方法的实例
```java
package demoPackage;
import java.util.Scanner;
public class useMethod {
	public static void main(String[] args) {
		Scanner console = new Scanner(System.in);
		System.out.print("请输入x");
		int x = console.nextInt();
		int y = f(x); //调用 f 传参 x
		System.out.println("f(x)=3 X "+ x +" + 6="+y);
	}
	public static int f(int x1) {   //定义的方法f
		int y = 3 * x1 + 6;
		return y;
	}
}
```

### 方法的语法

```java
(修饰符) (返回类型) (方法名) (参数列表) {
    //方法体
}
```

### return

    如果函数声明中的 返回类型不为空(void) 则要求必须有与之类型对应的返回值，如果没有或类型不匹配则报错

### 局部变量

    方法内的参数、变量，只能在函数内使用则叫做局部变量

### 形参和实参

    与js 相同   形参 是函数定义时候的参数
                实参 是函数调用时候传入的参数
## java运算符

### 乘性操作符

* 运算的封闭性
    * 同类型的参与运算(可能需要自动类型转换)
    * 返回同种类型(可能发生溢出)
    * byte, short, char 三种类型在java 中

    ```java
    int a = 10 + 'a';
    System.out.println(a);  // 107
    System.out.println((char)a) //k 
    ```
    
    * 整数的除法是整除(下溢出 所以余数被舍掉)
    * byte、short都要以**int** 类型运算
    ```java
        byte b = 4;
		byte d = b+b; //报错、这里d的声明应该变成 int
        byte d = (byte)(b+b); //或者 强制类型转换
		System.out.println(d);
    ```
    * % 取余 与js 相同返回  余数

### 自增自减运算符

    --、++、与js相同

### 逻辑运算符

    && 、||、 ！            与js相同

### 比较运算符

运算符 | 含义
-|-
< | 小于
<= | 小于等于
> | 大于
>= | 大于等于
== | 相等
!= | 不等

*注意*：与js不同java 是强类型的语言，所以没有 === 判断


### 三目运算符

```java
(条件) ? (true执行) : (false执行) ;
```

## 流程控制语句

### if-else语句

```java
if(判断) {
    //true执行
} else {
    //false执行
}  //与js 相同
```

### switch-case 与js 相同

```java
switch () {
    case 条件1:
    //执行语句
    break;
    .
    .
    .
    default:
    //执行语句
    break
}
```

## 循环控制语句

### while   与js 相同

```java
    while(条件){
        //当条件位true 时执行
    }
```

* demo
```java
Scanner console = new Scanner(System.in);
int qty;
while(true) {
    System.out.print("请输入数量");
    qty = console.nextInt();
    //虽然这是在while里面 但是 这个 console.nextInt() 会阻止程序的执行，要等到 控制台输入值得时候继续执行
    if (qty > 0 && qty <=5) {
        break;
    }
    System.out.println("请输入购买数量：1~5");
}
System.out.println("数量" + qty);

```

![](http://96weibin-blog.oss-cn-beijing.aliyuncs.com/18-11-23/51077080.jpg)


### for

```java
for(初始化; 判断; 执行){
    //循环体
}
```
### do-while

```java
do {
    //循环体
} while(表达式);//先执行一遍循环体, 再判断 表达式 若位true 的继续执行、false则终止
```

### break、continue

* break 跳出循环体
* continue 跳过本次循环继续执行下次循环
