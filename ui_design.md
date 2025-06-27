# PPT字体修改工具 - UI设计规范

## 设计理念

### 核心原则
- **简洁明了**: 界面简洁，操作直观
- **专业可靠**: 体现工具的专业性和可靠性
- **高效流畅**: 减少用户操作步骤，提高效率
- **友好反馈**: 及时的状态反馈和错误提示

### 视觉风格
- **现代简约**: 采用现代扁平化设计
- **科技感**: 体现AI和自动化的科技属性
- **专业性**: 适合商务和学术场景使用

## 色彩系统

### 主色调
```css
/* 主品牌色 - 科技蓝 */
--primary-blue: #2563eb;
--primary-blue-light: #3b82f6;
--primary-blue-dark: #1d4ed8;

/* 辅助色 - 成功绿 */
--success-green: #10b981;
--success-green-light: #34d399;

/* 警告色 - 橙色 */
--warning-orange: #f59e0b;
--warning-orange-light: #fbbf24;

/* 错误色 - 红色 */
--error-red: #ef4444;
--error-red-light: #f87171;

/* 中性色 */
--gray-50: #f9fafb;
--gray-100: #f3f4f6;
--gray-200: #e5e7eb;
--gray-300: #d1d5db;
--gray-400: #9ca3af;
--gray-500: #6b7280;
--gray-600: #4b5563;
--gray-700: #374151;
--gray-800: #1f2937;
--gray-900: #111827;
```

### 字体系统
```css
/* 主要字体 */
--font-primary: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
--font-mono: 'JetBrains Mono', 'Fira Code', monospace;

/* 字体大小 */
--text-xs: 0.75rem;    /* 12px */
--text-sm: 0.875rem;   /* 14px */
--text-base: 1rem;     /* 16px */
--text-lg: 1.125rem;   /* 18px */
--text-xl: 1.25rem;    /* 20px */
--text-2xl: 1.5rem;    /* 24px */
--text-3xl: 1.875rem;  /* 30px */
--text-4xl: 2.25rem;   /* 36px */
```

## 组件设计

### 1. 页面头部 (Header)

```jsx
<Header>
  <Logo>
    <Icon name="font-replace" />
    <Title>PPT字体替换工具</Title>
  </Logo>
  <Subtitle>自动将PPT中的中英文字体替换为指定字体</Subtitle>
</Header>
```

**设计要点**:
- 简洁的Logo设计，体现字体替换功能
- 清晰的工具说明
- 渐变背景增加视觉层次

### 2. 文件上传区域 (FileUpload)

```jsx
<UploadZone>
  <DropArea isDragOver={isDragOver}>
    <Icon name="upload-cloud" size="large" />
    <PrimaryText>拖拽PPT文件到此处</PrimaryText>
    <SecondaryText>或</SecondaryText>
    <UploadButton>选择文件</UploadButton>
    <HelpText>
      支持格式: .pptx | 最大文件: 50MB
    </HelpText>
  </DropArea>
</UploadZone>
```

**交互状态**:
- **默认状态**: 虚线边框，淡蓝色背景
- **悬停状态**: 实线边框，深蓝色背景
- **拖拽状态**: 高亮边框，动画效果
- **错误状态**: 红色边框，错误提示

### 3. 字体设置面板 (FontSettings)

```jsx
<FontPanel>
  <PanelTitle>字体设置</PanelTitle>
  <FontOption>
    <Label>中文字体</Label>
    <FontDisplay>
      <FontName>Noto Sans SC</FontName>
      <StatusIcon status="available" />
    </FontDisplay>
    <FontPreview>中文字体预览效果</FontPreview>
  </FontOption>
  <FontOption>
    <Label>英文字体</Label>
    <FontDisplay>
      <FontName>NVIDIA Sans</FontName>
      <StatusIcon status="available" />
    </FontDisplay>
    <FontPreview>English Font Preview</FontPreview>
  </FontOption>
</FontPanel>
```

**状态指示**:
- ✅ 字体可用
- ⚠️ 字体缺失
- 🔄 字体加载中

### 4. 处理进度组件 (ProcessingStatus)

```jsx
<ProcessingPanel>
  <StatusHeader>
    <StatusIcon status={currentStatus} />
    <StatusText>{statusMessage}</StatusText>
  </StatusHeader>
  
  <ProgressBar>
    <ProgressFill width={`${progress}%`} />
    <ProgressText>{progress}%</ProgressText>
  </ProgressBar>
  
  <DetailInfo>
    <CurrentStep>正在处理第 {currentSlide}/{totalSlides} 张幻灯片</CurrentStep>
    <TimeEstimate>预计剩余时间: {estimatedTime}</TimeEstimate>
  </DetailInfo>
  
  <ProcessingSteps>
    <Step completed>📁 文件上传</Step>
    <Step active>🔍 文本分析</Step>
    <Step>🎨 字体替换</Step>
    <Step>💾 文件生成</Step>
  </ProcessingSteps>
</ProcessingPanel>
```

**处理状态**:
1. **上传中**: 蓝色进度条，上传图标
2. **分析中**: 黄色进度条，分析图标
3. **处理中**: 绿色进度条，处理图标
4. **完成**: 绿色背景，完成图标
5. **错误**: 红色背景，错误图标

### 5. 结果下载区域 (DownloadSection)

```jsx
<DownloadSection>
  <SuccessMessage>
    <SuccessIcon />
    <Message>字体替换完成！</Message>
  </SuccessMessage>
  
  <FileInfo>
    <FileName>{originalFileName}_字体已替换.pptx</FileName>
    <FileSize>{fileSize}</FileSize>
    <ProcessTime>处理时间: {processingTime}</ProcessTime>
  </FileInfo>
  
  <ActionButtons>
    <DownloadButton primary>
      <DownloadIcon />
      下载文件
    </DownloadButton>
    <PreviewButton>
      <PreviewIcon />
      预览更改
    </PreviewButton>
  </ActionButtons>
  
  <ProcessSummary>
    <SummaryItem>
      <Label>处理幻灯片</Label>
      <Value>{processedSlides} 张</Value>
    </SummaryItem>
    <SummaryItem>
      <Label>替换文本</Label>
      <Value>{replacedTexts} 处</Value>
    </SummaryItem>
    <SummaryItem>
      <Label>中文字符</Label>
      <Value>{chineseChars} 个</Value>
    </SummaryItem>
    <SummaryItem>
      <Label>英文字符</Label>
      <Value>{englishChars} 个</Value>
    </SummaryItem>
  </ProcessSummary>
</DownloadSection>
```

## 响应式布局

### 桌面端 (≥1200px)
```css
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
  display: grid;
  grid-template-columns: 1fr;
  gap: 2rem;
}

.upload-section {
  grid-column: 1;
}

.settings-section {
  grid-column: 1;
}
```

### 平板端 (768px - 1199px)
```css
.container {
  max-width: 768px;
  padding: 1.5rem;
  gap: 1.5rem;
}

.upload-zone {
  min-height: 200px;
}
```

### 移动端 (<768px)
```css
.container {
  padding: 1rem;
  gap: 1rem;
}

.upload-zone {
  min-height: 150px;
}

.font-panel {
  padding: 1rem;
}

.action-buttons {
  flex-direction: column;
  gap: 0.5rem;
}
```

## 动画效果

### 页面加载动画
```css
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.page-enter {
  animation: fadeInUp 0.6s ease-out;
}
```

### 拖拽反馈动画
```css
@keyframes dragHover {
  0%, 100% {
    transform: scale(1);
    border-color: var(--primary-blue);
  }
  50% {
    transform: scale(1.02);
    border-color: var(--primary-blue-light);
  }
}

.drop-zone.drag-over {
  animation: dragHover 1s ease-in-out infinite;
}
```

### 进度条动画
```css
@keyframes progressPulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.7;
  }
}

.progress-bar.active {
  animation: progressPulse 2s ease-in-out infinite;
}
```

## 错误处理UI

### 错误提示组件
```jsx
<ErrorAlert>
  <ErrorIcon />
  <ErrorContent>
    <ErrorTitle>处理失败</ErrorTitle>
    <ErrorMessage>{errorMessage}</ErrorMessage>
    <ErrorActions>
      <RetryButton>重试</RetryButton>
      <ContactButton>联系支持</ContactButton>
    </ErrorActions>
  </ErrorContent>
</ErrorAlert>
```

### 常见错误类型
1. **文件格式错误**: "请上传.pptx格式的文件"
2. **文件过大**: "文件大小超过50MB限制"
3. **文件损坏**: "文件可能已损坏，请重新上传"
4. **字体缺失**: "系统缺少必要字体，请联系管理员"
5. **网络错误**: "网络连接异常，请检查网络后重试"

## 可访问性设计

### 键盘导航
- Tab键顺序合理
- 焦点状态清晰可见
- 支持Enter和Space键操作

### 屏幕阅读器支持
- 语义化HTML标签
- 适当的ARIA标签
- 图片alt文本

### 色彩对比
- 文本对比度≥4.5:1
- 重要元素对比度≥7:1
- 支持高对比度模式

这个UI设计充分考虑了用户体验和功能需求，确保工具既专业又易用。

