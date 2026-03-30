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
lastmod: 2026-03-31T02:01:16+08:00
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
## 2. 编写Python脚本
```
#!/usr/bin/env python3

"""

Scripting.fun 文档抓取器

从 https://scripting.fun/doc_v2/zh/guide/ 抓取所有文档内容

策略：

1. 用 Playwright 加载一次页面，从侧边栏提取所有文档链接

2. 用 requests + .html 后缀批量抓取 SSR 内容（快速）

"""

import requests

from bs4 import BeautifulSoup

import json

import hashlib

import time

from pathlib import Path

  

class ScriptingDocScraper:

def __init__(self, output_path=None):

self.site_root = "https://scripting.fun"

self.entry_url = "https://scripting.fun/doc_v2/zh/guide/Quick%20Start"

self.sidebar_selector = "#__rspress_root > div.rp-doc-layout__container > aside.rp-doc-layout__sidebar"

self.visited = set()

self.docs = []

self.output_path = output_path

  

# 加载已有数据，建立 url -> {doc, content_hash} 的索引

self.existing = {}

if output_path and Path(output_path).exists():

with open(output_path, "r", encoding="utf-8") as f:

for doc in json.load(f):

h = hashlib.md5(doc["content"].encode()).hexdigest()

self.existing[doc["url"]] = {"doc": doc, "hash": h}

print(f"已加载 {len(self.existing)} 篇已有文档")

  

def discover_urls(self):

"""用 Playwright 加载页面，从侧边栏提取所有文档链接"""

from playwright.sync_api import sync_playwright

  

discovered = set()

print("正在用 Playwright 加载侧边栏...")

  

try:

with sync_playwright() as p:

browser = p.chromium.launch(headless=True)

page = browser.new_page()

page.goto(self.entry_url, wait_until="networkidle", timeout=30000)

  

sidebar = page.query_selector(self.sidebar_selector)

if not sidebar:

print(" 未找到侧边栏元素，尝试等待...")

page.wait_for_selector(self.sidebar_selector, timeout=10000)

sidebar = page.query_selector(self.sidebar_selector)

  

if sidebar:

links = sidebar.query_selector_all("a[href]")

for link in links:

href = link.get_attribute("href")

if href and "/guide/" in href:

# 将英文路径转为中文版路径

path = href

if "/doc_v2/guide/" in path and "/doc_v2/zh/guide/" not in path:

path = path.replace("/doc_v2/guide/", "/doc_v2/zh/guide/")

# 构建 .html 后缀的完整 URL

if path.endswith("/"):

html_path = path + "index.html"

else:

html_path = path + ".html"

full_url = f"{self.site_root}{html_path}"

discovered.add(full_url)

print(f" 从侧边栏发现 {len(discovered)} 个文档页面")

else:

print(" 未找到侧边栏")

  

browser.close()

except Exception as e:

print(f" Playwright 加载失败: {e}")

  

return discovered

  

def extract_content(self, soup):

"""提取页面主要内容"""

# 移除脚本和样式

for script in soup(["script", "style", "nav", "footer"]):

script.decompose()

  

# 尝试找到主要内容区域

main_content = (soup.find("main") or

soup.find("article") or

soup.find(class_="content") or

soup.find(class_="markdown-body"))

  

if main_content:

text = main_content.get_text(separator="\n", strip=True)

else:

text = soup.get_text(separator="\n", strip=True)
  

# 清理空行

lines = [line.strip() for line in text.split("\n") if line.strip()]

return "\n".join(lines)


def scrape_page(self, url):

"""抓取单个页面（增量：跳过内容未变化的页面）"""

if url in self.visited:

return False
  

self.visited.add(url)

  
try:

response = requests.get(url, timeout=10)


if response.status_code in (403, 404, 410):

print(f" 跳过 (HTTP {response.status_code}): {url}")

return False

response.raise_for_status()

response.encoding = "utf-8"


soup = BeautifulSoup(response.text, "html.parser")


title = soup.find("h1")

title_text = title.get_text(strip=True) if title else url

  

content = self.extract_content(soup)

  

if not content or len(content) < 10:

print(f" 跳过 (内容为空): {url}")

return False

  

# 增量判断：内容哈希相同则跳过

content_hash = hashlib.md5(content.encode()).hexdigest()

if url in self.existing and self.existing[url]["hash"] == content_hash:

# 内容未变，沿用旧数据

self.docs.append(self.existing[url]["doc"])

return False

  

doc = {

"url": url,

"title": title_text,

"content": content

}

self.docs.append(doc)

return True # 标记为新增/更新

  

except Exception as e:

print(f" 错误 {url}: {e}")

# 出错时保留旧数据

if url in self.existing:

self.docs.append(self.existing[url]["doc"])

return False

  

def scrape_all(self):

"""增量抓取所有页面"""

urls = self.discover_urls()

  

if not urls:

print("未发现任何文档页面，请检查网站是否可访问")

return self.docs, False

  

url_list = sorted(urls)

total = len(url_list)

updated = 0

skipped = 0

  

print(f"\n开始抓取 {total} 个页面（已有 {len(self.existing)} 篇）...\n")

  

for i, url in enumerate(url_list, 1):

is_new = self.scrape_page(url)

if is_new:

updated += 1

print(f" [{i}/{total}] 新增/更新: {url}")

else:

skipped += 1

time.sleep(0.3)

  

# 检测已删除的页面（旧数据中有，但侧边栏中不再存在）

removed = set(self.existing.keys()) - urls

if removed:

print(f"\n检测到 {len(removed)} 篇已删除的页面")

  

has_changes = updated > 0 or len(removed) > 0

print(f"\n完成! 共 {len(self.docs)} 篇 | 新增/更新: {updated} | 未变化: {skipped} | 删除: {len(removed)}")

  

return self.docs, has_changes

  

def save_to_json(self, output_path):

"""保存为 JSON 文件"""

with open(output_path, "w", encoding="utf-8") as f:

json.dump(self.docs, f, ensure_ascii=False, indent=2)

print(f"已保存到: {output_path}")

  
  

if __name__ == "__main__":

data_dir = Path(__file__).parent.parent / "data"

data_dir.mkdir(exist_ok=True)

output_file = data_dir / "scripting_docs.json"

  

scraper = ScriptingDocScraper(output_path=output_file)

docs, has_changes = scraper.scrape_all()

  

if has_changes:

scraper.save_to_json(output_file)

print("文档已更新")

else:

print("无变化，跳过写入")
```
