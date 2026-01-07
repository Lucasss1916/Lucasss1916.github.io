---
title: 游戏向shader的学习路线
date: 2026-01-07T16:01:00+08:00
draft: false
tags:
  - 学习
  - unity
  - shader
categories:
  - 学习
  - unity
summary: ""
featured_image: ""
lastmod: 2026-01-07T16:01:00+08:00
---
ChatGPT提供的学习路线
- 看懂大部分 Unity 游戏 Shader
- 自己实现常见游戏效果
- 知道效果该用 Shader、还是粒子、还是后处理
# 阶段0
## 需要储备的基础知识，可以学习的补肾，但一定要会
- 向量：flaot2 float3 float4
- dot normalize length
- lerp clamp saturate
- 基本三角函数
# 阶段1
## Unlit Shader
**学习目标**：
- 理解shader在“干什么”
- 建立“GPU思维”
- 会写简单视觉变化
**必须会的效果**：
1. 纯色/渐变
2. UV操作
	- 平移/缩放
	- 滚动纹理（水流，能量条）
3. 基于时间的动画
4. 遮罩
	- 圆形/条形
	- 血条，冷却条，范围提示
# 阶段2
## 基础光照
游戏光照≠真实光照
必须手写的光照模型
1. Lambert 理解：明暗分界线 、模型体积感
2. Blinn-Phong 理解： 高光位置 、材质区分感
# 阶段3
## 贴图
1. albedo/Normal/Mask
	- 为什么法线贴图是紫色
	- 为什么要normal * 2-1 
	- Mask一张图塞4个通道
2. 法线贴图 + 光照
	- TBN是干嘛的
	- 不用手推矩阵，但直到意义
**游戏常用技巧**
- 用贴图假装细节
- 不用增加面数
- 不增加计算
# 阶段4 
## 游戏shader的“灵魂技巧”
**必学效果**
1. Fresnel
	- 角色边缘光
	- 技能轮廓
	- 能量护盾
2. Rim Light
	- 强化轮廓
	- 提升角色可读性
3. Dissolve（溶解）
	- 出生/消失
	- 传送
	- 技能效果
4. Distortion（扭曲）
	- 热浪
	- 能量波
	- 空气震荡
# 阶段5
## 透明 、半透明、特效shader
**必须理解**：
- Alpha Blend
- Additive
- Depth
**游戏特效核心**：
- 粒子+shader
- BillBoard
- UV动画
- soft particle
# 阶段6
## 后处理
**必学后处理**
- Bloom（亮部扩散）
- Color Grading （色调）
- Vignette
- 简单Blur
# 阶段7
## Shader Graph
- 用 Graph 快速试效果
- 读生成的 HLSL
- 自己改关键逻辑