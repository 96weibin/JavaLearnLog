# Maven(行家)

- apache的一个项目管理综合工具、对项目进行创建，依赖管理。

## Maven功能

构建、文档生成、报告、依赖、SCMs、发布、分发、邮件列表。

## 安装&&配置Maven

### 安装

1. [官网下载](http://maven.apache.org/download.cgi)

2. 配置环境变量

    - 要先配置好JAVA_HOME

    - M2_HOME、MAVEN_HOME 为文件解压目录

    - PATH添加 ;%M2_HOME%\bin

3. 验证是否安裝成功

```cmd
mvn -version
```

### 在myEclipse上配置Maven

在 Window Preference MyEclipse Maven4MyEclipse

配置 Installations 添加本地安装的maven

User Settings 中更改 setting.xml为本地安装的 Maven 的 setting.xml

### 下载jar包

[maven 下载链接](http://maven.ibiblio.org/maven/)

### Maven创建java项目

## Maven POM

依赖、插件、执行目标、项目构建profile、项目版本、开发者列表、相关邮件列表

```xml
<project xmlns = "http://maven.apache.org/POM/4.0.0"
xmlns:xsi = "http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation = "http://maven.apache.org/POM/4.0.0
http://maven.apache.org/xsd/maven-4.0.0.xsd">

<!-- 模型版本 -->
<modelVersion>4.0.0</modelVersion>

<!-- 公司或者组织的唯一标志，并且配置时生成的路径也是由此生成， 如com.companyname.project-group，maven会将该项目打成的jar包放本地路径：/com/companyname/project-group -->
<groupId>com.companyname.project-group</groupId>

<!-- 项目的唯一ID，一个groupId下面可能多个项目，就是靠artifactId来区分的 -->
<artifactId>project</artifactId>

<!-- 版本号 -->
<version>1.0</version>
</project
```