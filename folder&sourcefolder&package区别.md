# folder sourcefolder package的区别

    源于在跑别人的项目的时候对那个目录结构很懵逼,为啥com/main/resources包下面的文件一编译  跑到了 classes文件夹下面。我是到了公司后自学的Java,主要通过一份pdf学习的所以基础不是很好，有待提高。

## 关于区别

经过网上查阅资料得见

目录类别 | 连接上下级 | 声明位置
-|-|-
folder (普通的文件夹) | 用‘/’来连接上下级 | 任何位置
source folder (源文件夹) | 用‘/’连接上下级 | 声明在项目根目录,具有folder的所有功能，和自己特殊的功能。
package (包) | 用 ‘.’ 连接上下级 | 声明在 source folder下

## source folder的功能

* 来看下面的例子 这是项目在 myEclipse中 与 项目源文件 与 web环境中目录的表现形式

  ![source folder示例](http://96weibin-blog.oss-cn-beijing.aliyuncs.com/folder.png)

  从图中可以看到:

  1. source folder、package 已被我经圈出来了,就是这种类型的。

  2. 我已经将文件的对应 用 小粉色的线 连接了

  所以可以观察到：
  
    1. 在项目源文件的目录中,source folder 仍以正常的文件夹的形式显示,src/main/java、 src/test/java、 src/main/resources 这三个 source folder 合并同类相(突然感觉  数学没白学，可以拽);
    2. 而在 tomcat 编译web项目环境下, source folder 无论多长, 都不会管 source folder的名字，而将其下面的 package 下 Java文件 进行编译, 编译成 .class 文件 然后 package包管理这.class 一起放到了 WEB-INF > classes 文件夹下 ,而非java文件,不进行编译，也将其 放到了  这个文件夹下。

  那么是时候**总结**一下了。

    1. 在项目文件夹中，source folder 就是普通的文件夹。
    2. 而在 tomcat 编译web项目的情况下 source folder 就是项目的根目录，且可以有多个
    3. source folder 是为了tomcat编译 对项目文件夹的一种设置 方式。

  * 正常 Myeclipse创建的一个项目其中的src文件夹 也是 source folder,所以许多的配置文件 放在 src 目录下，在 xml中配置的时候  使用 classpath:/... 就能找到配置文件。

## Myeclipse 中 folder、source folder、 package之间的转化

右击想要转化的文件, buid path

source | target | order
-|-|-
->|->|
folder | package | Include
folder | source folder | Use as Source Folder
package | folder | Exclude
package | source folder | Use as source Folder
source folder | package | Remove From Build Path
source folder | folder | Remove From Build Path