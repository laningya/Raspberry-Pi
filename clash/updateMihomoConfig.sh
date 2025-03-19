#!/bin/bash

# 定义路径
CONFIG_DIR=~
CONFIG_FILE=config.yml
BACKUP_FILE="bak"
DOWNLOAD_URL="https://raw.githubusercontent.com/laningya/Raspberry-Pi/refs/heads/master/clash/config.yml"
YOUR_URL=""

# 备份旧配置（显示操作）
echo "正在备份当前配置..."
[ -f "$CONFIG_DIR/$CONFIG_FILE" ] && mv -v "$CONFIG_DIR/$CONFIG_FILE" "$CONFIG_DIR/$BACKUP_FILE"

# 下载新配置（显示完整输出）
echo -e "\n正在下载配置文件..."
if command -v wget >/dev/null; then
    wget --show-progress -O "$CONFIG_DIR/$CONFIG_FILE" "$DOWNLOAD_URL"
elif command -v curl >/dev/null; then
    curl -# -o "$CONFIG_DIR/$CONFIG_FILE" "$DOWNLOAD_URL"
else
    echo "错误：需要 wget 或 curl" >&2
    exit 1
fi

# 严格检查下载状态
if [ $? -ne 0 ]; then
    echo -e "\n\033[31m错误：配置文件下载失败\033[0m" >&2
    exit 1
fi

# 注入订阅URL（显示操作）
echo -e "\n正在注入订阅链接..."
ESCAPED_URL=$(sed 's/[\/&]/\\&/g' <<< "$YOUR_URL")
sed -i.bak "/proxy-providers:/,/health-check:/ {
    /url: \"\"/s//url: \"${ESCAPED_URL}\"/
}" "$CONFIG_DIR/$CONFIG_FILE" && rm -f "$CONFIG_DIR/$CONFIG_FILE.bak"

# 验证结果
if grep -q "url: \"$YOUR_URL\"" "$CONFIG_DIR/$CONFIG_FILE"; then
    echo -e "\n\033[32m状态：配置更新成功\033[0m"
    echo "文件路径：$CONFIG_DIR/$CONFIG_FILE"
else
    echo -e "\n\033[31m错误：订阅链接注入失败\033[0m" >&2
    exit 1
fi
