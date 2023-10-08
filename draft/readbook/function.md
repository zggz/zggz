---
title: 函数式编程
date: 2020-06-25 12:31:44
tags: Javascript
---

# 函数式编程

使用函数来抽象作用在数据之上的控制流与操作，从而在系统中消除副作用并减少对状态的改变
函数式编程指创建不可变的程序，通过消除外部可见的副作用，来对纯函数的声明式的求值过程

<!--more-->

优点

1. 任务分解为简单函数
2. 流式调用链来处理
3. 响应式降低事件驱动代码的复杂性



## 声明式编程

1. 命令式编程: 具体的告诉计算机如何执行某个任务;旨在尽可能的提高代码的`无状态`和`不变性`

   ```js
   let array = [1, 2, 3, 4, 5, 6, 7, 8, 9]
   for (let i = 0; i < array.length; i++) {
       array[i] = Math.pow(array[i],2)
   }
   ```

2. 声明式编程：将程序的描述和求值分开，更加关注于如何用表达式来描述程序逻辑，而并不一定需要指明控制流或者状态的变化

    ```js
    array.map(num => Math.pow(array[i], 2))
    ```




## 纯函数

没有副作用和状态变化的函数

1. 仅取决于输入，而不依赖于任何在函数求值期间或者调用间隔可能变化的隐藏状态和外部状态
2. 不会造成超出其作用域的变化；例如全局参数或者引用传递

常见副作用

1. 改变全局变量
2. 改变函数参数初始值
3. 处理用户输入
4. 抛出异常
5. 打印，记录日志
6. 查询html文档、浏览器cookie等

引用透明：



## 引用透明

如果一个函数对于相同的输入，始终产生相同的结果，那么就说他是引用透明的

## 不可变性

创建之后不能更改的数据



# javascript 函数

##  一等函数

```js
function multiplier(a,b) {
    return a*b
}
let multiplier = function (a, b) {
    return a * b
}
let multiplier = (a, b) => a * b
let multiplier = new Function('a','b','return a*b')
```

## 高阶函数

作为函数的参数传递，或者由其他函数返回，这些函数被称为高阶函数

```js
let multiplier = (a, b) => a * b

function applyOperation(a,b,opt) {
    return opt(a,b)
}
applyOperation(2,3,multiplier) // 6

function add(a){
  return function(b){
    return a+b
  }
}

add(3)(3) // 6
```



# 闭包和作用域

## 闭包

闭包是一种能够在函数`声明过程中`将环境信息与所属函数绑定不再一起的数据结构
基于函数声明的文本位置，因此也被称为围绕函数定义的静态作用域或词法作用域

函数闭包

1. 函数的所有参数
2. 外部所有变量

### 闭包的实际应用

- 模拟私有变量

- 异步服务调用

- 创建人工块作用域变量

#### 模拟私有变量

一些库或者模块使用闭包来隐藏整个模块的私有方法和数据。被称为模块模式，采用了立即执行函数（IIFE）

```js
var myModule = (function (ex) {
    let _privateVar = '私有变量'

    ex.method = function () {
        
    }
}) (myModule||{})
```

#### 异步服务端调用

提供回调函数来处理请求





## 作用域

### 全局作用域

任何对象和在脚本最外层声明的（不在函数中声明）变量都是全局作用域的一部分

### 函数作用域

任何在函数中声明的任何变量都是局部且外部不可见的。

作用域机制

1. 首先检查变量的函数作用域
2. 如果不是局部作用域内，逐层向外检查各词法作用域，直到全局作用域
3. 如果无法找到变量引用，那么JavaScript会返回undefined

### 伪块作用域

with语句与块作用域类似，但是不被建议使用，在严格模式下被禁止

有歧义的循环计数器

```js
var arr = [1, 2, 3, 4]

function processArr() {
    function multipleBy10(val) {
        i = 10 // 导致 i 被改写
        return i * val
    }
    for (var i = 0; i < arr.length; i++) {
        arr[i] = multipleBy10(arr[i])
        
    }
    return arr
}
console.log(processArr()); // [10,2,3,4]
```
let、const解决了置顶问题



