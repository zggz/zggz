---
title: hash和history的差异
date: 2020-11-19 00:18:12
tags: 浏览器
menu: main
---

## Introduction
浏览器导航
<!--more--> 
### #锚点
本来的用途是跳转到页内锚点。在URL中指定的是页面中的一个位置
- 改变#后面的参数不会触发页面的重新加载，但是会留下历史记录
- 单单改变#后的部分，浏览器只会滚动到相应位置，不会重新加载网页
- window.location.hash这个属性可读可写。读取时，可以用来判断网页状态是否改变；写入时，则会在不重载网页的前提下，创造一条访问历史记录。
- onhashchange事件,这是一个HTML 5新增的事件，当#值发生变化时，就会触发这个事件
###  hash
地址栏中的#，不会包含在http请求中
###  history
利用HTML5 History Interface 中新增的 pushState() 和 replaceState() 方法（应用于浏览器的历史记录栈），执行改API不会向后端发送请求
- history模式需要后端配合，刷新的时候需要后端返回根目录由前端导航
- window.location.hash这个属性可以对URL中的井号参数进行修改
### 其他
- hash模式下，使用锚点，会导致url变化，但是页面不会刷新；
- hash模式下，使用JS来计算滚动。