---
title: "Record"
weight: 1
date: 2022-04-30T14:40:49+08:00
tags: typescript
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---

# Record<Keys, Type>

[官方文档](https://www.typescriptlang.org/docs/handbook/utility-types.html#recordkeys-type)



定义一个对象的key和value类型

构造一个对象类型，其属性键为Keys，其属性值为Type。
此实用程序可用于将一种类型的属性映射到另一种类。

## 接口
```ts
// 定义
// type Record<K extends keyof any, T> = {
//     [P in K]: T;
// };
interface Person {
    age: number
    name: string
}
type School = 'student' | 'teacher'
const school: Record<School, Person> = {
    student: {
        name: 'tom',
        age: 12
    },
    teacher:{
        name: 'sam',
        age:20
    }
}
```
## 基础类型

```ts
type Num = "one" | "two"

const num: Record<Num, number> = {
    one:1,
    two:2
}
```


