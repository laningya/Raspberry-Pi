#!/bin/bash

# 定义变量
SERVICE_NAME=""
DATE=$(date +'%Y-%m-%d')
DATA_DIR=""       # 数据文件夹
BACKUP_DIR=""                     # 备份存储路径
COMPOSE_DIR=""    # docker-compose.yml 文件所在目录
BACKUP_FILE="$BACKUP_DIR/$SERVICE_NAME-backup-$DATE.tar.gz"
LOG_FILE="/var/log/$SERVICE_NAME-backup.log"             # 日志文件路径

# 确保日志文件存在
touch $LOG_FILE

# 创建备份目录（如果不存在）
mkdir -p $BACKUP_DIR

echo "$(date '+%Y-%m-%d %H:%M:%S') - 开始备份" >> $LOG_FILE

# 停止容器
cd $COMPOSE_DIR
docker-compose down
if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 容器停止失败" >> $LOG_FILE
    exit 1
fi

# 备份数据文件夹
tar -czvf $BACKUP_FILE -C $(dirname $DATA_DIR) $(basename $DATA_DIR)
if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 数据备份失败" >> $LOG_FILE
    exit 1
fi

# 重启容器
docker-compose up -d
if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 容器启动失败" >> $LOG_FILE
    exit 1
fi

# 删除7天前的旧备份
find $BACKUP_DIR -type f -mtime +7 -name "*.tar.gz" -exec rm -v {} \; >> $LOG_FILE

# 输出日志
echo "$(date '+%Y-%m-%d %H:%M:%S') - 备份完成：$BACKUP_FILE" >> $LOG_FILE
