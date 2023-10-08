---
title: http
date: 2020-11-19 00:18:12
tags: 网络
menu: main
---

## Introduction
http 相关的基本概念
<!--more--> 
## 网络基本模型

1. 从上至下依次(5层基本模型)
- 应用层（为用户的应用进程提供网络通信服务）
    - http、ftp、smtp、dns
- 传输层
    - tcp、udp
- 网络层
    - IP
- 链路层
- 物理层

## TCP 三次握手、四次挥手 
###  概念
传输控制协议，是一种可靠的传输层协议，具有确认窗口，重传，拥塞机制；IP协议号为6。TCP连接时全双工 [参考链接](https://blog.csdn.net/qq_39331713/article/details/81705890?utm_medium=distribute.pc_relevant.none-task-blog-baidulandingword-2&spm=1001.2101.3001.4242)

### 常用场景：
   - TCP：HTTP、ftp、smtp
   - UDP：语言、视频
### 三次握手的意义
  - 为了防止已失效的连接请求报文段突然又传送到了服务端，因而产生错误。为了防止已失效的连接请求报文段突然又传送到了服务端，因而产生错误。
### 过程
  - 第一次握手：Client将标志位SYN置为1，随机产生一个值seq=J，并将该数据包发送给Server，Client进入SYN_SENT状态，等待Server确认。
  - 第二次握手：Server收到数据包后由标志位SYN=1知道Client请求建立连接，Server将标志位SYN和ACK都置为1，ack (number )=J+1，随机产生一个值seq=K，并将该数据包发送给Client以确认连接请求，Server进入SYN_RCVD状态。
  - 第三次握手：Client收到确认后，检查ack是否为J+1，ACK是否为1，如果正确则将标志位ACK置为1，ack=K+1，并将该数据包发送给Server，Server检查ack是否为K+1，ACK是否为1，如果正确则连接建立成功，Client和Server进入ESTABLISHED状态，完成三次握手，随后Client与Server之间可以开始传输数据了
### 四次挥手
- 原理：TCP协议是一种面向连接的、可靠的、基于字节流的运输层通信协议。TCP是全双工模式，这就意味着，当主机1发出`FIN`报文段时，只是表示主机1已经没有数据要发送了，主机1告诉主机2，它的数据已经全部发送完毕了；但是，这个时候主机1还是可以接受来自主机2的数据；当主机2返回`ACK`报文段时，表示它已经知道主机1没有数据发送了，但是主机2还是可以发送数据到主机1的；当主机2也发送了`FIN`报文段时，这个时候就表示主机2也没有数据要发送了，就会告诉主机1，我也没有数据要发送了，之后彼此就会愉快的中断这次TCP连接
- 第一次挥手：Client发送一个FIN，用来关闭Client到Server的数据传送，Client进入FIN_WAIT_1状态。
- 第二次挥手：Server收到FIN后，发送一个ACK给Client，确认序号为收到序号+1（与SYN相同，一个FIN占用一个序号），Server进入CLOSE_WAIT状态。
- 第三次挥手：Server发送一个FIN，用来关闭Server到Client的数据传送，Server进入LAST_ACK状态。
- 第四次挥手：Client收到FIN后，Client进入TIME_WAIT状态，接着发送一个ACK给Server，确认序号为收到序号+1，Server进入CLOSED状态，完成四次挥手。

## Http
### 概念
- HTTP协议是Hyper Text Transfer Protocol（超文本传输协议）的缩写,是用于从万维网（WWW:World Wide Web ）服务器传输超文本到本地浏览器的传送协议。
- HTTP是一个基于TCP/IP通信协议来传递数据（HTML 文件, 图片文件, 查询结果等）。
### 主要特点
- 简单快速
- 灵活
- 无连接（每次连接只处理一个请求）
- 无状态（对事物没有记忆功能）
### 常见状态码
- 100 指示信息--表示请求已接收，继续处理
- 2xx 成功- 表示请求已经接受、理解
- 3xx 重定向- 要完成请求必须要进行进一步操作
- 4xx 客服端错误- 请求语法错误或请求无法实现
- 5xx 服务端错误- 服务端未能实现合法请求
  ```js
  200 OK                        //客户端请求成功
  301                           // 永久移动）  请求的网页已永久移动到新位置。 服务器返回此响应（对 GET 或 HEAD 请求的响应）时，会自动将请求者转到新位置。
  304                           // （未修改） 自从上次请求后，请求的网页未修改过。 服务器返回此响应时，不会返回网页内容。（未修改） 自从上次请求后，请求的网页未修改过。 服务器返回此响应时，不会返回网页内容。
  400 Bad Request               //客户端请求有语法错误，不能被服务器所理解
  401 Unauthorized              //请求未经授权，这个状态代码必须和WWW-Authenticate报头域一起使用 
  403 Forbidden                 //服务器收到请求，但是拒绝提供服务
  404 Not Found                 //请求资源不存在，eg：输入了错误的URL
  500 Internal Server Error     //服务器发生不可预期的错误
  503 Server Unavailable        //服务器当前不能处理客户端的请求，一段时间后可能恢复正常
  ```

## Https
### 概念
HTTPS是在HTTP上建立SSL加密层，并对传输数据进行加密
### 为什么需要HTTPS
- http使用明文传输；（导致数据泄露、数据篡改、流量劫持、钓鱼攻击）
- 无法证明报文的完整性，所以可能遭篡改
- HTTP协议中的请求和响应不会对通信方进行确认（钓鱼欺诈）
### https优势
- 数据隐私性： 内容加密，每个连接生成唯一的加密秘钥
    - 实现：加密（对称加密、非对称加密）
- 数据完整性： 内容经过完整性校验
    - 实现：数字签名（证书颁发机构（Certificate Authority，简称CA）
- 身份认证： 第三方无法伪造服务端（客服端）身份
    - 实现：数字证书（数字证书认证机构处于客户端与服务器双方都可信赖的第三方机构的立场上。）
### 区别
- 传输信息安全性不同
    - http协议：是超文本传输协议，信息是明文传输
    - https具有安全的ssl加密传输协议，为浏览器和服务器通信加密
- 连接方式不同
    - http无状态连接（事务处理无记忆功能）
    - https： 由ssl+http协议构建的可进行加密传输，身份认证的网络协议
- 端口不同
    - http协议：使用的端口是80。
    - http协议：使用的端口是80。
- 证书不同
    - http，免费
    - https 需要cs申请证书，一般需要购买
### 安全的原因 
[参考链接](https://blog.csdn.net/howgod/article/details/89596638)
- HTTPS 协议的主要功能基本都依赖于 TLS/SSL 协议，TLS/SSL 的功能实现主要依赖于三类基本算法：散列函数 、对称加密和非对称加密，其利用非对称加密实现身份认证和密钥协商，对称加密算法采用协商的密钥对数据加密，基于散列函数验证信息的完整性。
- https主要作用
- 对数据进行，并建立一个信息安全通道，保证传输过程中的数据安全
- 对网站服务器进行真实身份认证

### 注意
  - HTTPS并非是应用层的一种新协议。只是HTTP通信接口部分用SSL和TLS协议代替而已。HTTP直接和TCP通信。当使用SSL时，则演变成先和SSL通信，再由SSL和TCP通信了。所谓HTTPS，其实就是身披SSL协议这层外壳的HTTP。