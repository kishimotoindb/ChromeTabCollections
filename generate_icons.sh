#!/bin/bash

# 检查是否安装了inkscape或其他SVG转换工具
# 如果未安装，可以使用以下命令安装：
# brew install inkscape (在macOS上)
# apt-get install inkscape (在Ubuntu上)

# 创建不同尺寸的图标
if command -v inkscape &> /dev/null; then
    echo "使用Inkscape转换图标..."
    inkscape -w 16 -h 16 images/icon.svg -o images/icon16.png
    inkscape -w 48 -h 48 images/icon.svg -o images/icon48.png
    inkscape -w 128 -h 128 images/icon.svg -o images/icon128.png
    echo "图标已成功生成！"
else
    echo "未找到Inkscape。请安装Inkscape或使用其他工具将SVG转换为PNG格式。"
    echo "您可以使用在线转换工具，如 https://svgtopng.com/"
    echo "需要生成的图标尺寸：16x16, 48x48, 128x128"
fi 