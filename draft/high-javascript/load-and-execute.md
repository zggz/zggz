---
title: 加载与执行
date: 2019-01-31 15:20:48
tags: 性能
categories: javascript
---

# 概述
多数浏览器使用单一进程来处理用户界面（UI）刷新和javascript脚本的执行，所以同一时间只能做一件事，js执行时间越久，浏览器等待响应时间就越长。script标签的每次出现，页面会等待脚本的解析和执行；不管是和内联好还是外链，页面的下载和渲染都必须等待脚本 的执行。这个过程中的页面交互式完全阻塞的。
<!-- more -->
## 脚本位置  script标签位置
1. 浏览器在解析到body标签之前不会渲染任何页面，如果把脚本放在顶部，通常表现为<font color=red >页面空白</font>
2. 每个脚本必须等到前一个脚本<font color=red >下载完成</font>、<font color=red >执行完成</font>才会开始下载和执行；瀑布图中显示的下载间隔刚好是前一个脚本的执行时间
- 结论：推荐将所有的<script\>标签尽可能的放到<body>标签的底部，以尽量减少对整个页面下载的影响

## 组织脚本
1. 由于每个<script\>标签的初始下载都会阻塞页面的渲染，减少页面包含的<script\>标签有利于改善性能；
2. 考虑到http的网络消耗，下载单个100k会比4个25k要快同时浏览器解析html页面每遇到一个脚本标签，都会因为执行脚本导致一定的延迟，因此脚本的数量也需要限制。
3. （Steve Souders）把内联的脚本放在<link\>标签之后,也会导致页面阻塞去等待样式表的下载。（目的：确保内嵌脚本在执行时能或得最精准的样式信息），建议永远不需要把内嵌脚本放在<link\>标签之后
4. 脚本合并：通常将多个文件合并成一个文件下载，比如Yahoo的合并处理器

```js
1.静态资源打包：服务器将多个文件合并成一个文件
<script src="http://a.tbcdn.cn/??s/kissy/1.1.6/kissy-min.js,p/global/1.0/global-min.js,p/et/et.js?t=2011092320110301.js"></script>
针对上面这个案例，那么服务器端你在这个请求的接口里，根据js参数的值，把a.js到e.js的内容读取出来，再合并成一个文件（一般同时还会压缩，比如去空格，比如缩短变量名等），输出到客户端。如果服务器端再加上缓存，那可能连合并都不需要了。这样页面加载速度会快非常多。比较常用的js打包工具有google的google closure，css用yui compressor。
```
## 无阻塞脚本
核心在于页面加载完成后才加载javascript代码，意味着window对象的load事件触发后在加载脚本
1. 并行下载<script\>标签在下载外部资源不会阻塞其他的<script\>标签。虽然脚本的<font color=#9B30FF >下载过程</font>不会相互影响，但是页面仍然会等待所有的脚本下载并执行才能继续。
2. 扩展属性（共同点都是并行下载）
    * defer:（html4）指明本元素所包含的脚本不会修改dom，代码可以安全的延迟执行（只有IE支持），该属性会在并行下载后等待<font color=green >页面完成后执行</font>；任何带有defer属性的javascript文件下载时，它不会阻塞浏览器的其他进程，因此这类文件可以与页面其他资源并行下载(仅当src属性声明时才生效)
    * sync:（html5）加载完成后<font color=green >自动执行</font>
     ![image](/images/1.png)
## 动态脚本元素
动态添加脚本元素到页面，使用动态脚本下载，返回的代码通常会立即执行
```js
function loadScript(url,callback){
    var script = document.createElement('script')
    script.type = 'text/javascript'
    if(script.readyState){
        // 兼容IE
        script.onreadystatechange  = function(){
            if(script.readyState=='loaded'||script.readyState=='complete'){
                script.onreadystatechange = null
                callback()
            }
        }
    }else{
        script.onload = function(){
            callback()
        }
    }

    script.url = url
    document.getElementsByTagName('head')[0].appendChild(script)
}
// 调用 将代码放到body闭合标签前；1）确保js执行不会阻塞页面；2）避免监听其他事件比如window.onload
loadScript('test.js',function(){
    // do something
})
可以使用YUI3、LazyLoad、LABjs来完成类似的工作
```
# 小结
1. 将所有脚本放在页面的底部加载执行
2. 合并脚本
3. 无阻塞下载
    - defer属性、sync属性
    - 动态脚本元素
    - xhr下载脚本注入