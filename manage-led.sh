#!/bin/bash

# 设置语言与输出颜色
export LANG=en_US.UTF-8
ECHO="echo -e"

print_color() {
    local color=$1
    local msg=$2
    case "$color" in
        red)      $ECHO "\033[31m${msg}\033[0m" ;;
        green)    $ECHO "\033[32m${msg}\033[0m" ;;
        yellow)   $ECHO "\033[33m${msg}\033[0m" ;;
        skyBlue)  $ECHO "\033[1;36m${msg}\033[0m" ;;
        *)        $ECHO "$msg" ;;
    esac
}

# 检查 sudo 权限
if ! sudo -v &>/dev/null; then
    print_color red "当前用户没有 sudo 权限，请使用 root 用户或具有 sudo 权限的用户运行此脚本。"
    exit 1
fi

# 定义变量
SERVICE_DIR="/lib/systemd/system"
SERVICES=("disable-leds.service" "enable-leds.service")

# 安装服务
install_services() {
    print_color skyBlue ">>> 开始安装服务..."

    print_color yellow "-> 删除旧服务文件"
    for svc in "${SERVICES[@]}"; do
        sudo rm -f "$SERVICE_DIR/$svc"
    done

    print_color yellow "-> 复制新服务文件"
    for svc in "${SERVICES[@]}"; do
        sudo cp "./$svc" "$SERVICE_DIR/"
    done

    print_color yellow "-> 重新加载 systemd"
    sudo systemctl daemon-reload

    print_color green ">>> 服务安装完成！"
}

# 卸载服务
uninstall_services() {
    print_color skyBlue ">>> 执行卸载逻辑：启动 enable-leds.service"

    $SYSTEMCTL_CMD start enable-leds.service

    if [[ $? -eq 0 ]]; then
        print_color green ">>> enable-leds.service 已启动"
    else
        print_color red ">>> 启动失败，请手动检查服务状态"
    fi
}

# 执行入口
case "$1" in
    install)
        install_services
        ;;
    uninstall)
        uninstall_services
        ;;
    *)
        print_color red "用法: $0 [install|uninstall]"
        exit 1
        ;;
esac

