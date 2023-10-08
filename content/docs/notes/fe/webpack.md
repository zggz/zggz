---
title: "Webpack"
weight: 1
date: 2022-05-12T17:20:59+08:00
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---


## extensions

## 补全规则
js支持不写后缀的引入方式,在引入的过程中会尝试补全扩展名或者路径

### 文件扩展名
如果加载的路径不携带文件扩展名，会尝试补全.ts、.tsx等文件扩展，在webpack中可以配置可能的文件扩展名，如下：

```js
resolve: {
    extensions: ['.ts', '.tsx', '.js']
    ...
}
```
如下，会尝试加载ts、tsx、js
```js
import A from 'a'
```

### 补全路径

在尝试文件扩展名之后，依然没有找到文件，但是发现该路径是一个目录，则会在改路径的目录下寻找`package.json`,如果存在则加载**package.json**中的main字段对应的文件，如果不存在则会尝试寻找目录下的index文件

## 妙用

在项目的开发过程中通常需要根据不同的参数加载不同的页面文件，通过webpack的extensions可以剥离业务代码耦合的情况下，分别加载。
### 实例
1. 入口文件app.js
    ```jsx
    import Home from "./Home"
    function App() {
    return (
        <div className="App">
            <Home/>
        </div>
    );
    }
    export default App
    ```
2. 需要加载的文件
- Home/index.js
    ```jsx
    function Home() {
    return <h1>TT Home</h1>
    }
    export default Home
    ```
- Home/index.tt.js
    ```jsx
    function Home() {
    return <h1>TT Home</h1>
    }
    export default Home
    ```
3. 在webpack中配置
    -  process.env.TYPE 可以通过cross-env 注入
    ```js
    resolve{
        extensions:[
            // 这里需要注意优先级需要写在前面
            `.${process.env.TYPE}.js`,
            '.js'
        ]
    }
    ```
4. 现在你可以在通过不同的type参数来控制程序打包时候加载的页面，并且对业务代码是无入侵的