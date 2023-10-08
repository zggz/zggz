---
title: "Terminal"
weight: 1
date: 2022-05-08T02:17:04+08:00
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---


## 终端的相关快捷键

- `control + a` 移动到行首
- `control + e` 移动到行尾巴


## 常见命令

### mkdir
创建新的文件夹
```sh
# 创建一个权限为777的文件夹
mkdir -pv -m 777  /user/test
```
- p: 确保目录名称存在，不存在的就建一个（递归创建）
- m: 设置权限
- v: 显示创建过程信息
