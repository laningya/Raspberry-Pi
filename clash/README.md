<<<<<<< HEAD
# clash-linux docker部署及自动更新脚本
---
=======
# clash-docker部署

## 特性

- python更新订阅链接，配合crontab实现自动更新

- 搭配dashboard提供ui切换节点

## 部署步骤

### 1.订阅链接转换

可以自己部署服务或者使用他人部署好的服务

- 开源工具地址： [sub-web](https://github.com/CareyWang/sub-web)

- 他人部署的服务[地址:](https://sub.v1.mk/)

### 2.修改python文件的配置

- url字段：替换为1中获取到的地址

- filePath：替换为自己的文件路径

### 3.执行脚本首次获取订阅信息

```bash
python3 getClashConfig.py
```

如果第2步的配置没错，应该会看到如下的输出

### 4.启动docker服务

```bash
docker-compose up -d
```

### 5.配置定时更新订阅

```bash
crontab -e
#以下内容需要改成自己的路径
0 7 * * * /usr/bin/python  /home/pi/clash/getClashConfig.py > /dev/null 2>&1  &
```

### 6.通过web-ui选择节点

浏览器输入配置服务的机器的IP:7890

### 7.浏览器配合插件使用代理

**插件名：**Proxy SwitchyOmega

>>>>>>> develop
