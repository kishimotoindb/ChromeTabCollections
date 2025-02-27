# 开发指南

## 自动打包机制

本项目配置了自动打包机制，每当您提交代码变更时，系统会自动重新打包扩展并更新发布文件。这确保了GitHub上的发布包始终与最新代码同步。

### 工作原理

1. 当您运行 `git commit` 命令时，Git的pre-commit钩子会自动触发
2. 如果检测到代码文件（js/html/css/json/png）有变更，会自动运行打包脚本
3. 打包脚本会从manifest.json中提取版本号，创建相应的ZIP包
4. 脚本还会自动更新README.md中的下载链接，指向最新版本
5. 最后，打包文件和README更新会被自动添加到您的提交中
6. 如果配置了GitHub Token，脚本会自动创建GitHub Release并上传ZIP包

### 配置GitHub Token（自动创建Release）

为了使脚本能够自动创建GitHub Release，您需要设置一个GitHub Personal Access Token（PAT）：

1. 访问 https://github.com/settings/tokens
2. 点击 "Generate new token" > "Generate new token (classic)"
3. 输入描述（例如："Chrome Tab Collections自动发布"）
4. 至少选择以下权限：
   - `repo` - 完整的仓库访问权限（用于创建Release）
5. 点击 "Generate token" 并复制生成的token
6. 将token添加到您的环境变量：

```bash
# 临时设置（当前会话有效）
export GITHUB_TOKEN=your_token_here

# 或永久设置（添加到~/.bashrc或~/.zshrc）
echo 'export GITHUB_TOKEN=your_token_here' >> ~/.zshrc
source ~/.zshrc
```

设置好Token后，每次打包时都会自动创建或更新对应版本的GitHub Release。

### 手动打包

如果需要手动打包扩展，可以直接运行：

```bash
./pack.sh
```

如果您已经配置了GITHUB_TOKEN，脚本会同时创建GitHub Release。

### 跳过自动打包

如果您希望跳过自动打包（例如，进行一些不影响代码的小修改），可以使用：

```bash
git commit --no-verify -m "您的提交信息"
```

### 更新版本号

当您需要发布新版本时，只需要更新 `manifest.json` 文件中的 `version` 字段，然后正常提交。打包脚本会自动使用新版本号创建发布包和GitHub Release。

## 发布新版本

完整的发布流程：

1. 更新 `manifest.json` 中的版本号
2. 提交您的更改（这会自动触发打包和Release创建）：`git commit -m "发布版本 X.X"`
3. 推送到GitHub：`git push`

如果您已经配置了GITHUB_TOKEN，不需要再手动创建Release，脚本已经完成了这一步骤。

## 文件结构

- `pack.sh` - 打包脚本
- `.git/hooks/pre-commit` - Git提交前钩子
- `releases/` - 存放打包后的文件

## 注意事项

- 自动打包只在有代码文件变更时触发
- 确保您的manifest.json文件中的版本号始终是最新的
- 如果您在多台机器上开发，需要在每台机器上设置钩子和GITHUB_TOKEN
- 请保管好您的GitHub Token，不要将其直接提交到代码仓库中
- 如果没有设置GITHUB_TOKEN，脚本只会创建ZIP包，不会创建GitHub Release 