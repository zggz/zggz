---
title: 算法和流程控制
date: 2019-02-06 11:17:51
tags: 性能
categories: javascript
---
# 循环类型
```js
// for循环
for(var i = 0; i<items.length; i++){}
// while循环
var i= 0; while(i<items.length){}
// do-while
var j = 10 ; do{}while(j<items.length)
// for-in
for(var key in object){
    // 函数体
}

// 每次循环所经历的步骤
1. 在控制条件中查找一次属性(items.length)
2. 在控制条件中执行一次数值比较(i<items.length)
3. 一次比较操作,查看控制条件的计算是否为true(i<items.length === true)
4. 一次自增(i++)
5. 一次数值查找(items[i])
6. 一次函数体执行
```
<!-- more -->

## 减少迭代的工作量
1. for-in循环每次迭代都需要搜索<font color = red>实例</font>和<font color = red >原型</font>,因此每次迭代会带来更多的开销，对比同等次数和环境for-in循环最终只有其他循环类型的<font color=red>1/7</font>
2.由于操作局部变量和字面量要比查找对象成员和数组项的查找要快，对于数组或者对象来说length一般是没有改变的所有通过缓存局部变量可以提高性能
```js
    // 大多数浏览器可以节约25%的时间，IE甚至可以节约50%
    for(var i = 0;len = item.length i<len; i++){}
```
3.通过改变数组顺序来提高循环性能:通常数组顺序与要执行的任务无关，倒序循环是编程语言中的一种通用性能优化方案，
  ```js
    // for循环
    for(var i = items.length; i--){}
    // while循环
    var i= item.length; while(i--){}
    // do-while
    var j = items.length-1 ; do{}while(j--)
    //以上控制条件只是简单的与0比较，控制条件从两次比较减少到一次，提高循环性能，一般可以提高50%-60%
    优化后每次循环所经历的步骤
    1. 一次比较操作，查看控制条件的计算是否为true(i === true)
    2. 一次自减(i--)
    3. 一次数值查找 (items[i])
    4. 一次函数体执行
    当复杂度为O(n)时，减少每次迭代的步骤次数是最有效的，当复杂度为大于O(n)时，建议着重减少迭代次数
  ```

## 减少迭代次数
duff‘s Device(达夫设备)是一种循环体展开技术，它使得一次迭代中实际执行了多次迭代。当循环次数超过1000的时候duff‘s Device的执行效率将明显提升，在500000次迭代中，其运行时间比 常规少70%

# 条件语句
1. 关于使用switch还是if-else，通常数量比较越大更倾向于使用switch而不是if-else。事实证明大多数情况下switch比if-else更快，当然是在一定数量的情况下。原因是当条件增加时if-else性能负担增加的程度比switch要多(大多数的语言对switch语句都采用了branch table(分支表)索引来进行优化，并且在switch语句比较值的时候使用全等===操作符，不会发生类型转换的消耗)
2. 通过构建数组作为查找表来替代条件语句，随着数量的增大也几乎不会产生额外的性能开销
# 递归
潜在问题是终止条件不明确或者说缺少终止条件会导致函数长时间运行，使用户界面处于假死状态。并且还有可能遇到浏览器的调用栈大小限制
1. 任何递归都能用迭代实现
2. 使用Memoization技术优化递归的重复计算
   - 是一种将函数返回值缓存起来的方法，Memoization 原理非常简单，就是把函数的每次执行结果都放入一个键值对(数组也可以，视情况而定)中，在接下来的执行中，在键值对中查找是否已经有相应执行过的值，如果有，直接返回该值，没有才 真正执行函数体的求值部分。很明显，找值，尤其是在键值对中找值，比执行函数快多了。
      ```js
      Fibonacci例子
      //递归调用
      function fibonacci(n){
      if(n==0||n==1){
            return n;
        }
        return fibonacci(n-1) + fibonacci(n-1);
      }
      //缓存优化 
      var fibonacci = function(){
        if(!memfactorial.cache){
          memfactorial.cache = {
            0:1,
            1:1
          }
        }

        if(memfactorial.cache.hasOwnPrototype(n)){
          memfactorial.cache[n] = n * fibonacci(n-1)
        }

        return memfactorial.cache[n]
      };
      ```