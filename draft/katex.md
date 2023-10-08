---
title: 关于latex格式的前端渲染
date: 2019-02-26 23:28:00
tags: 
    - katex
    - MathJax
categories: katex
---

最近由于工作原因开始接触laex格式的渲染，主要是相关复杂公式的渲染数学公式、物理公式等；渲染方式主要有服务端渲染展示图片、前端渲染html形式展示公式；这里只说说前端渲染前的方式。以前也没有接触过类似的东西通过调研多个库，主要有MathJax、katex的渲染方式；这里主要讲katex的渲染方式。
<!--more-->
# 什么是latex？
摘自维基百科
<table><tr><td bgcolor=#eef0f4>LaTeX， 是一种基于TEX的排版系统，由美国电脑学家莱斯利·兰伯特在20世纪80年代初期开发，利用这种格式，即使用户没有排版和程序设计的知识也可以充分发挥由TEX所提供的强大功能，能在几天，甚至几小时内生成很多具有书籍质量的印刷品。对于生成复杂表格和数学公式，这一点表现得尤为突出。因此它非常适用于生成高印刷质量的科技和数学类文档。这个系统同样适用于生成从简单的信件到完整书籍的所有其他种类的文档。</td></tr></table>
简单的说
<table><tr><td bgcolor=#eef0f4>LaTeX 基于 TeX，主要目的是为了方便排版。在学术界的论文，尤其是数学、计算机等学科论文都是由 LaTeX 编写, 因为用它写数学公式非常漂亮。</td></tr></table>

# MathJax
MathJax的<a href="https://www.mathjax.org/">官网地址</a>，中文文档地址点<a href="https://mathjax-chinese-doc.readthedocs.io/en/latest/index.html">这里</a>

## 引入MathJax
官网cdn
<table><tr><td bgcolor=#eeffcc>&lt;script type="text/javascript" src="http://cdn.mathjax.org/mathjax/1.1-latest/MathJax.js"&gt;&lt;/script&gt;</td></tr></table>
因为MathJax是自动识别dom的，引入成功之后如果包含latex格式的标签会自动转换比如：

```html
<p>∵集合$$A=\left\{ x|x&lt;{}1 \right.$$或$$\left. x&gt;3 \right\}$$，$$B=\left\{ x|2x-4&gt;0 \right\}=\left\{ x|x&gt;2 \right\}$$，</p>
```

<!-- 渲染的结果是：![加载失败](/images/math.png) -->
与此同时官方也给我们提供了配置函数
```html
<!-- type必须是text/x-mathjax-config -->
<script type="text/x-mathjax-config">
window.MathJax.Hub.Config({
    showProcessingMessages: false, //关闭js加载过程信息
    messageStyle: "none", //不显示信息
    jax: ["input/TeX", "output/HTML-CSS"],
    tex2jax: {
        <!-- 由于MathJax 没有css 所以有些时候会出现样式不对，注意设置好 inlineMath、displayMath 属性-->
      inlineMath: [["$", "$"], ["\\(", "\\)"]], //行内公式选择符
      displayMath: [["$$", "$$"], ["\\[", "\\]"]], //段内公式选择符
      skipTags: ["script", "noscript", "style", "textarea", "pre", "code", "a"], //避开某些标签
       ignoreClass: "class1|class2" //避开 特定 标签
    },
    "HTML-CSS": {
      availableFonts: ["STIX", "TeX"], //可选字体
      showMathMenu: false //关闭右击菜单显示
    }
  });
</script>
```
默认情况是对我们整个DOM进行处理的，可以传递参数来指定渲染范围(可以极大的提高渲染性能)
```js
window.MathJax.Hub.Queue(["Typeset", MathJax.Hub, document.getElementById('app')]);
```
MathJax给我们提供了部分右键菜单通过设置可以控制显示 
```js
"HTML-CSS": {
    showMathMenu: false
}
```
![加载失败](/images/2.png)
默认的公式会有蓝框，我们可以通过设置样式覆盖修改样式
```css
蓝色的边框
.MathJax{outline:0;}
如果要改变字体大小
.MathJax span{font-size:15px;}
公式太长的时候会溢出
.MathJax_Display{overflow-x:auto;overflow-y:hidden;}
```
去掉加载信息，MathJax加载会在网页左下角看到加载情况，可以直接在MathJax.Hub.Config()里配置去掉
```js
MathJax.Hub.Config({
    showProcessingMessages: false,
    messageStyle: "none"
});
```

## 更多
更多关于tex2jax的配置<a href="http://docs.mathjax.org/en/latest/options/preprocessors/tex2jax.html">点击</a>

***
# katex 最快的公式渲染
katex是可汗学院推出的一种解析latex的库，具有简单的api、无依赖、高效、快速、服务器端渲染的js解析库；
特点：
1. 简单的API：不依赖其它 javascript库；
2. 快速：KaTeX 是将其数学同步且不需要回流页；
3. 输出质量：KaTeX 的布局是基于 Donald Knuth 的 Tex ，数学排版的黄金标准；
4.  服务器的渲染：无论浏览器或环境如何，KaTeX 输出保持一致，因此可使用 Node.js 预渲染表达式，并将其作为纯 HTML 发送。

<font color='red'>该库只支持纯粹的latex格式的渲染，如果包含html实体、或者标签将渲染失败</font>
<a href="https://katex.org">官网在此</a>

## 引入katex

1.通过cdn引入
```js
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.10.1/dist/katex.min.css" integrity="sha384-dbVIfZGuN1Yq7/1Ocstc1lUEm+AT+/rCkibIcC/OmWo5f0EA48Vf8CytHzGrSwbQ" crossorigin="anonymous">
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.10.1/dist/katex.min.js" integrity="sha384-2BKqo+exmr9su6dir+qCw08N2ZKRucY4PrGQPPWU1A7FtlCGjmEGFqXCv5nyM5Ij" crossorigin="anonymous"></script>
// 以下是一个自动渲染的插件
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.10.1/dist/contrib/auto-render.min.js" integrity="sha384-kWPLUVMOks5AQFrykwIup5lo0m3iMkkHrD0uJ4H5cjeGihAutqP0yW0J6dpFiVkI" crossorigin="anonymous"></script>
<script>
// 该defer属性 表示在页面加载之前不需要执行脚本，从而加快了页面呈现速度; 和onload属性调用 renderMathInElement一次自动渲染脚本负荷。
    document.addEventListener("DOMContentLoaded", function() {
        renderMathInElement(document.body, {
            // ...options...
        });
    });
</script>

```
*  integrity:是允许浏览器检查其获得的资源（例如从 CDN 获得的）是否被篡改的一项安全特性。具体信息请参考<a href="https://developer.mozilla.org/zh-CN/docs/Web/Security/%E5%AD%90%E8%B5%84%E6%BA%90%E5%AE%8C%E6%95%B4%E6%80%A7">web 安全|MDN</a>

*  defer：这个布尔属性被设定用来通知浏览器该脚本将在文档完成解析后，触发 DOMContentLoaded 事件前执行。如果缺少 src 属性（即内嵌脚本），该属性不应被使用，因为这种情况下它不起作用。对动态嵌入的脚本使用 `async=false` 来达到类似的效果。<a href="https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/script">script|MDN</a>

*  crossorigin:那些没有通过标准CORS检查的正常script 元素传递最少的信息到 {domxref('GlobalEventHandlers.onerror', 'window.onerror')}。可以使用本属性来使那些将静态资源放在另外一个域名的站点打印错误信息。<a href="https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/script">script|MDN</a>

当然还有AMD、ECMAScript module的引入具体请移步<a href="https://katex.org">官网</a>
如果使用了前端打包工具也可以使用npm引入
```js
npm install katex / yarn add katex
// 这样全局就会 有katex
import katex from 'katex';
// 别忘了引入css
import 'katex/dist/katex.min.css'
```
## API
### katex.render
该方法会将公式渲染的结果返回到elemnet里
```js
// 官方实例
katex.render("c = \\pm\\sqrt{a^2 + b^2}", element, {
    throwOnError: false
});
// 如果需要转义那么可以这样
katex.render(String.raw`c = \pm\sqrt{a^2 + b^2}`, element, {
    throwOnError: false
});
请注意本地复制代码测试的时候要去掉转义字符,不然会出现错误
```
### katex.renderToString
该渲染方法会将生成的dom结构输出到html
```js
var html = katex.renderToString("c = \\pm\\sqrt{a^2 + b^2}", {
    throwOnError: false
});
```
### renderMathInElement
插件的使用，引入插件的js后，会获得一个全局的函数renderMathInElement
```js
document.addEventListener("DOMContentLoaded", function() {
        renderMathInElement(document.body, {
            // ...options...
        });
    });
```
该函数提供两个参数，第一个提供dom节点就是说会渲染该dom节点下的公式元素（尽可能的精确会提高性能），第二个参数是分隔符配置文件，将分隔符以内的字符串会进行katex渲染，配置如下 
```js
// display设置为true会被渲染成块元素，false是行内元素
 {
  delimiters: [
    {left: "$$", right: "$$", display: false},
    {left: "\[", right: "\]", display: true},
    {left: "$",  right: "$",  display: false},
    {left: "\(", right: "\)", display: false }
  ]
}
```
这些就是katex的基本api，具体的使用请参考<a href="https://katex.org">官网</a>
## 总结
不管是render、还是renderToString都只支持纯公式的渲染一旦包含标签或者其他不是公式的元素字符串那么就会渲染失败，而renderMathInElement插件的渲染虽然良好的支持各种标签混合的字符串处理，但是又不能支持字符串的输出。我简单的修改了下renderMathInElement的源码使之能输出DOM字符串可以直接渲染，如果你使用vue那么会很方便的使用v-html渲染，这样就解决了后端请求的时候的少量渲染，并且不会引起大量的重绘、回流。
<!-- * <a href="https://github.com/HUSTER-Qin/tal-katex">源码点这儿</a> -->

* npm 集成<a href="https://github.com/zggz/v-katex.git">v-katex</a>