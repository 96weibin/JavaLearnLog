# MyEclipse常用配置

## 内存溢出处理

  在运行大的 项目的时候，默认的空间就不够充足，就会抛出内存溢出的异常

* TomCat内存溢出

```txt
-Xms258m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=256m
```

* jre内存溢出

```txt
```