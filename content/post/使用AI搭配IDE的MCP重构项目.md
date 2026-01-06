---
title: 使用AI搭配IDE的MCP重构项目
date: 2026-01-05T15:35:36+08:00
draft: false
tags:
  - 学习
  - AI
categories:
  - 学习
summary: 使用ai重构项目
featured_image: ""
lastmod: 2026-01-05T15:35:36+08:00
---
# 1. 使用AI模型搭配MCP重构项目
JetBrains的IDE提供内置的MCP server功能，通过MCP协议，ai模型可以直接通过IDE查看代码，并进行更改，使用`get_symbol_info` 和 `rename_refactoring`
## 1.1. get_symbol_info
在传统ai中，ai通过阅读代码，或将整个代码复制给AI阅读，如果需要理解上下文，还需要将有关联的代码复制给他，才可以理解，但是有了MCP，它就可以通过调用`get_symbol_info`来读取函数的定义、参数类型、注释文档，甚至可以看到该函数是在哪里被定义的。
得益于Jetbrains的索引能力，静态分析能力，提供给AI**100%准确**的符号信息，而不是靠AI自己猜测。
## 1.2. rename_refactoring

这是最关键的重构工具，与“查找并替换”不同，调用IDE内部的重构引擎(`Refactoring Engine`)，当AI模型需要改名时，不是自己生成一个新文本，而是向IDE发送一个指令：“请对该变量进行重命名操作”。
### 1.2.1. 为什么适用于Jetbrains
- 上下文感知：如果你的项目里有两个不同类都有 `id` 这个变量，普通的 AI 生成代码可能会搞混，导致全都改了。但 `rename_refactoring` 通过 IDE 的 PSI (程序结构接口) 知道只改你指定的那个类的 `id`。
- 全项目更新：它会自动更新所有的导入路径（imports）、注释中的引用、甚至是 XML/YAML 配置文件中的引用（如果 IDE 支持）。
## 1.3. 工作流程
### 1.3.1. 输入提示词
“请检查`User.cs`中的`uid`变量，命名太模糊，根据他的用途重构一个更为清晰的名字。”
### 1.3.2. AI工具思考调用
- **第一步 (观察)：** 调用 `get_symbol_info` 查看 `uid` 的定义和用法。Claude 发现它是一个 String 类型的用户唯一标识符。
- **第二步 (决策)：** Claude 决定将其重命名为 `userUniqueId`。
- **第三步 (行动)：** 调用 `rename_refactoring`，传入文件路径和新名字 `userUniqueId`。
### 1.3.3. IDE执行
- IDE 接收到指令，弹出（或静默执行）重构预览。
- IDE 确保这次修改是安全的（不报错、不冲突）。
- IDE 修改所有引用了该变量的文件。
### 1.3.4. 返回结果
Claude 返回消息："已成功将 `uid` 重命名为 `userUniqueId`，并更新了 15 处引用。"


