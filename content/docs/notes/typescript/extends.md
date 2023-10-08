---
title: "Extends"
weight: 1
date: 2022-05-07T22:05:55+08:00
tags: typescript
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---

# extends
[官方文档](https://www.typescriptlang.org/docs/handbook/2/objects.html#extending-types)

接口继承和类型判断

## 继承扩展
```ts
interface Person{
    name: string
}

interface Sudent extends Person{
    age: number
}
// Student => {name: string ge:number}
```

## 泛型约束
- 在使用泛型的时候，可以通过extends来对类型参数的限制；
- 以下的案例可以限制obj传入的对象必须包含name字段
```ts
function getName<T extends {name:string}, K extends keyof T>(obj:T, key:K){
    return obj[key]
}
```
## 条件判断
- 当`extends`和`type`一起使用的时候，会作为条件判断
- 如果extends前面的类型能够赋值给extends后面的类型，那么表达式判断为真，否则为假。
- `extends`前面的类型一定包含后一个类型
```ts
interface Point{
    x: number
    y: number
}
interface PointY{
    y:number
}
type P = Point extends PointY ? 'string' : 'number'
// P => string
// 满足Point 一定能满足 PointY
```
### 分配条件类型
```ts
type P<T> = T extends 'x' ? string : number;
type A3 = P<'x' | 'y'>  // A3的类型是 string | number
```
这里实际上类似于分配律 `P<'x' | 'y'> => P<'x'> | P<'y'>`

### 特殊never
never是所有类型的子类型
```ts
type A1 = never extends 'x' ? string : number; // string
type P<T> = T extends 'x' ? string : number;
type A2 = P<never> // never
```
### 阻止分配
将泛型使用[]括起来，防止分配
```ts
  type P<T> = [T] extends ['x'] ? string : number;
  type A1 = P<'x' | 'y'> // number
  type A2 = P<never> // string
```