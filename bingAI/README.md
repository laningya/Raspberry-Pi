# bingAI本地部署

## 前言

自从chatGPT3.0问世以后，新一轮的人工智能浪潮深刻改变了我们的生活。相比于深蓝击败人类象棋冠军以及阿尔法狗击败人类围棋冠军，chatGPT更能称为划时代的人工智能产品，因为它太接近我们的生活了（通用人工智能）。关于它能干什么以及它与newbing的关系这里不多介绍，感兴趣的可以自己寻找这方面的科普视频。本文主要分享如何通过docker部署newbing，从而达到无需魔法访问newbing的目的。

![](assets/newbing.png)

**开源项目地址**

[go-proxy-bingai](https://github.com/adams549659584/go-proxy-bingai)

## 特性

- 使用caddy来进行反向代理，自动配置域名证书

## 实践过程

- 拉取[本目录](https://github.com/laningya/Raspberry-Pi/tree/develop/bingAI)下的文件
- 替换caddy文件下的Caddyfile文件中的yourdomain.com字段为自己的域名
- 命令行执行docker-compose up -d畅享服务吧。
