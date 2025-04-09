#!/bin/bash
# telegram-ip-monitor.sh - 静默模式IP监控脚本

# ===== 配置部分 =====
API_TOKEN=""      # 替换为你的Bot Token
CHAT_ID=""          # 替换为接收消息的Chat ID
# export http_proxy="http://127.0.0.1:10809"
# export https_proxy="http://127.0.0.1:10809"
LOG_FILE="/var/log/ip-monitor.log"  # 日志文件路径
IP_HISTORY="/var/lib/ip-monitor/last_ip"  # IP历史记录文件
MAX_RETRY=3                     # IP查询重试次数
SILENT_MODE=true                # 是否启用静默模式（不发送未变更通知）
# ===================

# 创建必要目录
mkdir -p "$(dirname "$IP_HISTORY")" || {
    echo "[$(date)] 错误：无法创建IP存储目录" >> "$LOG_FILE"
    exit 1
}

# 获取公网IP（带重试和验证）
get_public_ip() {
    local ip="" retry=0
    local services=(
        "https://4.ipw.cn"
    )

    while [ -z "$ip" ] && [ $retry -lt $MAX_RETRY ]; do
        for service in "${services[@]}"; do
            ip=$(curl -s --max-time 5 "$service" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}')
            [ -n "$ip" ] && break
        done

        if [ -z "$ip" ]; then
            echo "[$(date)] 警告：第 $((retry+1)) 次IP查询失败" >> "$LOG_FILE"
            sleep $((retry * 5))
            ((retry++))
        fi
    done

    [ -n "$ip" ] && echo "$ip" || {
        echo "[$(date)] 错误：所有IP查询服务不可用" >> "$LOG_FILE"
        exit 1
    }
}

# 发送变更通知
send_notification() {
    local old_ip="$1" new_ip="$2"
    local message="⚠️ *服务器IP通知*
--------------------------------
主机: \`$(echo $HOSTNAME)\`
旧IP: \`$old_ip\`
新IP: \`$new_ip\`
🕒 时间: $(date '+%Y-%m-%d %H:%M:%S %Z')"

    curl -s -X POST \
        "https://api.telegram.org/bot$API_TOKEN/sendMessage" \
        -d "chat_id=$CHAT_ID" \
        -d "text=$message" \
        -d "parse_mode=Markdown" >/dev/null

    echo "[$(date)] 已发送IP变更通知：$old_ip → $new_ip" >> "$LOG_FILE"
}

# 主监控逻辑
current_ip=$(get_public_ip)
last_ip=$(cat "$IP_HISTORY" 2>/dev/null || echo "N/A")

# 首次运行记录IP
if [ "$last_ip" = "N/A" ]; then
    echo "$current_ip" > "$IP_HISTORY"
    send_notification "$last_ip" "$current_ip"
    echo "[$(date)] 初始化记录IP: $current_ip" >> "$LOG_FILE"
    exit 0
fi

# IP变更检测
if [ "$current_ip" != "$last_ip" ]; then
    send_notification "$last_ip" "$current_ip"
    echo "$current_ip" > "$IP_HISTORY"
else
    [ "$SILENT_MODE" = false ] && \
        echo "[$(date)] 检测：IP未变化 ($current_ip)" >> "$LOG_FILE" && \
        send_notification "$last_ip" "$current_ip"
fi
