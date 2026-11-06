# VSCode → IntelliJ IDEA 风格配置

一套把 VSCode 调成接近 IntelliJ IDEA 手感的配置：主题、图标、键位、语法配色、编辑器行为与项目视图全部对齐。

配置来源为本机 VSCode，2026-10-29 ~ 10-31 分 6 批调整完成，共 101 个顶层设置项。

## 效果概览

并不是装一个「IDEA 模式」插件就能搞定，而是四层叠加：

| 层 | 落地位置 | 做了什么 |
| --- | --- | --- |
| 扩展 | VSCode 扩展 | 主题、图标、IDEA 键位包、Java 语言服务 |
| 配色 | `settings.json` | 主题 + 主题作用域覆写 + 语义/TextMate 双轨语法着色 |
| 行为 | `settings.json` | 约 90 项补全、缩进、Tab 页、项目树、字体与滚动设置 |
| 键位 | `keybindings.json` | 5 条手工补丁，修正键位扩展的行为 |

## 文件说明

| 文件 | 说明 |
| --- | --- |
| `settings.json` | 主配置，复制到 VSCode 用户配置目录 |
| `keybindings.json` | 键位补丁，复制到同一目录 |
| `extensions.txt` | 需要安装的扩展 ID，一行一个 |
| `publish.bat` | Windows 下配置 remote 并推送的辅助脚本（仅维护者用） |

用户配置目录：

- Windows：`%APPDATA%\Code\User\`
- macOS：`~/Library/Application Support/Code/User/`
- Linux：`~/.config/Code/User/`

## 快速开始

### 1. 安装扩展

```powershell
# Windows PowerShell
Get-Content extensions.txt | ForEach-Object { code --install-extension $_ }
```

```bash
# macOS / Linux
xargs -n1 code --install-extension < extensions.txt
```

如果 `code` 不在 PATH，Windows 下可改用 VSCode 安装目录里的 `bin\code.cmd`。

### 2. 复制配置

把 `settings.json` 和 `keybindings.json` 复制到上面列出的用户配置目录，覆盖前建议先备份原文件。

### 3. 安装字体

编辑器、终端、调试控制台、Markdown 预览统一使用 **JetBrains Mono**。未安装时会回退到 Consolas。

### 4. 修改占位符

`settings.json` 中唯一的本机相关项已脱敏：

```json
"python.defaultInterpreterPath": "<YOUR_PYTHON_INTERPRETER>"
```

改成本机 Python 解释器路径，用不到 Python 也可以直接删掉这一行。

## 扩展清单

| 扩展 ID | 作用 | 必需 |
| --- | --- | --- |
| `anandabibekray.intellij-idea-new-ui-theme` | 当前启用的 `IntelliJ IDEA New UI` 主题 | 是 |
| `chadalen.vscode-jetbrains-icon-theme` | JetBrains 2023+ 文件图标 | 是 |
| `k--kato.intellij-idea-keybindings` | 注入 220 条 IDEA 键位映射 | 是 |
| `redhat.java` | Java 语言服务（JDT LS），语义着色依赖它 | Java 开发时必需 |
| `vscjava.vscode-java-pack` | Java 调试、依赖视图、Maven 集成 | 可选 |
| `vscjava.vscode-maven` / `vscjava.vscode-spring-initializr` | Maven、Spring 项目支持 | 可选 |
| `madhavd1.javadoc-tools` | Javadoc 生成 | 可选 |
| `monishkumarv.jetbrains-commit-manager` | JetBrains 风格提交管理 | 可选 |
| `alexti.intellij-idea-light-theme` / `qvist.jetbrains-new-ui-dark-theme` | 备用亮色 / 暗色主题，未启用 | 可选 |

## 实现细节

### 配色：三层覆写

| 层级 | 设置项 | 值 |
| --- | --- | --- |
| 基底主题 | `workbench.colorTheme` | `IntelliJ IDEA New UI` |
| 文件图标 | `workbench.iconTheme` | `vscode-jetbrains-icon-theme-2023-light` |
| UI 覆写 | `workbench.colorCustomizations` | 标题栏色 + `[IntelliJ IDEA New UI]` 作用域内的编辑器色 |
| 语法色 A | `editor.semanticTokenColors` | 27 类语义 token |
| 语法色 B | `editor.tokenColorCustomizations.textMateRules` | 10 组 TextMate scope |

**为什么语法色要写两套**：Java 走语言服务器的语义 token，其他语言走 TextMate scope。只配一套会出现「Java 变色、Vue/JS 不变色」。

UI 关键色：选中 `#A6D2FF`、当前行 `#F7F8FA`、行号 `#A8ADBD`、缩进线 `#EBECF0`。

语法色取自 IDEA Classic Light 默认色板：

```text
关键字 / 修饰符  #0033B3     字符串        #067D17
数字             #1750EB     注释(斜体)    #8C8C8C
函数 / 方法      #00627A     属性 / 字段   #871094
注解 / 装饰器    #9E880D     类 / 接口     #000000
```

### 行为对齐：代表性设置

| 设置 | 值 | 效果 |
| --- | --- | --- |
| `window.commandCenter` / `window.menuBarVisibility` | `false` / `visible` | 关掉命令中心，恢复传统菜单栏 |
| `window.titleBarStyle` | `custom` | 自定义标题栏配色 |
| `editor.minimap.enabled` | `false` | 去掉缩略图 |
| `workbench.editor.enablePreview` | `false` | 单击文件不再开斜体预览 Tab |
| `editor.detectIndents` + `editor.tabSize` | `false` + `4` | 强制 4 空格，不跟随文件探测 |
| `editor.suggest.preview` | `false` | 补全不自动插入 |
| `editor.acceptSuggestionOnCommitCharacter` | `false` | 输入标点不误接受补全 |
| `editor.acceptSuggestionOnEnter` | `on` | 回车或 Tab 接受 |
| `editor.inlayHints.enabled` | `on` | 参数名内联提示 |
| `workbench.editor.wrapTabs` + `highlightModifiedTabs` | `true` / `true` | 多行 Tab、修改过的 Tab 高亮 |
| `explorer.compactFolders` | `false` | 项目树不压缩中间目录 |
| `files.exclude` | 隐藏 `.idea` `target` `node_modules` 等 | 项目视图不显示构建产物 |
| `breadcrumbs.enabled` | `true` | 面包屑导航 |
| `editor.mouseWheelScrollSensitivity` 等 3 处 | `2.16` | 编辑器 / 列表 / 终端滚动速度统一 |

### 键位

`k--kato.intellij-idea-keybindings` 注入 220 条映射，常用的有：

```text
Ctrl+B          跳到声明        Ctrl+Alt+B      跳到实现
Ctrl+Alt+O      优化导入        Alt+Enter       快速修复
Ctrl+Q          快速文档        Ctrl+P          参数提示
Shift+F6        重命名          Ctrl+E          最近文件
Ctrl+Shift+F    全局搜索        Ctrl+Shift+A    查找操作
Ctrl+N          查找符号        Ctrl+/          行注释
```

`keybindings.json` 里的 5 条是手工补丁：

- `F2` 绑回 `editor.action.rename`
- `Ctrl+Tab` / `Ctrl+Shift+Tab` 绑到「最近文件」列表导航
- `Ctrl+Alt+E` / `Ctrl+Alt+F12` 同样用于最近文件列表前后切换

> **已知冲突**：键位扩展把 `F2` 定义为「跳到下一个错误」（`-editor.action.rename` + `editor.action.marker.next`），这是 IDEA 的原生行为。本配置的用户键位优先级更高，把 `F2` 覆盖成了重命名。想要纯 IDEA 手感，删掉 `keybindings.json` 的第一条即可。

## 已知取舍

- 装了 3 个 IDEA 系主题，实际只启用 `IntelliJ IDEA New UI`，另外两个是备用亮色 / 暗色。
- `editor.wordBasedSuggestions: "off"` 已关闭单词补全来源，`editor.suggest.showWords: true` 基本不生效，属于冗余项。
- `editor.formatOnSave` 保持 `false`，与 IDEA 默认行为一致；需要保存时格式化请自行打开。
- `workbench.editorAssociations` 把 `*.md` 默认以预览方式打开，不适合写 Markdown 时可删掉。

## 复刻到新机器

```bash
git clone https://github.com/<YOUR_GITHUB_USERNAME>/vscode-idea-setup.git
```

按「快速开始」四步操作即可。配置不依赖任何插件私有的二进制文件，只依赖扩展市场里的公开扩展和 JetBrains Mono 字体。

## 许可

本仓库暂未附带 LICENSE，如需开源授权请自行添加。
