---
title: Csharp委托和事件
date: 2025-12-23T12:51:00+08:00
tags:
  - CSharp
author: lucas
lastmod: 2025-12-23T12:51:00+08:00
categories:
  - c#
cover: /images/logo.PNG
---
# 1. Csharp委托（Delegate）
## 1.1. 委托的定义
```
public delegate void newDelegate(string message);
public delegate int CalculateDelegate(int x, int y);
```
## 1.2. 使用委托
```
    // 声明委托
    delegate void PrintDelegate(string text);
    
    static void Main()
    {
        // 1. 传统方式实例化委托
        PrintDelegate printer = new PrintDelegate(PrintMessage);
        printer("Hello, World!");
        
        // 2. 简化语法（C# 2.0+）
        PrintDelegate printer2 = PrintMessage;
        printer2("Hello from simplified syntax!");
        
        // 3. 匿名方法（C# 2.0）
        PrintDelegate printer3 = delegate(string text)
        {
            Console.WriteLine("Anonymous method: " + text);
        };
        printer3("Testing anonymous method");
        
        // 4. Lambda表达式（C# 3.0+）
        PrintDelegate printer4 = (text) => Console.WriteLine("Lambda: " + text);
        printer4("Testing lambda expression");
    }
    static void PrintMessage(string message)
    {
        Console.WriteLine(message);
    }
```
## 1.3. 多播委托
```
class MulticastDelegateExample
{
	delegate void ProgressDelegate(int perfect);
	static void main()
	{
		ProgressDelegate progress =null;
		//添加多个方法到委托
		progress += UpdateProgressBar;
		progress += LogProgress;
		progress += ShowNotification;
		
		progress(50);
		progress -=LogProgess;
		Console.WriteLine("\nAfter removing LogProgress: ");
		progress(75);
	}
	static void UpdateProgressBar(int percant)
	{
		 Console.writeLine($"Progress bar updated :{percent}%")
	}
	static void LogProgress(int percent)
    {
        Console.WriteLine($"Logging progress: {percent}%");
    }
    static void ShowNotification(int percent)
    {
        Console.WriteLine($"Notification: Task is {percent}% complete");
    }
}
```
## 1.4. 内置委托类型
```
static void  Main()
{
	//1.Action<T> -  无返回值的方法
	Action<string> action1 = Console.WriteLine;
	Action<int ,int> action2 =(x,y)=> Console.WriteLine($"sum: {x+y}");
	action1("Hello Action!");
	action2(10,20);
    // 2. Func<T, TResult> - 有返回值的方法
    Func<int, int, int> add = (x, y) => x + y;
    Func<string, string> upper = s => s.ToUpper();
    
    Console.WriteLine($"Add result: {add(5, 3)}");
    Console.WriteLine($"Upper: {upper("hello")}");
	//3.Predicate<T> - 返回bool的方法
	Predicate<int> isEven =x =>x % 2 ==0
	int[] numbers ={1,2,3,4,5};
	
	var evenNumbers= Array.FindAll(numbers,isEven);
	Console.WriteLine($"Even Numbers :{string.Join(",",evenNumbers)}");
}
```
## 1.5. 委托作为参数
