# Linum

## Linux的历史

    大学教授参考unix编写的minix用于教学得到好评但是不开源、后来他的学生写的linux开源、发展成现在常用的linux

## linux文件系统

### 命令，功能

操作指令|功能
-|-
ls | 显示当前目录下文件(不包括隐藏文件)
ls -a | 显示当前目录下所有文件(包括隐藏文件)
ls -a ~ | 显示主目录下所有文件(用户目录)
ls -l | 查看长格式
pwd | 显示当前路径
cd . | 当前目录
cd / | 从最外面的开始（绝对路径）
cd .. | 跳转上级目录
cd \ | 跳转主目录
cd ~ | 切换到用具目录
cd D: | 切换 到D 盘根目录
cd file | 跳转到 当前路径下的file
mkdir file | 在当前路径下创建file文件夹
mkdir .file | 在当前路径下创建 隐藏文件 .file
mv oldFile newName | mv可以用来重命名
mv sourceFile newPlace | 移动sourceFile到newplace
cp file place | 将文件拷贝到place
rm -rf file | 在当前路径下删除（r 递归 f强制） file文件夹
echo abc | 将abc显示到控制台

### 标准输出

**>**输出重定向符号,可以将标准输出从定向到文件
**cat**查看文件

```shell
ls > abc.txt
cat abc.txt
```

### 管道符号“|” 与 信息过滤“grep”

**|** 管道符号， 连接两个命令，将前一个命令的输出作为后一个命令的输入。

**grep**过滤输入信息、留下符合条件的

![grep](http://96weibin-blog.oss-cn-beijing.aliyuncs.com/18-11-26/79318415.jpg)

### 文件授权

* ls -l 查看长格式

![ls-l](http://96weibin-blog.oss-cn-beijing.aliyuncs.com/18-11-26/57832870.jpg)

1. 文件授权信息(第一位是 "-" 代表 普通文件, 是"d"代表是目录 隐藏目录也是目录)
2. 目录中的第几个文件、文件编号
3. 登录用户(谁创建的就是谁的,低级用户不能删除root创建的  root可以删除低级用户的)
4. 组
5. 文件长度
6. 创建时间

### 文件授权信息

    * r read 可读
    * w write 可写
    * x excute 可执行

上图中的文件授权信息分别是

    * 登录用户  u
    * 组用户    g
    * 其他用户  o

#### 修改文档权限

命令 | 功能
-|-
chmod -x file | 去掉可执行权限
chmod +x file | 添加可执行权限
chmod -r file | 去掉可读权限
chmod +r file | 添加可读权限
chomd -w file | 去掉可写权限
chomd +w file | 添加可写权限

通过上面的方法将所有用户的权限都更改了

结合上面授权信息 可以实现对 某个用户的权限的更改

```shell
chmod o-w text
```

给 other 用户取消可写权限

* 数字权限

```shell
chmod 666 file
```

常用数字 | 表示的权限
-|-
0 | ---
1 | --x
2 | -w-
3 | -wx
4 | r--
5 | r-x
6 | rw-
7 | rwx

### 文件的创建与修改

#### echo 回显命令

```shell
echo abc
```

将 abc 输出到控制台

#### 输出重定向

```shell
echo abc > demo.txt     #  >表示覆盖
echo abc >> demo.txt    # >>表示追加
```

#### 修改和创建文本文件 vi file

**命令模式下** ： i a o 进入输入模式
**输入模式下** ： esc 进入命令模式 可执行命令
**命令模式下** ： "：q" 退出  ":q!" 强制退出  ":qw"保存后退出

打开文件

```vim
vi index.html
```

![vim](http://96weibin-blog.oss-cn-beijing.aliyuncs.com/18-11-26/49348253.jpg)

**esc**进入命令模式

**/root** 搜索root

**?** 向前查找

**/** 向后查找

**n** 下一个

**cat** 查看文件内容

**touch** 创建新空白文件、修改文件访问时间

##### 传统的unix压缩打包命令

tar压缩命令格式

```vim
tar 参数 压缩包名 待压缩文件
```

不压缩打包

```shell
tar -cf works.tar work1 work2 work3
tar -cvf works.tar.gz work1 work2 work3 # 可以看到打包过程
```

压缩打包

```shell
gzip works.tar
```

* 解压缩

```shell
gzip -d works.tar.gz
tar -xf works.tar
```

##### linux压缩命令

* 压缩

```shell
tar -czf works.tar.gz work1 work2 work3
```

* 解压缩

```shell
tar -xzf ../works.tar.gz
```

#### zip打包预释放 （直接用这个不好么）

```shell
zip -r file.zip file1 file2 file3 # 压缩  -r 连带子目录一起打包
unzip file.zip              # 解压缩
```

### 环境变量

#### 查看环境变量

```shell
echo $PATH
```

![$path](http://96weibin-blog.oss-cn-beijing.aliyuncs.com/18-11-26/88942801.jpg)

* $PATH 虚招操作系统可执行命令的路径
* linux/Unix中 使用冒号 ':' 进行分割 windows 使用分号 ';'
* whoami :显示当前系统登录用户

#### 设置环境变量

```shell
export PATH=/ # 修改环境变量为 / 只能找到 /中的变量

echo $PATH  # 只剩下 一个 /
```

如果 不能执行 ipconfig
修改环境变量

```shell
export PATH=$PATH:sbin
```

#### windows cmd 配置环境变量

```shell
set PATH=%PATH%;c:Program Files\EditPlus # 设置环境变量
```

操作系统 | 配置环境变量 | 查看环境变量
-|-|-
windows | set | echo %PATH%：
linux   |export| echo $PATH

#### PATH CLASSPATH JAVAHOME

* JAVA_HOME jdk的安装目录、让需要的应用能找到jdk
* PATH  jdk下的bin 的目录  将jdk的命令拓展到os
* CLASSPATH java类部署、或者jar文件 jvm 会在这个路径搜索

* windows 命令实例

```shell
set JAVA_HOME=C:\Program Files\Java\jdk
set CLASSPATH = .
set PATH=C:\Program Files\java\jdk\bin;%PATH%
```

### linux Windowx 命令对照

windows | linux
-|-
dir | ls
mkdir | mkdir
cd | cd
del | rm
cls | clear
more | more
type | cat
move | mv
copy,xcopy | cp
help | man

```linux
man chmod
```

查看 chmod 的帮助文档