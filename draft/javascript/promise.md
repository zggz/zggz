---
title: promise
date: 2020-05-06 21:40:35
tags:
---

Javascript引擎基于单线程事件循环，同一时间只运行一个代码块运行；反之多线程是运行多个代码块同时执行。

所以JavaScript需要跟踪即将运行的代码，将这些代码放在一个任务队列中，当代码准备执行的时候都会添加到任务队列中，当一段代码执行结束，事件循环会执行队列下一个任务。`队列中的任务会从第一个一直执行到最后一个`

- 事件模型：用户点击键盘或者触发类似onclick事件，会想任务队列增加一个任务来响应用户的操作，直到事件触发才执行事件处理程序，这是JavaScript中最基础的异步编程

- 回调模式：Nodejs通过普及回调函数拉改进异步编程模型，异步代码会在未来某个时间执行，回调模式中被调用的函数式作为蚕食传入的。

<!-- more -->

# Promise基础

promise相当于一个异步操作结果的占位符，它不会去订阅一个事件，也不会传递一个回调函数给目标，而是返回一个Promise。

```js
// readFili承诺将来某个时刻完成
let promiss = readFile('example.txt')
```

## 创建Promise

```js
let fs = require('fs')
function readFile () {
	return new Promise((resolve, reject) => {
		fs.readFile('filename', {encoding:'utf8'},function(err, con) {
			if (err) {
				reject(err)
				return
			}
			resolve(con)
		})
	});
}
```

## Promise.resolve

只接受一个参数，并返回一个完成态的Promise；如果传入的是一个Promise，那么换个Promise会被立即返回

```js
let p1 = Promise.resolve(42)
p1.then(value=>console.log(value)); // 42
```

## Promise.reject

只接受一个参数，并返回一个拒绝的Promise；如果传入的是一个Promise，那么换个Promise会被立即返回

```js
let p1 = Promise.reject(42)
p1.catch(value=>console.log(value));
```

## 生命周期

- pending 进行中，操作尚未完成，所以是未处理，一旦操作结束会进入到下一个状态

- Fulfilled 异步操作完成
- Rejected 异步操作未能完成

内部属性[[PromiseState]]被用啦表示3种状态；"pending"、"fulfilled"、"rejected"。这个属性不暴露，所以不能通过编程的方式检测promise状态，只有当promise状态改变，通过then方法拉采取特定行动

## 全局拒绝处理

浏览器环境的拒绝处理：

在浏览器中可以通过监听window事件来识别未处理的拒绝

```js
let rejected;
window.onunhandledrejection = function(event){
  console.log(event.type);  // unhandledrejection
  console.log(event.reason.message); // Explosion
  console.log(rejected === event.promise);	// true
}
window.onrejectionhandled = function(event){
  console.log(event.type);
  console.log(event.reason.message);
  console.log(rejected === event.promise);	
}
rejected = Promise.reject(new Error("Explosion"))
```

Nodejs环境的拒绝处理:

在node中处理promise拒绝时候会触发processs上的事件

- unhandleRejection 在一个事件循环中，当promise被拒绝，并且没有提供相应拒绝程序的时候调用
- rejectionHandled 在一个事件循环后，当promise被拒绝，并且没有提供相应拒绝程序的时候调用

```js
let rejected;

process.on('unhandledRejection', function(reason, promise){
  console.log(reason); // 'Explosion'
  console.log(rejected === promise) true
})

rejected = Promise.reject(new Error("Explosion"))
```

## Promise 串联

每次调用then方法或者catch方法实际会创建并返回另一个promise，只有当第一个完成或者被拒绝后，第二个才会被解决

```js

let p1 =  new Promise((resolve, reject) => {
	resolve(42)
});
p1.then(value => {
	console.log(value);
}).then(() => {
	console.log('finish');	
}).catch(err => {
	console.log(err);
})
// 42
// finish
```
```js

let p1 = Promise.resolve(1)

let px = function name(params) {
    return new Promise((resolve, reject)=>{
        setTimeout(()=>{
            resolve(2)
        },2000)
    })
}
let arr = [px, undefined]

arr.unshift((value)=>{
    console.log(value, '3==');
    return 3
},(value)=>{
    console.log(value, '4==');
    return 4
})
arr.push((value)=>{
    console.log(value, '5==');   
    return 5
},(value)=>{
    console.log(value, '6==');
    return 6
})

while (arr.length) {
    p1 = p1.then(arr.shift(), arr.shift())
}
// 1 3==
// 等待 2s 后
// 2 5==
```
promise链的返回值，下一个promise会在上一个完成之后才会执行； 如果在完成处理的程序中返回值，则可以沿着这条链继续传递数据

```js

let p1 =  new Promise((resolve, reject) => {
	resolve(42)
});
p1.then(value => {
	console.log(value);
	return value +1
}).then((value) => {
	console.log(value);	
}).catch(err => {
	console.log(err);
})
//42 
// 43
```

同样错误也可以返回值继续传递，在必要的时候，即使其中一个promise失败也能恢复整个promise链的执行

```js
let p1 =  new Promise((resolve, reject) => {
	reject(42)
});
p1.catch(value => {
	console.log(value);
	return value+1
}).then(value => {
	console.log(value);
})
// 42
//43
```

## Promise.all

接受一个参数，并返回一个promise，该参数是一个含有`多个`受监视的Promise对象（比如数组），只有当`所有`Promise都被解决后返回的Promise才会被解决，只有当可迭代对象中所有的Promise都被完成返回的Promise才会被完成。

被解决的值是按照顺序储存的，可以根据每个结果来匹配Promise

所有传入的Promise只要一个被拒绝，那么返回的Promise不会等到都完成，而是立即拒绝

```js
let p1 = Promise.resolve(42)
let p2 = Promise.resolve(43)
let p3 = Promise.resolve(44)
Promise.all([p1, p2, p3]).then(value => {
	console.log(value); // [42,43,44]
})
// 拒绝
let p1 = Promise.resolve(42)
let p2 = Promise.reject(43)
let p3 = Promise.resolve(44)

Promise.all([p1, p2, p3]).then(value => {
	console.log(value);
}).catch(err => {
	console.log(err); // 43
})
```

## Promise.race

接受一个参数，并返回一个promise，该参数是一个含有`多个`受监视的Promise对象（比如数组），`只要有一个`Promise被解决后返回的Promise就会被解决，无需等到所有的Promise都完成，只要当可迭代对象中有的Promise被完成返回的Promise才会被完成。

- 实际上Promise.race会进行竞选，如果先解决的是已完成，则返回已完成的Promise；如果先解决的是已拒绝，则返回已拒绝的Promise

```js

let p1 = Promise.resolve(42);
let p2 = Promise.reject(43)
let p3 = Promise.resolve(44)

Promise.race([p1, p2, p3]).then(value => {
	console.log(value); // 42
}).catch(err => {
	console.log(err);
})
// 竞选
let p1 =  new Promise((resolve, reject) => {
	setTimeout(() => {
		resolve(42)
	},10)
});
let p2 = Promise.reject(43)
let p3 = Promise.resolve(44)

Promise.race([p1, p2, p3]).then(value => {
	console.log(value);
}).catch(err => {
	console.log(err); // 43
})
```



# Promise的继承

由于静态方法绘本继承，因此派生类也会拥有resolve、reject、all、race等方法

```js
class MyPromise extends Promise{
	success (resolve, reject) {
		return this.then(resolve, reject)
	}
	failure (reject) {
		return this.catch(reject)
	}
}
let pro = new MyPromise(function (resolve, reject) {
	resolve(42)
})
pro.success(value => {
	console.log(value);	 // 42
}).failure(err => {
	console.log(err);
})
```















