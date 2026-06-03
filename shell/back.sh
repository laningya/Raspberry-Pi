#!/bin/bash

# ==================== 配置区域 ====================
# 1. 所有 Docker 服务文件夹所在的父目录（末尾不要加 /）
DOCKER_ROOT="/root/docker"

# 2. 你想要依次备份的服务文件夹名称（必须是 DOCKER_ROOT 下存在的子文件夹名）
SERVICES=("vaultwarden" "nginx" "nextcloud" "mysql")

# 3. 备份文件统一存放的总目录（末尾不要加 /）
# 脚本会自动在里面为每个服务创建独立子文件夹，如 /root/docker_backups/vaultwarden/
BACKUP_ROOT="/root/docker_backups"

# 4. 备份保留天数
KEEP_DAYS=7
# ==================================================

DATE=$(date +'%Y-%m-%d')

echo "=================================================="
echo "$(date '+%Y-%m-%d %H:%M:%S') - [全部备份任务开始]"
echo "=================================================="

# 开始循环遍历服务列表
for SERVICE_NAME in "${SERVICES[@]}"; do
    
    # 自动推导当前服务的相关路径
    COMPOSE_DIR="$DOCKER_ROOT/$SERVICE_NAME"
    CURRENT_SERVICE_BACKUP_DIR="$BACKUP_ROOT/$SERVICE_NAME" # 每个服务独立的备份文件夹
    BACKUP_FILE="$CURRENT_SERVICE_BACKUP_DIR/$SERVICE_NAME-backup-$DATE.tar.gz"
    LOG_FILE="/var/log/$SERVICE_NAME-backup.log"
    
    # 确保单个服务的日志文件存在
    touch "$LOG_FILE"
    
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 🔍 正在处理服务: $SERVICE_NAME ..."
    echo "$(date '+%Y-%m-%d %H:%M:%S') - [开始备份] 服务: $SERVICE_NAME" >> "$LOG_FILE"

    # 检查该服务的源文件夹是否存在
    if [ ! -d "$COMPOSE_DIR" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - [错误] 目录 $COMPOSE_DIR 不存在，跳过此服务。" | tee -a "$LOG_FILE"
        echo "--------------------------------------------------"
        continue
    fi

    # 自动创建该服务专用的备份子文件夹（如果不存在的话）
    mkdir -p "$CURRENT_SERVICE_BACKUP_DIR"

    # 1. 切换到项目目录并停止该容器
    cd "$COMPOSE_DIR" || continue
    docker-compose stop >> "$LOG_FILE" 2>&1
    if [ $? -ne 0 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - [错误] 容器停止失败" | tee -a "$LOG_FILE"
        echo "--------------------------------------------------"
        continue
    fi

    # 2. 打包整个服务文件夹
    tar -czvf "$BACKUP_FILE" -C "$DOCKER_ROOT" "$SERVICE_NAME" >> "$LOG_FILE" 2>&1
    if [ $? -ne 0 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - [错误] 数据打包失败" | tee -a "$LOG_FILE"
        # 哪怕打包失败，也务必把容器拉起来，保证服务在线
        docker-compose start >> "$LOG_FILE" 2>&1
        echo "--------------------------------------------------"
        continue
    fi

    # 3. 重新启动该容器
    docker-compose start >> "$LOG_FILE" 2>&1
    if [ $? -ne 0 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - [错误] 容器启动失败" | tee -a "$LOG_FILE"
        echo "--------------------------------------------------"
        continue
    fi

    # 4. 本地清理当前服务专用的子文件夹里过期的旧备份
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 开始检查并清理 $SERVICE_NAME 历史旧备份..." >> "$LOG_FILE"
    find "$CURRENT_SERVICE_BACKUP_DIR" -type f -mtime +$KEEP_DAYS -name "$SERVICE_NAME-backup-*.tar.gz" -exec rm -v {} \; >> "$LOG_FILE" 2>&1

    echo "$(date '+%Y-%m-%d %H:%M:%S') - [备份成功] 已生成: $BACKUP_FILE" | tee -a "$LOG_FILE"
    echo "--------------------------------------------------"

done

echo "=================================================="
echo "$(date '+%Y-%m-%d %H:%M:%S') - [全部备份任务结束]"
echo "=================================================="