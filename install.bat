@echo off
chcp 65001 >nul
echo ========================================
echo PPT字体替换工具 - 一键安装脚本
echo ========================================
echo.

:: 检查Python
echo [1/4] 检查Python环境...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 未检测到Python，请先安装Python 3.11+
    echo 下载地址: https://www.python.org/downloads/
    pause
    exit /b 1
)

for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo ✅ Python版本: %PYTHON_VERSION%

:: 检查Node.js
echo [2/4] 检查Node.js环境...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 未检测到Node.js，请先安装Node.js 20+
    echo 下载地址: https://nodejs.org/
    pause
    exit /b 1
)

for /f %%i in ('node --version') do set NODE_VERSION=%%i
echo ✅ Node.js版本: %NODE_VERSION%

:: 安装pnpm
echo [3/4] 安装/检查pnpm...
pnpm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 正在安装pnpm...
    npm install -g pnpm
    if %errorlevel% neq 0 (
        echo ❌ pnpm安装失败
        pause
        exit /b 1
    )
)

for /f %%i in ('pnpm --version') do set PNPM_VERSION=%%i
echo ✅ pnpm版本: %PNPM_VERSION%

:: 安装项目依赖
echo [4/4] 安装项目依赖...

echo 正在创建Python虚拟环境...
cd /d "%~dp0backend"
if not exist venv (
    python -m venv venv
)

echo 正在安装Python依赖...
call venv\Scripts\activate
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo ❌ Python依赖安装失败
    pause
    exit /b 1
)

echo 正在安装前端依赖...
cd /d "%~dp0frontend"
pnpm install
if %errorlevel% neq 0 (
    echo ❌ 前端依赖安装失败
    pause
    exit /b 1
)

cd /d "%~dp0"

echo.
echo ========================================
echo 🎉 安装完成！
echo ========================================
echo.
echo 现在您可以运行以下命令启动应用：
echo   start.bat
echo.
echo 或者双击 start.bat 文件
echo.
pause

