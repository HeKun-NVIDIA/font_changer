#!/bin/bash

echo "========================================"
echo "PPT字体替换工具 - 停止服务"
echo "========================================"
echo

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 读取配置文件
load_config() {
    local config_file="$SCRIPT_DIR/config.json"
    if [ -f "$config_file" ]; then
        echo "正在读取配置文件..."
        BACKEND_PORT=$(grep -o '"backend"[[:space:]]*:[[:space:]]*[0-9]*' "$config_file" | grep -o '[0-9]*')
        FRONTEND_PORT=$(grep -o '"frontend"[[:space:]]*:[[:space:]]*[0-9]*' "$config_file" | grep -o '[0-9]*')
    else
        echo "配置文件未找到，使用默认端口"
        BACKEND_PORT=5001
        FRONTEND_PORT=5173
    fi
    
    # 如果解析失败，使用默认值
    [ -z "$BACKEND_PORT" ] && BACKEND_PORT=5001
    [ -z "$FRONTEND_PORT" ] && FRONTEND_PORT=5173
}

# 停止指定端口的进程
stop_port() {
    local port=$1
    local service_name=$2
    
    echo -e "${BLUE}正在停止${service_name}服务 (端口 $port)...${NC}"
    
    # 查找占用端口的进程
    local pids=$(lsof -ti:$port 2>/dev/null)
    
    if [ -n "$pids" ]; then
        echo "发现进程: $pids"
        for pid in $pids; do
            echo "正在终止进程 $pid..."
            kill -TERM $pid 2>/dev/null
            
            # 等待进程优雅退出
            sleep 2
            
            # 检查进程是否还在运行
            if kill -0 $pid 2>/dev/null; then
                echo "强制终止进程 $pid..."
                kill -KILL $pid 2>/dev/null
            fi
            
            # 验证进程是否已停止
            if ! kill -0 $pid 2>/dev/null; then
                echo -e "${GREEN}✅ 进程 $pid 已停止${NC}"
            else
                echo -e "${RED}❌ 无法停止进程 $pid${NC}"
            fi
        done
    else
        echo -e "${YELLOW}⚠️  端口 $port 上没有运行的服务${NC}"
    fi
}

# 停止相关进程
stop_related_processes() {
    echo -e "${BLUE}正在停止相关进程...${NC}"
    
    # 停止包含main.py的Python进程
    local python_pids=$(pgrep -f "python.*main.py" 2>/dev/null)
    if [ -n "$python_pids" ]; then
        echo "停止Python进程: $python_pids"
        for pid in $python_pids; do
            kill -TERM $pid 2>/dev/null
            sleep 1
            if kill -0 $pid 2>/dev/null; then
                kill -KILL $pid 2>/dev/null
            fi
        done
    fi
    
    # 停止包含vite的Node.js进程
    local node_pids=$(pgrep -f "node.*vite" 2>/dev/null)
    if [ -n "$node_pids" ]; then
        echo "停止Node.js进程: $node_pids"
        for pid in $node_pids; do
            kill -TERM $pid 2>/dev/null
            sleep 1
            if kill -0 $pid 2>/dev/null; then
                kill -KILL $pid 2>/dev/null
            fi
        done
    fi
    
    # 停止pnpm进程
    local pnpm_pids=$(pgrep -f "pnpm.*dev" 2>/dev/null)
    if [ -n "$pnpm_pids" ]; then
        echo "停止pnpm进程: $pnpm_pids"
        for pid in $pnpm_pids; do
            kill -TERM $pid 2>/dev/null
            sleep 1
            if kill -0 $pid 2>/dev/null; then
                kill -KILL $pid 2>/dev/null
            fi
        done
    fi
}

# 清理临时文件
cleanup_temp_files() {
    echo -e "${BLUE}正在清理临时文件...${NC}"
    
    # 清理后端临时文件
    local temp_dir="$SCRIPT_DIR/backend/temp"
    if [ -d "$temp_dir" ]; then
        echo "清理后端临时文件..."
        rm -rf "$temp_dir"/*
    fi
    
    # 清理上传文件
    local upload_dir="$SCRIPT_DIR/backend/uploads"
    if [ -d "$upload_dir" ]; then
        echo "清理上传文件..."
        find "$upload_dir" -type f -mtime +1 -delete 2>/dev/null
    fi
}

# 主函数
main() {
    echo -e "${BLUE}🔍 检查运行中的服务...${NC}"
    
    # 加载配置
    load_config
    
    echo "配置的端口:"
    echo "  后端端口: $BACKEND_PORT"
    echo "  前端端口: $FRONTEND_PORT"
    echo
    
    # 停止服务
    stop_port $BACKEND_PORT "后端"
    stop_port $FRONTEND_PORT "前端"
    
    # 停止相关进程
    stop_related_processes
    
    # 清理临时文件
    cleanup_temp_files
    
    echo
    echo "========================================"
    echo -e "${GREEN}🎉 所有服务已停止！${NC}"
    echo "========================================"
    echo
    echo -e "${YELLOW}💡 提示:${NC}"
    echo "  - 如需重新启动，运行: ./start.sh"
    echo "  - 如需修改端口，编辑 config.json 文件"
    echo
}

# 运行主函数
main

