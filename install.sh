#!/bin/bash

# 检查当前用户是否有sudo权限
if ! sudo -v &>/dev/null; then
  echo "当前用户没有sudo权限，或者没有配置sudo，请使用root用户或具有sudo权限的用户运行此脚本。"
  exit 1
fi

# 定义需要的命令（带sudo）
RM_CMD="sudo rm -rf"
CP_CMD="sudo cp"
SYSTEMCTL_CMD="sudo systemctl"

# 1. 删除旧的服务文件
echo "Removing old service files..."
$RM_CMD /lib/systemd/system/disable-leds.service /lib/systemd/system/enable-leds.service

# 2. 复制新的服务文件
echo "Copying new service files..."
$CP_CMD ./*.service /lib/systemd/system/

# 3. 重新加载 systemd 配置
echo "Reloading systemd daemon..."
$SYSTEMCTL_CMD daemon-reload

echo "Installation completed successfully!"

