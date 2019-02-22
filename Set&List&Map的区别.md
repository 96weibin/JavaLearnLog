# Set List Map的区别

## java集合与Array的关系

    在java中 数组长度固定、且数组内只能存放同一种类型(引用、基本)的数据
    而在java.util包中的java集合长度可变、单只能存储应用类型,但是可以存储不同类型的数据
    java集合都是根据数组封装的。

## Array

* Arrays类提供操作array的方法

  * equals()  比较数组相等
  * fill()    将值填入array中
  * sort()    排序
  * binarySearch()    在排好序的array中寻找元素
  * System.arraycopy()    复制array

## Collection接口

* collection 是java中最基本的集合接口、

* Collection 接口的方法

方法 | 作用 | 返回值
-|-|-
add(obj) | 向集合中假如一个对象的引用 | boolean
clear() | 删除集合中所有对象 | void
isEmpty() | 判断集合是否为空 | boolean
contains(obj) | 判断集合中是否有obj的引用 | boolean
Iterator() | 返回一个iterator对象 | Iterator
remove(obj) | 从集合中删除引用 | boolean
size() | 返回集合中元素的数目 | int
toArray() | 返回一个数组

## set

```java
Set s = new HashSet();
```

set集合继承了collection的方法、没有额外的方法、set内的元素不会重复、类似于json中的属性名

## List

```java
List arrList = new ArrayList();
arrList.add()
```

同样继承自collection 、有顺序的可以存储多种可重复的集合

方法 | 介绍 | 返回值
-|-|-
get(index) | 获取list的第index   从0开始
clear() | 清空 | void
size() | 个数 | int
toArray() | 转化成Array | object[]
isEmpty() | 判断是否为空 | boolean
addAll() | 和 | list
removeAll() | 差 | list
retainAll() |  交集 | list
isEmpty() | 判断是否是空集 | boolean
count(str) | 返回 括号内元素在 列中出现的次数

## Map

非继承自collection key不可重复、key与value 都可以是对象  无序的 集合

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

对象 | 特点 | demo
-|-|-
Array   | 有序、速度最快、length返回的是容量而非长度、类型单一、长度不可变 | [a,b,c,a,b,c]
set     | 有序、value不重复、可变长 | [a,b,c]
List    | 有序、value可重复、可变长 | [1,{},2,[],3]
Map     | 无序、key不重复           | [key1:value,key2:value]
