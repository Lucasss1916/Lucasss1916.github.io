---
tags:
  - unity
date: 2025-08-14T15:25:30+08:00
categories:
  - unity
  - c#
---

+++
date = '2025-11-14T15:25:30+08:00'
draft = false
title = 'Unity穿模问题'
+++
在测试的时候突然发现，人物摄像头会穿过其他模型直接透过去，在游戏里应该是个比较常见的问题，一开始通过放大模型的`boxcollider`来防止穿模，但是感觉还有更好的处理办法，询问DS老师，发现有以下几个方法：
## 1.增大碰撞体
	这是最直接，也是最方便的直接拉大碰撞体，不给模型穿模的机会
## 2.使用`Continuous`或`Continuous Dynamic`碰撞检测
	通过设置Rigidbody组件中的Collision Detection属性
		Discrete（离散）： 默认值。性能最好，但高速物体容易穿模。
		Continuous（连续）： 用于防止该物体与其他静态网格碰撞器穿模。性能开销中等。
		Continuous Dynamic（连续动态）： 用于防止该物体与其他动态物体（也设置了Continuous或Continuous Dynamic）穿模。性能开销最大。
## 3.优化角色控制器
## 4.更改移动逻辑
## 5.图层碰撞矩阵
## 6.优化美术资源
