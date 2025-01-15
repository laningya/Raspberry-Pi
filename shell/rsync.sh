#!/bin/bash

# 定义变量
SERVICE_NAME=""
REMOTE_USER=""                         # 远程服务器用户名
REMOTE_HOST=""            # 远程服务器 IP 或主机名
REMOTE_PORT=""                         # 远程服务器 SSH 端口
REMOTE_DIR=""     # 远程目录路径
LOCAL_DIR=""       # 本地目录路径
LOG_FILE="/var/log/$SERVICE_NAME-rsync_pull.log"         # 日志文件路径

# 检查日志文件是否存在，不存在则创建
if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
fi

# 输出时间戳到日志文件
echo "===== 开始同步：$(date '+%Y-%m-%d %H:%M:%S') =====" >> "$LOG_FILE"

# 执行 rsync 同步：从远程到本地
rsync -avz --delete -e "ssh -p $REMOTE_PORT" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/" "$LOCAL_DIR" >> "$LOG_FILE" 2>&1

# 检查同步结果
if [ $? -eq 0 ]; then
    echo "同步成功。" >> "$LOG_FILE"
    echo "===== 同步完成：$(date '+%Y-%m-%d %H:%M:%S') =====" >> "$LOG_FILE"
else
    echo "同步失败！请检查日志文件以了解详细信息。" >> "$LOG_FILE"
    echo "===== 同步失败：$(date '+%Y-%m-%d %H:%M:%S') =====" >> "$LOG_FILE"
fi
