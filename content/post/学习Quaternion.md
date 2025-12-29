---
title: 学习Quaternion
date: 2025-12-29T17:27:29+08:00
draft: false
tags:
  - CSharp
categories:
  - c#
summary: Quaternion
featured_image: ""
lastmod: 2025-12-29T17:27:29+08:00
---
# 什么是四元数？

四元数是一种**表示三维空间旋转**的数学工具，与欧拉角相比，它可以避免"万向节锁"问题，并且插值更平滑。
## 创建四元数
```
using UnityEngine;
// 创建四元数
Quaternion rotation = new Quaternion(x, y, z, w);
```
## 主要属性
```
// 单位四元数（无旋转）
Quaternion.identity

// 四元数的四个分量（x, y, z, w）
rotation.x
rotation.y
rotation.z
rotation.w

// 四元数的欧拉角表示
Vector3 euler = rotation.eulerAngles;
```
# 创建四元数
## 通过欧拉角床脚
```
Quaternion rot = Quaternion.Euler(30f,45f,0f);
```
## 通过轴角创建
```
Quternion rot =Quaternion.AngleAxis(90f,Vector3.up);
```
## 注视旋转
```
Vector3 direction =terget.position-transform.position
Quaternion rot =Quaternion.LookRotation(direction);
```
# 旋转运算
## 组合旋转
```
Quaternion rot1 =Quaternion.Euler(0,90,0);
Quaternion rot2 =Quaternion.Euler(30,0,0);
Quaternion combined= rot1 * rot2 ;//顺序不同会产生不同结果
```
## 旋转向量
```
Vector3 original =Vector3.forward;
Vector3 rotated = rotation * original;
```
# 插值方法
## 线性插值(Lerp)
```
// 线性插值，参数t会被钳制在[0,1]
Quaternion current = transform.rotation;
Quaternion target = Quaternion.Euler(0, 90, 0);
transform.rotation = Quaternion.Lerp(current, target, Time.deltaTime * speed);
```
## 球面线性插值(Slerp)
```
// 沿球面最短路径插值，效果更平滑
transform.rotation = Quaternion.Slerp(current, target, Time.deltaTime * speed);
```
# 实用方法
## 从from方向到to方向的旋转
```
// 计算从from方向到to方向的旋转
Quaternion rot = Quaternion.FromToRotation(Vector3.up, surfaceNormal);
```
## 点乘（相似度）
```
// 返回两个旋转的相似度（1表示相同，-1表示相反）
float similarity = Quaternion.Dot(rot1, rot2);
```
## 逆旋转
```
Quaternion inverse = Quaternion.Inverse(rotation);
```
# 注意事项
1. **四元数需要规范化**：Unity会自动处理，但自定义四元数时需要注意
2. **乘法顺序**：四元数乘法不满足交换律
3. **避免直接修改eulerAngles**：直接修改可能导致意外行为
4. **插值选择**：小角度旋转用Lerp，大角度用Slerp