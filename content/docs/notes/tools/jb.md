---
title: "2022年JB开发工具"
weight: 1
date: 2022-05-15T10:42:13+08:00
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---

## 且用且珍惜，支持正版

JB的激活方式有账号激活、激活码、服务器三种

## 服务器激活

### 打开网站 
https://search.censys.io/

![image](/images/jb/jb-1.png)

### 搜索
```sh
services.http.response.headers.location: account.jetbrains.com/fls-auth
```
![image](/images/jb/jb-1-1.png)

### 查找
点击搜索，在返回的结果随便找一个点进去，查找到HTTP/302

### 激活
![image](/images/jb/jb-2.png)
- 复制网址到jb，选择许可证服务器/License server，粘贴刚刚复制的网址，激活。

### 重试
![image](/images/jb/jb-3.png)
- 如果失败，换一个就试一试就好



## 脚本激活

### 地址
- 获取相关工具的地址 https://jetbra.in/s

### 操作
- 将下载的zip解压到指定位置，不再移动
- `cd scripts` 执行install脚本
- 重启IDE
- 再去上面的网站获取对应的code 完成激活