#!/bin/bash

echo "========================================"
echo "PPT字体替换工具 - 一键安装脚本"
echo "========================================"
echo

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查命令是否存在
check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# 检查Python
echo "[1/4] 检查Python环境..."
if check_command python3; then
    PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2)
    echo -e "${GREEN}✅ Python版本: $PYTHON_VERSION${NC}"
    
    # 检查Python版本是否 >= 3.11
    PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d'.' -f1)
    PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d'.' -f2)
    
    if [ "$PYTHON_MAJOR" -lt 3 ] || ([ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -lt 11 ]); then
        echo -e "${RED}❌ Python版本过低，需要3.11+${NC}"
        echo "请访问 https://www.python.org/downloads/ 下载最新版本"
        exit 1
    fi
else
    echo -e "${RED}❌ 未检测到Python3${NC}"
    echo "请先安装Python 3.11+"
    
    # 提供安装建议
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macOS安装命令: brew install python@3.11"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "Ubuntu安装命令: sudo apt update && sudo apt install python3.11 python3.11-venv python3-pip"
    fi
    exit 1
fi

# 检查Node.js
echo "[2/4] 检查Node.js环境..."
if check_command node; then
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}✅ Node.js版本: $NODE_VERSION${NC}"
    
    # 检查Node.js版本是否 >= 20
    NODE_MAJOR=$(echo $NODE_VERSION | sed 's/v//' | cut -d'.' -f1)
    if [ "$NODE_MAJOR" -lt 20 ]; then
        echo -e "${YELLOW}⚠️  Node.js版本较低，推荐20+${NC}"
    fi
else
    echo -e "${RED}❌ 未检测到Node.js${NC}"
    echo "请先安装Node.js 20+"
    echo "下载地址: https://nodejs.org/"
    
    # 提供安装建议
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macOS安装命令: brew install node"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "Ubuntu安装命令: curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt-get install -y nodejs"
    fi
    exit 1
fi

# 安装/检查pnpm
echo "[3/4] 安装/检查pnpm..."
if check_command pnpm; then
    PNPM_VERSION=$(pnpm --version)
    echo -e "${GREEN}✅ pnpm版本: $PNPM_VERSION${NC}"
else
    echo "正在安装pnpm..."
    npm install -g pnpm
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ pnpm安装失败${NC}"
        exit 1
    fi
    PNPM_VERSION=$(pnpm --version)
    echo -e "${GREEN}✅ pnpm安装成功，版本: $PNPM_VERSION${NC}"
fi

# 安装项目依赖
echo "[4/4] 安装项目依赖..."

# 安装后端依赖
echo "正在创建Python虚拟环境..."
cd "$SCRIPT_DIR/backend"

if [ ! -d "venv" ]; then
    python3 -m venv venv
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ 虚拟环境创建失败${NC}"
        exit 1
    fi
fi

echo "正在安装Python依赖..."
source venv/bin/activate
pip install -r requirements.txt
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Python依赖安装失败${NC}"
    exit 1
fi

# 安装前端依赖
echo "正在安装前端依赖..."
cd "$SCRIPT_DIR/frontend"
pnpm install
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 前端依赖安装失败${NC}"
    exit 1
fi

cd "$SCRIPT_DIR"

echo
echo "========================================"
echo -e "${GREEN}🎉 安装完成！${NC}"
echo "========================================"
echo
echo "现在您可以运行以下命令启动应用："
echo -e "${YELLOW}  ./start.sh${NC}"
echo
echo "或者运行:"
echo -e "${YELLOW}  bash start.sh${NC}"
echo

