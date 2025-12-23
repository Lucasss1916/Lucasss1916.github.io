---
title: 部署blog
date: 2025-08-31T17:04:19+08:00
lastmod: 2025-08-31T17:04:19+08:00
author: lucas
cover: /images/logo.PNG
categories:
  - blog
---
# 1. 1.下载安装hugo
1.在macos上安装hugo      
```
brew install hugo
```

2.查看是否安装完成   
```
hugo version
```

3.如果正确输出.   
```
比如v0.133.1+extended darwin/amd64
```  
则表示安装成功.  
# 2. 2.创建blog
```
hugo new site hugo-blog  
cd hugo-blog
```  
创建主题 
```
git init 
git submoudle add 
	https://github.com/adityatelange/hugo-PaperMod.git
themes/PaperMod   
```  
修改配置hugo.toml   
```baseURL = "https://yourname.github.io/"   
languageCode = "en-us"`  
title = "My Hugo Blog"   
theme = "PaperMod"
```   
新建一篇文章
```
hugo new posts/hello-world.md
```  
本地预览,可通过1313端口访问
```
hugo server -D
``` 
