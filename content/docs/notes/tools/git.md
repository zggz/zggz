---
title: git命令
date: 2020-11-19 00:18:12
tags: git
menu: main
---

## 常见配置
### 配置全局
- git config --global user.name 'global'
- git config --global user.email 'global@global.com'

### 查看配置
- git config user.name # global
- git config user.email # global@global.com


## 分离工作和个人
- 公司项目都在 work 目录下，给这个目录搞个配置，只要这个目录下的就是 workname 而不是 global
1.  首先创建一个文件
```sh
sudo vim ~/.gitconfig-work # 这个文件和 .gitconfig 同一目录好管理

```
2.  内容
```sh
# ～/.gitconfig-work

[user]
    name = workname
    email = workname@company.com 
```
3. 修改.gitconfig
```sh
# ～/.gitconfig

[http]

...

[includeIf "gitdir:~/work/"]
    path = .gitconfig-work
```
## 常用操作
### 批量删除本地分支
- git branch | grep -v 'master' | xargs git branch -D
## 常见问题
1. 本地与远程的分支列表不一致(在gitlab管理界面删除分支之后)
    ```sh
    git remote update origin --prune
    ```
2.  error: failed to push some refs to
    ```sh
    git pull --rebase origin master
    git push -u origin master
    ```
3. 拉取git子模块
    ```sh
    git submodule update --init --force
    ```


