---
title: GC
categories:
  - c#
tags:
  - CSharp
date: 2025-08-19T21:56:01+08:00
author: lucas
lastmod: 2025-11-24T15:56:01+08:00
---
# 1. 什么是GC
 **垃圾回收**是自动内存管理机制，负责自动释放不再使用的内存，防止内存泄漏。
# 2. 基本概念
- **根对象**：静态字段、局部变量、CPU寄存器等
- **可达性**：从根对象直接或间接引用的对象
- **代际理论**：对象生存期越短，越应该被快速回收
# 3. Net/Unity三代GC
- Generation 0 ：新创建的对象15:01
- Generation 1 ：存货过一次的gc对象
- Generation 2: 长期存活的对象
# 4. GC触发时机
- 第0代满时
- 手动调用GC.Collect（）
- 系统内存不足
- 应用程序卸载域
# 5. 主要GC来源
`using UnityEngine;`
`using System.Collections;`
`public class GCExample : MonoBehaviour`
`{`
    `void Update()`
    `{`
        `// 1. 字符串拼接`
        `string result = "Score: " + score + " Time: " + time; // 产生GC`
        `// 2. 装箱操作`
        `int number = 42;`
        `object boxed = number; // 装箱，产生GC`
        `// 3. LINQ查询`
        `var filtered = someList.Where(x => x > 10).ToList(); // 产生GC`
        `// 4. 匿名方法/Lambda`
        `someList.ForEach(x => Debug.Log(x)); // 可能产生GC`
        `// 5. 数组分配`
        `Vector3[] tempArray = new Vector3[100]; // 产生GC`
    `}`
`}`
# 6. GC优化技巧
## 6.1. 避免在循环中分配内存
## 6.2. 使用对象池，避免频繁的Instantiate/Destory
## 6.3. 避免装箱操作
## 6.4. 缓存组件和对象
## 6.5. 使用结构体替代类
## 6.6. 使用Array代替List
## 6.7. 避免在update中使用Find
