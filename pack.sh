#!/bin/bash

# 设置颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
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
    
    # 检查是否提供了GITHUB_TOKEN环境变量（用于创建Release）
    if [ -n "$GITHUB_TOKEN" ]; then
        # 获取仓库信息
        REPO_URL=$(git config --get remote.origin.url)
        REPO_NAME=$(echo $REPO_URL | sed -E 's/.*github.com[:\/](.*)(\.git)?/\1/')
        
        echo "准备在GitHub上创建Release: v${VERSION}..."
        
        # 检查Release是否已存在
        RELEASE_EXISTS=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
            "https://api.github.com/repos/$REPO_NAME/releases/tags/v${VERSION}" | grep -c "\"id\":")
        
        if [ "$RELEASE_EXISTS" -gt 0 ]; then
            echo -e "${YELLOW}Release v${VERSION}已存在，将覆盖...${NC}"
            
            # 获取Release ID
            RELEASE_ID=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
                "https://api.github.com/repos/$REPO_NAME/releases/tags/v${VERSION}" | grep -m 1 "\"id\":" | cut -d':' -f2 | cut -d',' -f1 | tr -d ' ')
            
            # 删除现有Release
            curl -s -X DELETE -H "Authorization: token $GITHUB_TOKEN" \
                "https://api.github.com/repos/$REPO_NAME/releases/$RELEASE_ID"
        fi
        
        # 创建新的Release
        RELEASE_RESPONSE=$(curl -s -X POST -H "Authorization: token $GITHUB_TOKEN" \
            -H "Content-Type: application/json" \
            -d "{\"tag_name\":\"v${VERSION}\",\"name\":\"Chrome Tab Collections v${VERSION}\",\"body\":\"自动发布版本 v${VERSION}\",\"draft\":false,\"prerelease\":false}" \
            "https://api.github.com/repos/$REPO_NAME/releases")
        
        # 提取Release ID
        RELEASE_ID=$(echo $RELEASE_RESPONSE | grep -o '\"id\": [0-9]*,' | head -n 1 | grep -o '[0-9]*')
        
        if [ -n "$RELEASE_ID" ] && [ "$RELEASE_ID" != "null" ]; then
            echo "Release创建成功，ID: $RELEASE_ID"
            
            # 上传资产文件
            UPLOAD_URL="https://uploads.github.com/repos/$REPO_NAME/releases/$RELEASE_ID/assets?name=${FILENAME}"
            
            curl -s --data-binary @"releases/$FILENAME" \
                -H "Authorization: token $GITHUB_TOKEN" \
                -H "Content-Type: application/zip" \
                "$UPLOAD_URL" > /dev/null
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}发布包已上传到GitHub Release!${NC}"
                echo -e "Release地址: ${GREEN}https://github.com/$REPO_NAME/releases/tag/v${VERSION}${NC}"
            else
                echo -e "${RED}上传发布包到GitHub Release失败!${NC}"
            fi
        else
            echo -e "${RED}创建GitHub Release失败!${NC}"
            echo $RELEASE_RESPONSE
        fi
    else
        echo -e "${YELLOW}未设置GITHUB_TOKEN环境变量，跳过创建GitHub Release${NC}"
        echo "如需自动创建Release，请设置GITHUB_TOKEN环境变量："
        echo "export GITHUB_TOKEN=your_github_personal_access_token"
    fi
else
    echo -e "${RED}打包失败!${NC} 请检查错误信息"
    exit 1
fi 