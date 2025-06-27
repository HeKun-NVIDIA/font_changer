#!/bin/bash

echo "========================================"
echo "PPT字体替换工具 - 启动中..."
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
        AUTO_OPEN_BROWSER=$(grep -o '"auto_open_browser"[[:space:]]*:[[:space:]]*[a-z]*' "$config_file" | grep -o '[a-z]*$')
        
        echo -e "${GREEN}✅ 配置已加载${NC}"
        echo "  后端端口: $BACKEND_PORT"
        echo "  前端端口: $FRONTEND_PORT"
        echo "  自动打开浏览器: $AUTO_OPEN_BROWSER"
    else
        echo -e "${YELLOW}⚠️  配置文件未找到，使用默认配置${NC}"
        BACKEND_PORT=5001
        FRONTEND_PORT=5173
        AUTO_OPEN_BROWSER=true
        echo "  后端端口: $BACKEND_PORT"
        echo "  前端端口: $FRONTEND_PORT"
        echo "  自动打开浏览器: $AUTO_OPEN_BROWSER"
    fi
    
    # 如果解析失败，使用默认值
    [ -z "$BACKEND_PORT" ] && BACKEND_PORT=5001
    [ -z "$FRONTEND_PORT" ] && FRONTEND_PORT=5173
    [ -z "$AUTO_OPEN_BROWSER" ] && AUTO_OPEN_BROWSER=true
}

# 检查是否已安装
if [ ! -d "$SCRIPT_DIR/backend/venv" ]; then
    echo -e "${RED}❌ 检测到未安装，请先运行安装脚本${NC}"
    echo
    echo "正在自动运行安装程序..."
    bash "$SCRIPT_DIR/install.sh"
    if [ $? -ne 0 ]; then
        echo -e "${RED}安装失败，请手动运行: ./install.sh${NC}"
        exit 1
    fi
fi

if [ ! -d "$SCRIPT_DIR/frontend/node_modules" ]; then
    echo -e "${RED}❌ 检测到前端依赖未安装，请先运行: ./install.sh${NC}"
    exit 1
fi

echo -e "${GREEN}✅ 环境检查通过${NC}"
echo

# 加载配置
load_config
echo

# 清理函数
cleanup() {
    echo
    echo "正在停止服务..."
    if [ ! -z "$BACKEND_PID" ]; then
        kill $BACKEND_PID 2>/dev/null
        echo "后端服务已停止"
    fi
    echo "所有服务已停止"
    exit 0
}

# 设置信号处理
trap cleanup SIGINT SIGTERM

# 启动后端服务
echo -e "${BLUE}🚀 启动后端服务...${NC}"
cd "$SCRIPT_DIR/backend"
source venv/bin/activate

# 后台启动后端
python src/main.py &
BACKEND_PID=$!

echo -e "${GREEN}✅ 后端服务已启动 (PID: $BACKEND_PID)${NC}"

# 等待后端启动
echo -e "${YELLOW}⏳ 等待后端服务完全启动...${NC}"
sleep 5

# 检查后端是否正常运行
if ! kill -0 $BACKEND_PID 2>/dev/null; then
    echo -e "${RED}❌ 后端服务启动失败${NC}"
    exit 1
fi

# 测试后端连接
echo "🔍 测试后端连接..."
for i in {1..10}; do
    if curl -s http://localhost:$BACKEND_PORT >/dev/null 2>&1; then
        echo -e "${GREEN}✅ 后端服务连接成功${NC}"
        break
    fi
    if [ $i -eq 10 ]; then
        echo -e "${RED}❌ 后端服务连接失败${NC}"
        cleanup
        exit 1
    fi
    sleep 1
done

# 启动前端服务
echo -e "${BLUE}🚀 启动前端服务...${NC}"
cd "$SCRIPT_DIR/frontend"

echo
echo "========================================"
echo -e "${GREEN}🎉 启动完成！${NC}"
echo "========================================"
echo
echo -e "${BLUE}📱 应用地址: http://localhost:$FRONTEND_PORT${NC}"
echo
echo -e "${YELLOW}💡 使用说明:${NC}"
echo "  - 应用将在浏览器中自动打开"
echo "  - 按 Ctrl+C 停止所有服务"
echo "  - 如需停止服务，运行: ./stop.sh"
echo "  - 如需重启，重新运行此脚本"
echo
echo -e "${YELLOW}📚 详细教程: 安装和使用教程.md${NC}"
echo -e "${YELLOW}🔧 修改端口: 编辑 config.json 文件${NC}"
echo

# 自动打开浏览器
if [ "$AUTO_OPEN_BROWSER" = "true" ]; then
    if command -v open >/dev/null 2>&1; then
        # macOS
        open http://localhost:$FRONTEND_PORT
    elif command -v xdg-open >/dev/null 2>&1; then
        # Linux
        xdg-open http://localhost:$FRONTEND_PORT
    fi
fi

# 启动前端服务（前台运行）
echo -e "${BLUE}前端服务启动中...${NC}"
pnpm run dev --host

# 如果前端服务停止，清理后端
cleanup

