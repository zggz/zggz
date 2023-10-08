---
title: "Docker"
weight: 1
date: 2022-05-11T14:28:16+08:00
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---


## 安装
### 腾讯云镜像安装（debian）
```sh
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://mirrors.cloud.tencent.com/docker-ce/linux/debian/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://mirrors.cloud.tencent.com/docker-ce/linux/debian $(lsb_release -cs) stable"

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

```

### 镜像安装加速

1. 打开 /etc/docker/daemon.json 配置文件。
```sh
vim /etc/docker/daemon.json
```
2. 添加
```sh
{
   "registry-mirrors": [
       "https://mirror.ccs.tencentyun.com"
  ]
}
```
3. 重启docker
```sh
sudo systemctl restart docker
```
