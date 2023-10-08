---
title: 代理和反射
date: 2020-05-09 15:12:09
tags: JavaScript
---

代理(Proxy)是一种可以拦截并改变底层JavaScript引擎的操作包装器，在新语言中通过它暴露内部运作对象，从而让开发者可以创建内建对象
<!-- more -->


# 代理和反射

## 代理

调用new Proxy()可以创建代替其他目标对象的代理，虚拟化了目标，使其二者看起来功能一致，代理可以拦截JavaScript引擎内部目标的底层对象操作，这些底层操作被拦截后会触发响应特定操作的陷阱函数。

用Proxy构造函数创建代理需要两个参数： 目标(target)和处理程序(handler)，处理程序定义一个或者多个陷阱的对象，除去专门特定的操作定义外，其余操作均使用默认特性

```js
let t = {}
let p = new Proxy(t, {})
p.name = 'hello proxy'
console.log(p); // { name: 'hello proxy' }
console.log(t); // { name: 'hello proxy' }
```


## 反射

反射API以Reflect对象的形式出现，对象中的方法默认特性相应的底层操作一致。而每一个代理陷阱会对应一个命名和参数都相同的Reflect方法(其实就是每个代理陷阱都会对应一个Reflect api接口供覆写JavaScript底层操作)

代理陷阱特性

| 代理陷阱                 | 覆写的特性                                                   | 默认特性                           |
| ------------------------ | ------------------------------------------------------------ | ---------------------------------- |
| get                      | 读写一个属性值                                               | Reflect.get()                      |
| set                      | 写入一个属性                                                 | Reflect.set()                      |
| has                      | in操作                                                       | Reflect.has()                      |
| deleteProperty           | delete操作符                                                 | Reflect.deleteProperty()           |
| getAPrototypeof          | Object.getAPrototypeof ()                                    | Reflect.getAPrototypeof ()         |
| setAPrototypeof          | Object.setAPrototypeof ()                                    | Reflect.setAPrototypeof ()         |
| isExtensible             | Object.isExtensible()                                        | Reflect.isExtensible()             |
| preventExtensions        | Object.preventExtensions()                                   | Reflect.preventExtensions()        |
| getOwnPropertyDescriptor | Object.getOwnPropertyDescriptor()                            | Reflect.getOwnPropertyDescriptor() |
| defineaProperty          | Object.defineaProperty()                                     | Reflect.defineaProperty()          |
| ownKeys                  | Object.keys() 、 Object.getOwnPropertyNames()和 Object.getOwnPropertySysmbols() | Reflect.ownKeys()                  |
| apply                    | 调用一个函数                                                 | Reflect.apply()                    |
| construct                | 用new调用一个函数                                            | Reflect.construct()                |



## set陷阱验证(设置属性)

set陷阱接受4个参数：

- trapTarget 用于接受属性(代理目标)的对象
- key 要写入的属性键(字符串或者symbol类型)
- value 被写入属性的值
- receiver 操作发生的对象(通常是代理)

Reflect.set是set陷阱对应的反射方法和默认特性，

```js
let target = {
	name:'target'
}
let proxy = new Proxy(target, {
  // receiver 等同于 proxy
	set (trapTarget, key, value, receiver) {
		if (!trapTarget.hasOwnProperty(key)) {
			if (isNaN(value)) {
				throw new TypeError('属性必须是数字')
			}
		}
		return Reflect.set(trapTarget, key, value, receiver)
	}
})
proxy.count = 1
console.log(target.count); // 1
console.log(proxy.count); // 1
proxy.anotherName = 'proxy' // TypeError: 属性必须是数字
```

## get陷阱验证(获取属性)

JavaScript中的困惑行为，当读取一个不存在对象上的属性的时候，会返回undefined，而不是报错

```js
let target = {}
console.log(target.name) // undefined
```

可以通过get陷阱来检测，读取属性是否存在

接受三个参数

- trapTarget 目标对象
- key 读取的属性值
- receiver 操作发生的对象

```js
let proxy = new Proxy({},{
	get(trapTarget, key, receiver){
		if(!(key in receiver)){
			throw  new TypeError(`属性${key}不存在`)
		}
		return Reflect.get(trapTarget,key,receiver)
	}
})
proxy.name = 'proxy'
console.log(proxy.name) // proxy
proxy.nam  //  TypeError: 属性nam不存在
```



## has陷阱(in 操作符)

has陷阱覆写的特性是in操作符；in操作符的作用是来检测给定对象中是否包含某个属性，如果自有属性或原来属性匹配这个名称或Symbol 就返回true

```js
let target = {
	value:42
}
console.log('value' in target) // true
console.log('toString' in target) // true
console.log('name' in target) // false

```

使用in操作符会调用has陷阱

- trapTarget 
- Key 

```js
let target = {
	value:42,
	name: 'target'
}
let porxy = new Proxy(target,{
	has(trapTarget,key){
		if(key==='value'){
			return false
		}
		return Reflect.has(trapTarget,key)
	}
})
console.log('value' in porxy) // false
console.log('toString' in porxy) // true
console.log('name' in porxy) // true
```

## deleteProperty陷阱(delete  )

delete可以从对象中移除属性，成功返回true，反正返回false； `在严格模式下删除一个不可配置(noncoonfigurable)属性则会导致程序抛出错误，而非严格模式下只会返回false`

```js
let target = {
	name:'target',
	value:42
}

Object.defineProperty(target,'name',{configurable:false})
console.log('value' in target); // true
console.log(delete target.value); // true
console.log('value' in target); // false

console.log('name' in target); // true
// 严格模式  'use strict';
console.log(delete target.name); // TypeError: Cannot delete property 'name' of #<Object>
```

deleteProperty陷阱

- trapTarget 
- key

```js
let target = {
	name:'target',
	value:42
}

let proxy = new Proxy(target, {
	deleteProperty(traptarget, key){
		if(key==='value'){
			return false
		}
		return Reflect.deleteProperty(traptarget,key)
	}
})

console.log('value' in proxy); // true
console.log(delete proxy.value); // false
console.log('value' in proxy); // true
```



# 原型代理陷阱
