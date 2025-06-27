@echo off
chcp 65001 >nul
echo ========================================
echo PPT字体替换工具 - 停止服务
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
)

echo 🔍 检查运行中的服务...

:: 停止后端服务 (Flask)
echo 正在停止后端服务 (端口 %BACKEND_PORT%)...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":%BACKEND_PORT%"') do (
    echo 发现进程 %%a，正在终止...
    taskkill /PID %%a /F >nul 2>&1
    if !errorlevel! equ 0 (
        echo ✅ 后端服务已停止
    ) else (
        echo ⚠️  无法停止进程 %%a
    )
)

:: 停止前端服务 (Vite)
echo 正在停止前端服务 (端口 %FRONTEND_PORT%)...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":%FRONTEND_PORT%"') do (
    echo 发现进程 %%a，正在终止...
    taskkill /PID %%a /F >nul 2>&1
    if !errorlevel! equ 0 (
        echo ✅ 前端服务已停止
    ) else (
        echo ⚠️  无法停止进程 %%a
    )
)

:: 停止所有相关的Python和Node.js进程
echo 正在停止相关进程...

:: 停止包含main.py的Python进程
for /f "tokens=2" %%a in ('tasklist /FI "IMAGENAME eq python.exe" /FO CSV ^| findstr "main.py"') do (
    echo 停止Python进程 %%a...
    taskkill /PID %%a /F >nul 2>&1
)

:: 停止包含vite的Node.js进程
for /f "tokens=2" %%a in ('wmic process where "name='node.exe' and commandline like '%%vite%%'" get processid /format:csv ^| findstr /v "Node"') do (
    if not "%%a"=="" (
        echo 停止Vite进程 %%a...
        taskkill /PID %%a /F >nul 2>&1
    )
)

:: 关闭相关的命令行窗口
echo 正在关闭相关窗口...
for /f "tokens=2" %%a in ('tasklist /FI "WINDOWTITLE eq PPT字体替换工具*" /FO CSV 2^>nul ^| findstr "cmd.exe"') do (
    echo 关闭窗口进程 %%a...
    taskkill /PID %%a /F >nul 2>&1
)

echo.
echo ========================================
echo 🎉 所有服务已停止！
echo ========================================
echo.
echo 💡 提示:
echo   - 如需重新启动，运行 start.bat
echo   - 如需修改端口，编辑 config.json 文件
echo.
pause

