---
title: 学习Dotween
date: 2025-09-31T11:28:19+08:00
draft: true
tags:
  - unity
  - Dotween
categories:
  - unity
summary: Dotween
featured_image: ""
lastmod: 2025-12-31T11:28:19+08:00
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