---
title: Singletion单例模式
date: 2026-01-27T10:53:03+08:00
draft: false
tags:
  - 学习
  - CSharp
categories:
  - 学习
  - c#
summary: 单例模式
featured_image: ""
lastmod: 2026-01-27T10:53:03+08:00
---
## 1. 定义
Singleton是一种创建型设计模式，确保一个类只有一个实例，并提供一个全局唯一的访问点来获取该实例。
## 2. 核心特点
 - 唯一实例
 - 全局访问
 - 延迟初始化
## 3. 常用实现方式
```
public class Singleton
{
	private static Singleton _instance;
	private Singleton()
	{
		Console.WriteLine("实例被创建");
	
	}
	public static Singleton Instance
	{
		get
		{
			if (_instance == null) // ← 线程A检查：null
			{                      // ← 线程B检查：null（同时进入）
				_instance = new Singleton(); // ← 两个线程都执行创建！
			}
			return _instance;
		}
	}
}
如果同时有两个线程创建实例，同时检查null，会导致创建两个实例，违反单例原则。
```
## 4. 线程安全的解决方案
### 4.1. Lazy< T >
```
public class Singleton
{
    // Lazy<T> 内部自动处理线程安全
    private static readonly Lazy<Singleton> _instance = 
        new Lazy<Singleton>(() => new Singleton());
    
    private Singleton() 
    {
        Console.WriteLine("实例被创建 - 只会执行一次");
    }
    public static Singleton Instance => _instance.Value;
}

```
### 4.2. 使用lock锁
```
public class Singleton
{
    private static Singleton _instance;
    private static readonly object _lock = new object();
    
    private Singleton() { }
    
    public static Singleton Instance
    {
        get
        {
            lock (_lock)  // ← 同一时间只有一个线程能进入
            {
                if (_instance == null)
                {
                    _instance = new Singleton();
                }
                return _instance;
            }
        }
    }
}

```
以上只是针对c#来说，在unity中，因为要基于Monobehaviour，所以有些许不同。
```
//在简单的项目中，可以通过if判断，以及DontDestroyOnLoad来设置单例
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance { get; private set; }
    
    private void Awake()
    {
        // 防止重复实例
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        
        Instance = this;
        DontDestroyOnLoad(gameObject);  // 场景切换时不销毁
    }
}
```
在大型项目中，亦可创建泛型单例基类，当然适用于所有项目
```
using UnityEngine;
//abstract 抽象类；Singleton<T> 泛型；`:MonoBehaviour` 继承MonoBehaviour；
 where T : MonoBehaviour 泛型约束，限制 `T` 必须是 MonoBehaviour 的子类
public abstract class Singleton<T> : MonoBehaviour where T : MonoBehaviour
{
    private static T _instance;
    private static readonly object _lock = new object();
    private static bool _applicationIsQuitting = false;
    
    public static T Instance
    {
        get
        {
            if (_applicationIsQuitting)
            {
                return null;
            }
            
            lock (_lock)
            {
                if (_instance == null)
                {
                    _instance = FindObjectOfType<T>();
                    
                    if (_instance == null)
                    {
                        GameObject obj = new GameObject();
                        _instance = obj.AddComponent<T>();
                        obj.name = $"[Singleton] {typeof(T).Name}";
                        DontDestroyOnLoad(obj);
                    }
                }
                return _instance;
            }
        }
    }
    
    protected virtual void Awake()
    {
        if (_instance != null && _instance != this)
        {
            Destroy(gameObject);
            return;
        }
        
        _instance = this as T;
        DontDestroyOnLoad(gameObject);
        
        OnAwake();  // 子类初始化
    }
    
    // 子类重写此方法进行初始化
    protected virtual void OnAwake() { }
    
    protected virtual void OnApplicationQuit()
    {
        _applicationIsQuitting = true;
    }
}

```