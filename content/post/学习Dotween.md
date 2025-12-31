---
title: 学习Dotween
date: 2025-12-31T11:28:19+08:00
draft: true
tags: []
categories: []
summary: Dotween
featured_image: ""
lastmod: 2025-12-31T11:28:19+08:00
---
[Dotween官网](https://dotween.demigiant.com/)
# 什么是Dotween
是一个轻量级、快速、高效的补间动画引擎，用于 Unity 中创建各种动画效果。
## 主要特点
- **性能优秀**：比 Unity 自带的 Animation 更高效
    
- **链式语法**：流畅的代码编写体验
    
- **功能丰富**：支持多种动画类型和缓动函数
    
- **易于学习**：API 设计直观
# 核心概念
## 基本动画类型
```
// 安装后需要在代码中初始化
using DG.Tweening;

void Start()
{
    DOTween.Init();
}
 
// 移动
transform.DOMove(new Vector3(5, 0, 0), 2f);

// 旋转
transform.DORotate(new Vector3(0, 180, 0), 1f);

// 缩放
transform.DOScale(new Vector3(2, 2, 2), 1f);

// 颜色渐变
spriteRenderer.DOColor(Color.red, 1f);
```
## 链式调用
```
transform.DOMove(new Vector3(5, 0, 0), 2f)
    .SetEase(Ease.OutBounce)  // 设置缓动类型
    .SetDelay(1f)             // 延迟1秒
    .OnComplete(() => {       // 完成回调
        Debug.Log("动画完成！");
    });
```
## Sequence
```
Sequence mySequence = DOTween.Sequence();

// 按顺序执行动画
mySequence.Append(transform.DOMoveX(5, 1f));
mySequence.Append(transform.DORotate(new Vector3(0, 180, 0), 1f));

// 同时执行动画
mySequence.Join(transform.DOScale(new Vector3(2, 2, 2), 1f));

// 等待间隔
mySequence.AppendInterval(0.5f);
```
# 常用API
