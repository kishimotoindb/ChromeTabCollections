#!/bin/bash

# 设置颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}开始打包 Chrome Tab Collections 扩展...${NC}"

# 创建releases目录（如果不存在）
mkdir -p releases

# 版本号从manifest.json中提取
VERSION=$(grep '"version"' manifest.json | cut -d '"' -f 4)
FILENAME="chrome-tab-collections-v${VERSION}.zip"

echo -e "打包版本: ${GREEN}v${VERSION}${NC}"

# 删除旧的ZIP文件（如果存在）
if [ -f "releases/$FILENAME" ]; then
    echo "删除旧的发布包..."
    rm "releases/$FILENAME"
fi

# 打包扩展
echo "创建新的发布包..."
zip -r "releases/$FILENAME" \
    manifest.json \
    background.js \
    popup.html \
    popup.js \
    popup.css \
    images/icon16.png \
    images/icon48.png \
    images/icon128.png \
    README.md \
    LICENSE

# 检查是否成功
if [ $? -eq 0 ]; then
    echo -e "${GREEN}打包成功!${NC} 发布包已创建: releases/$FILENAME"
    
    # 更新README中的下载链接（如果需要）
    sed -i '' "s|/releases/download/v[0-9][^/]*/chrome-tab-collections-v[0-9][^)]*|/releases/download/v${VERSION}/${FILENAME}|g" README.md
    echo "README中的下载链接已更新"
    
    # 将ZIP文件添加到git（强制覆盖.gitignore）
    git add -f "releases/$FILENAME" README.md
    echo "发布包已添加到Git暂存区"
else
    echo -e "\033[0;31m打包失败!${NC} 请检查错误信息"
    exit 1
fi 