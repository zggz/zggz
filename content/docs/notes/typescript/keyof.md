---
title: "Keyof"
date: 2022-05-07T15:56:35+08:00
tags: typescript
---

# keyof

该操作符用于获取某种类型的所有键,其返回的类型是联合类型

###  获取类型
```ts
interface Ponit{
    x:number
    y:number
}

type P = keyof Ponit // 'x' | 'y'
```
### 索引签名
```ts
type Arrayish = {
    [n:number]: unknown
}
type A = keyof Arrayish // number

```

## 常用场景
定义一个函数，通过key来获取对象的值，通常我们并不知道对象包含的key集合
```ts
function getObject<T extends object, K extends keyof T>(obj:T, key:K){
    return obj[key]
}
const point = {
    x: 12,
    y:13
}
getObject(point,'x')
getObject(point,'z') //类型“"z"”的参数不能赋给类型“"x" | "y"”的参数。
```

