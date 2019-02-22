# Scanner

## next、hasNext()

```java
package scanner;
import java.util.Scanner;
public class Next {
  public static void main(String[] args) {
    Scanner scan = new Scanner(System.in);
    System.out.println("next 方式接受");
    if(scan.hasNext()) {
      String str1 = scan.next();
      System.out.println("输入的数据为" + str1);
    }
    scan.close();
  }
}
//输入带有空格的字符串  将只会接受空格之前的字符串
```

## nextLine()、hasNextLine()

```java
package scanner;
import java.util.Scanner;
public class NextLine {
  public static void main(String[] args) {
    Scanner scan = new Scanner(System.in);
    System.out.println("next 方式接受");
    if(scan.hasNextLine()) {
      String str1 = scan.nextLine();
      System.out.println("输入的数据为" + str1);
    }
    scan.close();
  }
}
//以enter为结尾、可以接收 带有空格的字符串
```
