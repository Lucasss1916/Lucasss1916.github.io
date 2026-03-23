---
title: N8n工作流(scripting文档)
date: 2026-03-19T14:05:21+08:00
draft: false
tags:
  - 学习
  - n8n
categories:
  - 学习
  - 工作流
summary: 使用n8n定时抓取scripting网页文档，并生成相应的数据库
featured_image: ""
lastmod: 2026-03-23T13:17:09+08:00
---
## 1. 创建相应文件夹并配置环境
```
//创建文件夹
mkdir -p /scripting-knowledge/{scripts,data,logs}
cd /scripting-knowledge && ls -la
//配置python虚拟环境
cd /scripting-knowledge && python3 -m venv venv
source venv/bin/activate && pip install --upgrade pip
//安装必要的包
pip install chromadb llama-index beautifulsoup4 requests lxml
```
### 1.1. 为什么要配置虚拟python环境
- 避免依赖冲突
- 不影响系统自带python（因为是在mac中，mac系统自带的比较重要）
- 依赖管理清晰
- 权限问题，虚拟环境不需要sudo