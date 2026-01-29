---
title: Async和Await
date: 2026-01-28T15:25:01+08:00
draft: false
tags:
  - 学习
  - CSharp
  - unity
categories:
  - 学习
  - c#
  - unity
summary: Async，Await
featured_image: ""
lastmod: 2026-01-28T15:25:01+08:00
---
## 1. C#中的Async和Await
async和await是c#中用于简化异步编程的语法糖。
- async主要用于标记，告诉编译器这是异步方法。
- 在async的方法中才能使用await。
- 普通方法返回T，async方法返回Task< T >

```
public async Task ProcessDataAsync()
{
    Console.WriteLine("步骤1：开始");
    
    // 这行代码会被编译器"切割"
    string data = await DownloadAsync("url"); // <-- 切割点
    
    //将方法进行切割，等待任务执行完成后，再继续执行
    Console.WriteLine("步骤2：完成，数据=" + data);
}
```
## 2. unity的特殊性
在unity中不能直接使用c#的异步，因为Unity API必须在主线程中调用
考虑到：性能和稳定性以及避免多线程的复杂性以及bug。
## 3. Unity解决方案
对比传统的coroutine，新方案Awaitable有更多的有点

|特性|协程 (Coroutine)|Awaitable (Unity 2023+)|
|---|---|---|
|**引入时间**|Unity 早期就有|Unity 2023.1+|
|**语法风格**|`yield return`|`async/await`|
|**返回类型**|`IEnumerator`|`Awaitable` / `Awaitable<T>`|
|**返回值**|❌ 不支持直接返回|✅ 支持 `Awaitable<T>`|
|**异常处理**|❌ 困难（需要try-catch包裹整个方法）|✅ 标准的 try-catch|
|**取消操作**|❌ 需要手动实现|✅ 支持 CancellationToken|
|**性能**|⚡ 轻量（少量GC）|⚡⚡ 更优化（几乎零GC）|
|**学习曲线**|🔷 Unity特有概念|🔷 标准C#知识|
|**代码可读性**|👎 较差（嵌套复杂）|👍 很好（线性流程）|
### 3.1. awaitable语法
```
// ========== Awaitable 写法 ==========
//可以直接调用，不需要通过startcoroutine启动
public class AwaitableVersion : MonoBehaviour
{
    async void Start()
    {
        Debug.Log("等待开始");
        
        await Awaitable.WaitForSecondsAsync(2f);
        
        Debug.Log("2秒后执行");
    }
}
```

```
// ========== Awaitable 顺序执行多个操作 ==========
async Awaitable SequenceAwaitable()
{
    // 移动到位置1
    await MoveToAsync(position1);
    
    // 等待2秒
    await Awaitable.WaitForSecondsAsync(2f);
    
    // 移动到位置2
    await MoveToAsync(position2);
    
    Debug.Log("全部完成");
}
async Awaitable MoveToAsync(Vector3 target)
{
    while (Vector3.Distance(transform.position, target) > 0.1f)
    {
        transform.position = Vector3.MoveTowards(
            transform.position, 
            target, 
            Time.deltaTime * 5f
        );
        await Awaitable.NextFrameAsync(); // 等待下一帧
    }
}
```
### 3.2. awaitable返回值处理
```
// ========== Awaitable（直接返回）==========
public class AwaitableReturn : MonoBehaviour
{
    async void Start()
    {
        // ✅ 直接获取返回值
        string data = await DownloadDataAsync();
        Debug.Log("收到数据：" + data);
        
        // ✅ 继续处理，代码线性流畅
        bool success = await ProcessDataAsync(data);
        Debug.Log("处理完成：" + success);
        
        // ✅ 所有逻辑在一个方法里，清晰明了
    }
    
    async Awaitable<string> DownloadDataAsync()
    {
        await Awaitable.WaitForSecondsAsync(2f);
        return "下载的数据"; // ✅ 直接返回
    }
    
    async Awaitable<bool> ProcessDataAsync(string data)
    {
        await Awaitable.WaitForSecondsAsync(1f);
        return true; // ✅ 直接返回
    }
}

```
### 3.3. awaitable异常处理
```
// ========== Awaitable 的错误处理 ==========
public class AwaitableError : MonoBehaviour
{
    async void Start()
    {
        // ✅ 标准的 try-catch，像普通方法一样
        try
        {
            await RiskyOperationAsync();
            Debug.Log("操作成功");
        }
        catch (System.Exception e)
        {
            Debug.LogError("捕获错误：" + e.Message);
            // ✅ 可以在这里处理错误
        }
        finally
        {
            Debug.Log("清理资源");
        }
    }
    
    async Awaitable RiskyOperationAsync()
    {
        await Awaitable.WaitForSecondsAsync(1f);
        
        // 抛出异常
        throw new System.Exception("出错了！");
        
        // 异常会自动传递给调用者
    }
    
    // ✅ 多层调用也能正确传递异常
    async Awaitable ChainedOperation()
    {
        try
        {
            await RiskyOperationAsync(); // 异常会向上传递
        }
        catch (System.Exception e)
        {
            Debug.LogError("在链式调用中捕获：" + e.Message);
            throw; // 可以选择继续向上抛出
        }
    }
}

```
### 3.4. awaitable取消操作
```
// ========== Awaitable 的取消（标准化）==========
public class AwaitableCancel : MonoBehaviour
{
    private CancellationTokenSource cts;
    
    void Start()
    {
        cts = new CancellationTokenSource();
        LongOperationAsync(cts.Token).Forget(); // 启动异步操作
    }
    
    async Awaitable LongOperationAsync(CancellationToken token)
    {
        try
        {
            for (int i = 0; i < 10; i++)
            {
                // ✅ 自动检查取消请求
                token.ThrowIfCancellationRequested();
                
                Debug.Log("步骤 " + i);
                
                // ✅ 等待时也会响应取消
                await Awaitable.WaitForSecondsAsync(1f, token);
            }
        }
        catch (OperationCanceledException)
        {
            Debug.Log("操作被取消");
        }
        finally
        {
            // ✅ finally 块保证执行，可以清理资源
            Debug.Log("清理资源");
        }
    }
    
    // 取消操作
    public void Cancel()
    {
        cts?.Cancel(); // ✅ 一行代码取消所有相关操作
    }
    
    void OnDestroy()
    {
        // ✅ 对象销毁时自动取消
        cts?.Cancel();
        cts?.Dispose();
        
        // 或者使用 Unity 的扩展方法
        // var token = this.GetCancellationTokenOnDestroy();
    }
}

// 扩展方法：Forget() 用于不需要等待的异步操作
public static class AwaitableExtensions
{
    public static async void Forget(this Awaitable awaitable)
    {
        try
        {
            await awaitable;
        }
        catch (System.Exception e)
        {
            Debug.LogException(e);
        }
    }
}

```
### 3.5. Awaitable 的并行执行
```
// ========== Awaitable 并行（简单）==========
public class AwaitableParallel : MonoBehaviour
{
    async void Start()
    {
        // ✅ 方法1：使用 WhenAll 等待所有任务
        await Awaitable.WhenAll(
            Task1Async(),
            Task2Async(),
            Task3Async()
        );
        
        Debug.Log("所有任务完成");
        
        // ✅ 方法2：获取所有任务的返回值
        var results = await Awaitable.WhenAll(
            DownloadAsync("url1"),
            DownloadAsync("url2"),
            DownloadAsync("url3")
        );
        
        foreach (var result in results)
        {
            Debug.Log("结果：" + result);
        }
    }
    
    async Awaitable Task1Async()
    {
        await Awaitable.WaitForSecondsAsync(1f);
        Debug.Log("任务1完成");
    }
    
    async Awaitable Task2Async()
    {
        await Awaitable.WaitForSecondsAsync(2f);
        Debug.Log("任务2完成");
    }
    
    async Awaitable Task3Async()
    {
        await Awaitable.WaitForSecondsAsync(1.5f);
        Debug.Log("任务3完成");
    }
    
    async Awaitable<string> DownloadAsync(string url)
    {
        await Awaitable.WaitForSecondsAsync(1f);
        return $"数据来自 {url}";
    }
}

```