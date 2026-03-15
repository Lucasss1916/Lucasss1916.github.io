#!/bin/bash

echo "开始更新文章的 lastmod 字段..."

# 查找所有 Markdown 文件
find content -name "*.md" -type f | while read -r file; do
    # 获取文件的最后 Git 提交时间
    last_commit_time=$(git log -1 --format="%cI" -- "$file" 2>/dev/null)
    
    if [ -n "$last_commit_time" ]; then
        # 检查文件是否有 lastmod 字段
        if grep -q "^lastmod:" "$file"; then
            # 更新现有的 lastmod
            sed -i.bak -E "s/^(lastmod: *['\"]?)[^'\"]*(['\"]?)/\1$last_commit_time\2/" "$file"
            echo "🔄 更新: $file → $last_commit_time"
        else
            # 在 date 字段后添加 lastmod
            sed -i.bak -E "s/^(date: *['\"]?[^'\"]*['\"]?)/\1\nlastmod: '$last_commit_time'/" "$file"
            echo "➕ 添加: $file → $last_commit_time"
        fi
        rm -f "$file.bak"
    else
        echo "⏭️  跳过: $file (无 Git 历史)"
    fi
done

echo "✅ 更新完成！"
