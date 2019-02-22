# StringBuffer、StringBuilder

使用StringBuffer或StringBuilder对字符串进行修改

StringBulider   不是线程安全的，不能同步访问，但是相对StringBuffer 有速度优势

## 创建StringBuffer

```java
StringBuffer sBuffer = new StringBuffer("世界真美好");
sBuffer.append("true");
System.out.print(sBuffer); //世界真美好true
```

## StringBuffer方法

方法 | 描述 | demo
-|-|-
sb.append(str) | 追加
sb.reverse() | 翻转
sb.delete(start,end) | 删除sb片段
sb.insert(offset,kit) | 在sb偏移offset 后插入 kit
sb.replace(start,end,str) | 在sb,start~end插入str

还有些方法和String类的类似