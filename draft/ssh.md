---
title: github 免登录
date: 2019-02-02 01:49:08
categories: git
tags:
- github
- ssh
---

github支持ssh公钥的登录,在github同步公钥后不再需要输入账号密码，就可以实现git的相关操作
<!--more-->

# 客服端生成公钥
在客服端执行 ssh-kengen -t rsa -C “email@address” 一直回车（期间可以输入验证串，那么以后也会输入该串配对验证，一般不需要）即可在生成公钥和私钥
```sh
cd ~/.ssh
```
可以看到id_rsa.pub就是我们所生成的公钥
```sh
# 推送到远程服务器
ssh-copy-id user@server
```

# 配置github
添加公钥到github账号
使用网页登陆github，在settings–>ssh keys–>add key
把id_rsa.pub 里面的公钥复制到这类，title随便取一个名字就可以了

# 测试账号
```sh
ssh git@github.com

Hi xxxx! You've successfully authenticated, but GitHub does not provide shell access.
表示连接成功
```

# 克隆项目
git clone git@github.com:username/projectname.git

注意事项<font color=red>切记一定要采用git@github.com</font>的ssh模式不然会报错

# git设置全局用户名
git config --global user.name "username"

git config --global user.email "address@mail"