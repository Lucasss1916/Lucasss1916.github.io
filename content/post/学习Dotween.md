---
title: 学习Dotween
date: 2025-08-19T17:00:19+08:00
draft: false
tags:
  - unity
  - Dotween
categories:
  - unity
summary: Dotween
featured_image: ""
lastmod: 2026-01-06T16:44:11+08:00
---
[Dotween官网](https://dotween.demigiant.com/)

# 1. 什么是Dotween
是一个轻量级、快速、高效的补间动画引擎，用于 Unity 中创建各种动画效果。
## 1.1. 主要特点
- **性能优秀**：比 Unity 自带的 Animation 更高效
    
- **链式语法**：流畅的代码编写体验
    
- **功能丰富**：支持多种动画类型和缓动函数
    
- **易于学习**：API 设计直观
# 2. 核心概念
## 2.1. 基本动画类型
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
## 2.2. 链式调用
```
transform.DOMove(new Vector3(5, 0, 0), 2f)
    .SetEase(Ease.OutBounce)  // 设置缓动类型
    .SetDelay(1f)             // 延迟1秒
    .OnComplete(() => {       // 完成回调
        Debug.Log("动画完成！");
    });
```
## 2.3. Sequence
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
# 3. 常用API
## 3.1. 基本动画
```
// 位置动画
DOMove(), DOLocalMove()
DOMoveX(), DOMoveY(), DOMoveZ()

// 旋转动画
DORotate(), DOLocalRotate()

// 缩放动画
DOScale(), DOScaleX(), DOScaleY(), DOScaleZ()

// UI 动画
// 需要引入 DG.Tweening.UI 命名空间
DOFade(), DOColor(), DOFillAmount()
```
## 3.2. 控制方法
```
Tween myTween = transform.DOMoveX(5, 2f);

myTween.Play();      // 播放
myTween.Pause();     // 暂停
myTween.Restart();   // 重新开始
myTween.Kill();      // 停止并销毁
myTween.Complete();  // 立即完成
```
## 3.3. 缓动函数
```
// 线性
SetEase(Ease.Linear)

// 平滑进入/退出
SetEase(Ease.InSine)
SetEase(Ease.OutSine)
SetEase(Ease.InOutSine)

// 弹性效果
SetEase(Ease.InElastic)
SetEase(Ease.OutElastic)

// 弹跳效果
SetEase(Ease.InBounce)
SetEase(Ease.OutBounce)

// 自定义曲线
SetEase(AnimationCurve)
```
# 4. 实用案例
## 4.1. 按钮点击效果
```
public class ButtonAnimation : MonoBehaviour
{
    public void OnButtonClick()
    {
        transform.DOScale(new Vector3(1.2f, 1.2f, 1.2f), 0.2f)
            .SetEase(Ease.OutBack)
            .OnComplete(() => {
                transform.DOScale(Vector3.one, 0.1f);
            });
    }
}
```
## 4.2. 对象淡入淡出
```
public class FadeObject : MonoBehaviour
{
    public CanvasGroup canvasGroup;
    
    public void FadeIn()
    {
        canvasGroup.DOFade(1, 0.5f);
    }
    
    public void FadeOut()
    {
        canvasGroup.DOFade(0, 0.5f);
    }
}
```
## 4.3. 路径移动
```
public class PathMovement : MonoBehaviour
{
    public Transform[] waypoints;
    
    void Start()
    {
        Vector3[] path = new Vector3[waypoints.Length];
        for (int i = 0; i < waypoints.Length; i++)
        {
            path[i] = waypoints[i].position;
        }
        
        transform.DOPath(path, 5f, PathType.CatmullRom)
            .SetLookAt(0.01f);
    }
}
```
# 5. Warning
**WARNING:** on iOS safeMode works only if stripping level is set to "Strip Assemblies" or Script Call Optimization is set to "Slow and Safe", while on Windows 10 WSA it won't work if Master Configuration and .NET are selected.
## 5.1. 在 iOS 平台上，`safeMode` 只有在满足以下 **任一** 条件时才能工作：

1. **Stripping Level** 设置为 `"Strip Assemblies"`。
2. **Script Call Optimization** 设置为 `"Slow and Safe"`。
**背景与现状（重要）：** 这句话提到的设置项其实比较 **老旧**（属于 Unity 较早版本的术语）。
- **Script Call Optimization:** 以前 Unity iOS 设置里有 _"Fast but no Exceptions"_（快但不处理异常）和 _"Slow and Safe"_（慢但安全）。如果你选了前者，Unity 会直接忽略异常捕获，导致 DOTween 的 `try-catch` 代码失效，`safeMode` 自然也就没用了。
- **在现代 Unity (2019/2020/2021+) 中：** 这些选项已经被 IL2CPP 的设置取代。如果你使用的是 IL2CPP，通常需要关注 Player Settings 中的 **"Enable Exceptions"** 或类似的设置。如果设置为 "None" 或极度优化，可能会导致类似问题。
## 5.2. 在 Windows 10 WSA（通用 Windows 平台 / UWP）上，如果你同时满足以下两个条件，`safeMode` 将 **无法工作**：

1. 构建配置选了 **Master Configuration**（这是 UWP 的最终发布模式，不包含调试信息）。
2. 脚本后端选了 **.NET**（非 IL2CPP）。
**原因：** 在这种极端优化的发布环境下，.NET Native 编译链可能会剥离掉 DOTween 需要的反射或异常处理机制。