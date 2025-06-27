# PPT字体替换工具

一个专业的Web应用，用于自动替换PowerPoint演示文稿中的字体，支持中英文字符级别的精确替换。

## 功能特点

### 🎯 核心功能
- **智能字体替换**: 自动识别中文和英文字符，分别应用不同字体
- **格式保持**: 保持原有的字体大小、颜色、粗体、斜体等格式属性
- **批量处理**: 一次性处理整个PPT文件的所有幻灯片
- **实时进度**: 显示处理进度和详细统计信息

### 📝 字体设置
- **中文字体**: Noto Sans SC
- **英文字体**: NVIDIA Sans
- **混合文本处理**: 在同一段落中，中英文字符使用不同字体

### 🔧 技术特性
- **文件格式**: 支持.pptx格式
- **文件大小**: 最大支持50MB
- **处理速度**: 快速处理，实时反馈
- **安全性**: 文件自动清理，保护隐私

## 系统架构

### 前端 (React)
- 现代化的用户界面
- 拖拽上传功能
- 实时进度显示
- 响应式设计

### 后端 (Flask)
- RESTful API设计
- 文件上传处理
- PPT字体替换引擎
- 错误处理和日志

### 字体处理引擎
- 基于python-pptx库
- 字符级别的字体识别
- 格式属性保持
- 批量处理优化

## 项目结构

```
ppt-font-changer/
├── backend/                 # Flask后端应用
│   ├── src/
│   │   ├── routes/         # API路由
│   │   ├── services/       # 业务逻辑
│   │   └── main.py         # 应用入口
│   ├── venv/               # Python虚拟环境
│   └── requirements.txt    # Python依赖
├── frontend/               # React前端应用
│   ├── src/
│   │   ├── components/     # React组件
│   │   └── App.jsx         # 主应用组件
│   └── package.json        # Node.js依赖
├── fonts/                  # 字体文件
│   ├── NVIDIASans_V3.000_Desktop_Install/
│   └── Noto_Sans_SC/
├── research_findings.md    # 技术研究文档
├── architecture_design.md # 架构设计文档
├── ui_design.md           # UI设计规范
└── README.md              # 项目说明
```

## 安装和运行

### 环境要求
- Python 3.11+
- Node.js 20+
- pnpm

### 后端启动
```bash
cd backend
source venv/bin/activate
pip install -r requirements.txt
python src/main.py
```

### 前端启动
```bash
cd frontend
pnpm install
pnpm run dev --host
```

### 访问应用
- 前端界面: http://localhost:5173
- 后端API: http://localhost:5001

## 使用说明

### 1. 上传文件
- 拖拽.pptx文件到上传区域
- 或点击"选择文件"按钮选择文件
- 支持最大50MB的文件

### 2. 开始处理
- 文件上传成功后，点击"上传文件"按钮
- 系统会自动开始处理
- 实时显示处理进度

### 3. 下载结果
- 处理完成后，点击"下载处理后的文件"
- 文件名会自动添加"_字体已替换"后缀
- 查看处理统计信息

## API文档

### 文件上传
```
POST /api/ppt/upload
Content-Type: multipart/form-data

参数:
- file: PPT文件 (.pptx)

返回:
{
  "success": true,
  "file_id": "uuid",
  "filename": "原文件名",
  "file_size": 文件大小
}
```

### 文件处理
```
POST /api/ppt/process
Content-Type: application/json

参数:
{
  "file_id": "文件ID",
  "chinese_font": "Noto Sans SC",
  "english_font": "NVIDIA Sans"
}

返回:
{
  "success": true,
  "processing_stats": {
    "processed_slides": 处理的幻灯片数,
    "chinese_chars": 中文字符数,
    "english_chars": 英文字符数,
    ...
  }
}
```

### 文件下载
```
GET /api/ppt/download/{file_id}

返回: 处理后的PPT文件
```

## 技术实现

### 字符识别算法
```python
def is_chinese_char(char):
    """检测中文字符 (Unicode范围: 4E00-9FFF)"""
    return '\u4e00' <= char <= '\u9fff'

def is_english_char(char):
    """检测英文字符"""
    return char.isascii() and char.isalpha()
```

### 字体替换流程
1. **文本解析**: 遍历所有幻灯片、形状、文本框
2. **段落处理**: 分析每个段落的Run结构
3. **字符分类**: 按字符类型（中文/英文）分组
4. **Run重构**: 创建新的Run并应用对应字体
5. **属性保持**: 复制原有的格式属性

### 格式属性保持
- 字体大小 (font.size)
- 字体颜色 (font.color.rgb)
- 粗体 (font.bold)
- 斜体 (font.italic)
- 下划线 (font.underline)
- 删除线 (font.strike)

## 测试用例

### 混合文本示例
- "Hello 世界" → Hello(NVIDIA Sans) + 世界(Noto Sans SC)
- "AI人工智能(Artificial Intelligence)" → 混合字体显示
- "iPhone 15 Pro Max售价￥9999" → 品牌名、数字、货币符号处理

### 处理统计
- 处理幻灯片数量
- 中文字符统计
- 英文字符统计
- 处理段落数量
- 错误信息记录

## 性能优化

### 前端优化
- 组件懒加载
- 文件分片上传
- 实时进度更新
- 错误重试机制

### 后端优化
- 异步文件处理
- 内存使用优化
- 批量处理策略
- 临时文件清理

## 安全考虑

### 文件安全
- 文件类型验证
- 文件大小限制
- 临时文件自动清理
- 无用户数据收集

### 数据保护
- HTTPS传输
- 文件加密存储
- 处理后自动删除
- 隐私保护机制

## 错误处理

### 常见错误
1. **文件格式不支持**: 只支持.pptx格式
2. **文件过大**: 超过50MB限制
3. **文件损坏**: 无法解析的PPT文件
4. **字体缺失**: 系统字体不可用
5. **处理超时**: 文件过于复杂

### 错误恢复
- 友好的错误提示
- 自动重试机制
- 详细的错误日志
- 降级处理方案

## 开发团队

本项目由Manus AI开发，专注于文档处理和字体技术的创新应用。

## 版本历史

### v1.0.0 (2025-06-27)
- 初始版本发布
- 支持中英文字体替换
- Web界面和API
- 完整的处理流程

## 许可证

本项目仅供学习和研究使用。

## 联系我们

如有问题或建议，请联系开发团队。

---

**注意**: 本工具专门设计用于处理中英文混合的PPT文档，确保在字符级别进行精确的字体替换，同时保持原有的格式属性不变。

# font_changer
