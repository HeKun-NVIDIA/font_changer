@echo off
chcp 65001 >nul
echo ========================================
echo PPT字体替换工具 - 启动中...
echo ========================================
echo.

:: 读取配置文件获取端口
set "CONFIG_FILE=%~dp0config.json"
set "BACKEND_PORT=5001"
set "FRONTEND_PORT=5173"

if exist "%CONFIG_FILE%" (
    echo 正在读取配置文件...
    for /f "tokens=2 delims=:" %%a in ('findstr "backend" "%CONFIG_FILE%"') do (
        for /f "tokens=1 delims=," %%b in ("%%a") do (
            set "BACKEND_PORT=%%b"
            set "BACKEND_PORT=!BACKEND_PORT: =!"
        )
    )
    for /f "tokens=2 delims=:" %%a in ('findstr "frontend" "%CONFIG_FILE%"') do (
        for /f "tokens=1 delims=," %%b in ("%%a") do (
            set "FRONTEND_PORT=%%b"
            set "FRONTEND_PORT=!FRONTEND_PORT: =!"
        )
    )
    echo ✅ 配置已加载
    echo   后端端口: %BACKEND_PORT%
    echo   前端端口: %FRONTEND_PORT%
) else (
    echo ⚠️  配置文件未找到，使用默认端口
    echo   后端端口: %BACKEND_PORT%
    echo   前端端口: %FRONTEND_PORT%
)
echo.

:: 检查是否已安装
if not exist "backend\venv" (
    echo ❌ 检测到未安装，请先运行 install.bat
    echo.
    echo 正在自动运行安装程序...
    call install.bat
    if %errorlevel% neq 0 (
        echo 安装失败，请手动运行 install.bat
        pause
        exit /b 1
    )
)

if not exist "frontend\node_modules" (
    echo ❌ 检测到前端依赖未安装，请先运行 install.bat
    pause
    exit /b 1
)

echo ✅ 环境检查通过
echo.

:: 启动后端服务
echo 🚀 启动后端服务...
cd /d "%~dp0backend"
start "PPT字体替换工具-后端服务" cmd /k "venv\Scripts\activate && echo 后端服务启动中... && python src\main.py"

:: 等待后端启动
echo ⏳ 等待后端服务启动...
timeout /t 5 /nobreak >nul

:: 启动前端服务
echo 🚀 启动前端服务...
cd /d "%~dp0frontend"
start "PPT字体替换工具-前端服务" cmd /k "echo 前端服务启动中... && pnpm run dev --host"

:: 等待前端启动
echo ⏳ 等待前端服务启动...
timeout /t 3 /nobreak >nul

:: 自动打开浏览器
echo 🌐 正在打开浏览器...
start http://localhost:%FRONTEND_PORT%

cd /d "%~dp0"

echo.
echo ========================================
echo 🎉 启动完成！
echo ========================================
echo.
echo 📱 应用地址: http://localhost:%FRONTEND_PORT%
echo.
echo 💡 使用说明:
echo   - 保持两个命令行窗口打开
echo   - 关闭窗口将停止服务
echo   - 如需停止服务，运行 stop.bat
echo   - 如需重启，重新运行此脚本
echo.
echo 📚 详细教程: 安装和使用教程.md
echo 🔧 修改端口: 编辑 config.json 文件
echo.
pause

