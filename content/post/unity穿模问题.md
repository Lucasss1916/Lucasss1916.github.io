---
tags:
  - unity
date: 2025-07-14T15:25:30+08:00
categories:
  - unity
title: Unity穿模问题
summary: 穿模
---
在测试的时候突然发现，人物摄像头会穿过其他模型直接透过去，在游戏里应该是个比较常见的问题，一开始通过放大模型的boxcollider来防止穿模，但是感觉还有更好的处理办法，询问DS老师，发现有以下几个方法：

# 1. 增大碰撞体
这是最直接，也是最方便的直接拉大碰撞体，不给模型穿模的机会
# 2. 使用`Continuous`或`Continuous Dynamic`碰撞检测
通过设置Rigidbody组件中的Collision Detection属性
		Discrete（离散）： 默认值。性能最好，但高速物体容易穿模。
		Continuous（连续）： 用于防止该物体与其他静态网格碰撞器穿模。性能开销中等。
		Continuous Dynamic（连续动态）： 用于防止该物体与其他动态物体（也设置了Continuous或Continuous Dynamic）穿模。性能开销最大。
- **建议**：只给**高速移动的物体**（如子弹、玩家角色、高速飞行的道具）设置 `Continuous Dynamic`，给静态但复杂的网格碰撞器设置 `Continuous`。不要滥用，否则会严重影响性能。
# 3. 优化角色控制器
1.如果使用的是`CharacterController`则调整`slope Limit`（坡度限制）和 `step Offset`（台阶高度
2.使用`Rigidbody` + `CapsuleCollider`
# 4. 更改移动逻辑
添加代码判断与物体之间的距离，达到一定距离后，使用代码限制移动
更高级的方案：`Physics.SphereCast` 或 `Physics.CapsuleCast`（还没测试过）
- 这些方法比 `Raycast` 更精确，因为它们考虑了碰撞体的体积，能更好地模拟角色本身的形状进行预测
# 5. 图层碰撞矩阵
- **方法**：进入 `Edit -> Project Settings -> Physics`，查看 `Layer Collision Matrix`。
- **使用**：你可以创建不同的图层（Layer），例如“Player”、“Enemy”、“Environment”、“Ignore Raycast”等。然后在这个矩阵中，取消勾选不需要相互碰撞的图层。例如，你可能不希望两个玩家之间发生物理碰撞，就可以取消Player层与Player层的勾选。
# 6. 优化美术资源
- 不使用meshcollider，不勾选convex（计算成本很高）
- 使用原始碰撞体拼接
