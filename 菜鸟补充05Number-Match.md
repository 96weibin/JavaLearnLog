# Number

java的各种基本类型，与js类似  都有  包装类

byte integer double float short long 都是number的子类、

number类属于java.long包

## Math类 的方法

Math类 被声明为 static类  所以 可以直接 Math.fun调用

方法 | 描述 | demo
-|-|-
xxxValue() | 将number对象转换为 xxx数据类型的值并返回 | x.longValue()
compareTo() | 将对象与参数比较 | x.compareTo(y)  同类型比较 x = y => 0; x < y => 1; x > y => -1;
valueOf() | 返回Number对象制定的内置数据类型|
equals() | 判断number对象是否与参数相等 |
parseInt() | 将字符串解析成 int |
abs() | 返回绝对值
ceil() | 向上取整
floor() | 向下取整
rint() | 返回最接近的整数 类型为 double
round() | 四舍五入
min() | 返回小的
max() | 返回大的
exp() | 求ln
log() | 求log
pow() | a的b次方 | a.pow(b)
sqrt() | 算数平方根
sin() | 正弦
cos() | 余弦
tan() | 正切值
asin() |
acos() |
atan() |
atan2()|
toDegrees() | 参数转化成角度
toRadians()| 角度转化成弧度
ramdom() |随机数
