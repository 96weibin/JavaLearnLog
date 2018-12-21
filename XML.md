# XML 

## XMl 与 js

    js 获取 ajax 返回的xml  当做 dom对象处理，通过操作dom的方式 读取数据

## 与html对比
* 不同点

    * 大小写敏感
    * 需要使用 特殊的声明头
    ```xml
    <?xml version="1.0" encoding="utf-8"?>
    ```
    *  xml 以标签名 和 属性值 做key 以标签内的数据做 value
    * 空格会被保留  不会  合并多个空格

* 相同点
    都是双标签 要闭合的，
    设置属性以  key = "value"， 
    注释的方式

```xml
    <![CDATA[
        保持 格式 
           输出
        不会进行转义
    ]]>
```
## XML描述数据

* 元数据

```html

    rul=jdbc:thin@192.168.0.26:1521:tarena
    dbUser = openlab
    dbPwd = open123

```

* xml表示

```xml
<datasource id="db_oracle">
    <property name="url">
        jdbc:thin@192.168.0.26:1521:tarena
    </property>
    <property name="dbUser">
        openlab
    </property>
    <property name="dbPwd">
        open123
    </property>
</datasourc>
```

## DTD（document type difintion）/Schema

两份相同结构(包括属性与属性值都相同)的XML可以交换数据