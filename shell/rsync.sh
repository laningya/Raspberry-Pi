#!/bin/bash

# ==================== 配置区域 ====================
REMOTE_USER="root"                       # 生产服务器用户名
REMOTE_HOST="你的生产机IP"                 # 生产服务器 IP
REMOTE_PORT="22"                         # 生产服务器 SSH 端口
REMOTE_BACKUP_ROOT="/root/docker_backups" # 生产机上备份文件存放的总目录
LOCAL_BACKUP_ROOT="/home/backup/docker"  # 备份机本地存放的总目录

LOG_FILE="/var/log/docker_rsync_pull.log"
KEEP_DAYS_LOCAL=30                       # 备份机本地保留 30 天的数据
# ==================================================

# 确保日志文件和本地目录存在
[ ! -f "$LOG_FILE" ] && touch "$LOG_FILE"
mkdir -p "$LOCAL_BACKUP_ROOT"

# 定义一个同时输出到屏幕和日志的函数
log_message() {
    echo "$1" | tee -a "$LOG_FILE"
}

log_message "=================================================="
log_message "===== 开始异地同步任务：$(date '+%Y-%m-%d %H:%M:%S') ====="
log_message "=================================================="
log_message "📡 正在连接生产服务器 ${REMOTE_HOST}..."

# 执行 rsync 同步
# 这里让 rsync 自身的详细输出去日志，但关键状态通过 echo 提示给用户
log_message "📦 开始拉取备份文件并保持目录结构..."

rsync -avz -e "ssh -p $REMOTE_PORT" \
    "$REMOTE_USER@$REMOTE_HOST:$REMOTE_BACKUP_ROOT/" \
    "$LOCAL_BACKUP_ROOT" >> "$LOG_FILE" 2>&1

# 检查同步结果
if [ $? -eq 0 ]; then
    log_message "✅ [成功] 所有服务数据已安全同步到本地目录: $LOCAL_BACKUP_ROOT"
    
    log_message "🧹 开始检查并清理本地 $KEEP_DAYS_LOCAL 天前的过期旧文件..."
    # 清理旧文件的过程输出到日志
    find "$LOCAL_BACKUP_ROOT" -type f -mtime +$KEEP_DAYS_LOCAL -name "*.tar.gz" -exec rm -v {} \; >> "$LOG_FILE" 2>&1
    log_message "✅ [成功] 过期文件清理完毕。"
else
    log_message "❌ [失败] 同步过程中出现错误！请查看日志获取详细报错: $LOG_FILE"
fi

log_message "=================================================="
log_message "===== 同步任务结束：$(date '+%Y-%m-%d %H:%M:%S') ====="
log_message "=================================================="