# Chrome Tab Collections (标签页收藏管理器)

<div align="center">
  <img src="images/icon128.png" alt="Chrome Tab Collections Logo" width="128" height="128">
  <p><i>Chrome Tab Collections: 保存、分类和恢复您的标签页集合</i></p>
</div>

## 简介

Chrome Tab Collections 是一个轻量级的Chrome扩展，帮助您管理浏览器标签页。它可以一键保存当前浏览器窗口中打开的所有标签页，并能够随时恢复这些标签页集合，提高您的工作效率和浏览体验。

正如我们的图标所展示的：打开多个标签页（顶部彩色标签）、保存它们（红色下载按钮）并在需要时恢复（底部的标签页集合）。这正是本扩展的核心功能 - 简单而强大的标签页集合管理。

无论您是在进行研究、学习还是工作，经常需要同时打开多个相关网页。使用本扩展，您可以轻松保存这些"工作环境"，下次需要时一键恢复，避免了手动重新打开每个网站的繁琐过程。

## ✨ 功能特点

- 🔄 **一键保存**：快速保存当前窗口中的所有标签页
- 📝 **自定义命名**：为每个标签页集合添加个性化名称
- 📂 **便捷管理**：查看、恢复和删除已保存的标签页集合
- 🚀 **即时恢复**：在当前浏览器窗口中打开已保存的标签页
- 🔒 **隐私保护**：所有数据仅保存在本地，不会上传到云端

## 📥 安装指南

### 方法一：从Chrome网上应用店安装（尚未上架）

1. 访问Chrome网上应用店（链接待添加）
2. 点击"添加至Chrome"

### 方法二：开发者模式安装

1. 下载或克隆本仓库到您的电脑：
   ```
   git clone https://github.com/kishimotoindb/ChromeTabCollections.git
   ```
   或直接[下载ZIP压缩包](https://github.com/kishimotoindb/ChromeTabCollections/archive/refs/heads/main.zip)并解压

2. 生成图标文件:
   - 如果您有Inkscape: 运行 `./generate_icons.sh`
   - 或者手动将 `images/icon.svg` 转换为尺寸为16×16、48×48和128×128的PNG图像，分别命名为`icon16.png`、`icon48.png`和`icon128.png`

3. 在Chrome浏览器地址栏输入：`chrome://extensions/`

4. 打开右上角的"开发者模式"开关

5. 点击左上角的"加载已解压的扩展程序"按钮

6. 选择包含此扩展程序的文件夹

## 🎮 使用指南

### 保存标签页集合

1. 在浏览器中打开您想要保存的标签页
2. 点击Chrome工具栏中的扩展图标
3. 在弹出窗口中，您可以为集合输入一个名称（可选）
4. 点击"保存当前标签页集合"按钮
5. 完成！您的标签页集合已保存

### 恢复标签页集合

1. 点击扩展图标
2. 在已保存的集合列表中找到您想要恢复的集合
3. 点击该集合旁边的"📂"图标
4. 所有保存的标签页将在当前浏览器窗口中打开

### 删除标签页集合

1. 点击扩展图标
2. 在列表中找到您想删除的集合
3. 点击该集合旁边的"🗑️"图标
4. 集合将被永久删除

## 🔧 技术实现

Chrome Tab Collections 使用以下技术实现：

- **JavaScript**: 核心功能实现
- **Chrome Extensions API**: 与浏览器进行交互
- **HTML/CSS**: 用户界面设计
- **Chrome Storage API**: 本地数据存储

## 🚀 未来计划

- [ ] 添加标签页集合分类功能
- [ ] 支持标签页集合的导入/导出
- [ ] 添加快捷键支持
- [ ] 支持云同步（可选）
- [ ] 多语言支持

## ⚠️ 注意事项

- 标签页集合保存在浏览器的本地存储中，清除浏览器数据可能会导致保存的集合丢失
- 该扩展需要"标签"和"存储"权限才能正常工作
- 如果您在使用过程中遇到任何问题，请提交Issue

## 📜 许可证

本项目采用 [MIT 许可证](LICENSE)

## 🤝 贡献

欢迎贡献代码、报告问题或提出新功能建议！请随时[提交Issue](https://github.com/kishimotoindb/ChromeTabCollections/issues)或[Pull Request](https://github.com/kishimotoindb/ChromeTabCollections/pulls)。

## 📞 联系方式

如有任何问题或建议，请通过以下方式联系我：

- GitHub: [kishimotoindb](https://github.com/kishimotoindb)
- 电子邮件: 您的邮箱地址

---

<div align="center">
  <i>如果您喜欢这个扩展，请考虑给它点赞⭐️</i>
</div> 