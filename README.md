# env

这个仓库是我的个人环境配置仓库，主要用来存放：

- 常用 shell / editor / tmux 配置
- iTerm2 和 Rectangle 这类 macOS 工具的配置导出
- 一些小型辅助脚本
- 一套可复用的 `tmux-powerline + codex` 集成配置

它的目标不是做完整的系统初始化，而是把“我关心的环境行为”收敛到一个可版本管理、可迁移、可回放的地方。

## 目录结构

```text
.
├── .gitconfig
├── .gitignore
├── .tmux.conf
├── .vimrc
├── .zshrc
├── LICENSE
├── README.md
├── RectangleConfig.json
├── SUMMARY.md
├── ShuotianiTermConfig.json
├── bin/
├── codex/
├── iterm.json
├── misc/
└── tmux-powerline/
```

## 根目录文件

### `.gitconfig`

Git 的轻量级个人配置，主要是一些常用 alias。

当前内容包括：

- `br` -> `git branch`
- `ci` -> `git commit`
- `co` -> `git checkout`
- `dc` -> `git diff --cached`
- `pr` -> `git pull --rebase`
- `ru` -> `git remote update`
- `st` -> `git status`

另外还配置了：

- `credential.helper = store`

也就是说，这个文件主要承担“操作习惯”的作用，不是完整的 Git 全局配置。

### `.gitignore`

仓库级忽略规则。目前只忽略 `.DS_Store`。

### `.tmux.conf`

tmux 主配置文件。

它负责：

- 基础索引设置：窗口和 pane 从 `1` 开始
- 终端能力设置：`xterm-256color`
- 快捷键绑定：快速创建窗口、左右切换窗口
- 外观配置：状态栏、pane border、message style、window format
- 鼠标支持
- vi 风格 copy mode
- 加载本机 `~/Workspace` 里的两个 fork 插件：
  - `tmux-powerline`
  - `tmux-agent-indicator`

这个文件现在是“入口配置”，真正的 powerline 外观细节在 `tmux-powerline/` 目录下。

### `.vimrc`

Vim 的轻量配置。

主要包括：

- 开启语法高亮
- 使用 `darkblue` 颜色主题
- 自定义状态栏颜色
- 开启搜索高亮
- 使用较传统的 tab 配置：
  - `tabstop=8`
  - `shiftwidth=8`
  - `noexpandtab`
- 调整按键 wrap 和 timeout 行为

### `.zshrc`

zsh prompt 配置。

当前重点是一个带主机名、当前路径、git 信息的 prompt：

- 成功 / 失败状态用不同颜色箭头表示
- 显示 hostname
- 显示当前目录
- 显示 git prompt 信息

这是一个非常小的 `.zshrc`，目前只承担 prompt 定制，不是完整 shell 环境初始化。

### `LICENSE`

仓库许可证文件。

### `README.md`

当前文档。说明整个仓库的用途、结构，以及每个文件 / 目录分别是做什么的。

### `SUMMARY.md`

仓库摘要文档。它比 `README.md` 更短，更像一页速览。

如果想快速知道仓库里有什么，可以先看这个；如果想看完整说明，以 `README.md` 为准。

### `RectangleConfig.json`

macOS 窗口管理工具 Rectangle 的配置导出文件。

主要包含：

- 默认行为配置
- 窗口 snapping 相关设置
- 是否开机启动
- 是否隐藏菜单栏图标
- 一组快捷键绑定

从当前内容看，快捷键主要用于：

- 左半屏
- 右半屏
- 上半屏
- 下半屏
- 最大化
- 恢复窗口

### `iterm.json`

iTerm2 profile 配置导出文件。

它是一个比较完整的 terminal profile，包括：

- 字体
- ANSI 颜色
- 前景 / 背景色
- 键盘映射
- 滚动历史
- 鼠标行为
- 日志目录

这个文件更像“某一份默认 iTerm2 profile 的快照”。

### `ShuotianiTermConfig.json`

另一份 iTerm2 profile 导出。

和 `iterm.json` 很接近，属于另一份 profile 快照或历史版本备份。可以理解为：

- `iterm.json`：一份 iTerm2 配置导出
- `ShuotianiTermConfig.json`：另一份相近配置导出

如果以后整理仓库，可以考虑把两者的区别写清楚，或者合并掉不用的那一份。

## 目录说明

### `bin/`

放可执行辅助脚本。

#### `bin/tmux-codex.sh`

用于快速启动一个名为 `codex` 的 tmux session，并自动创建多个窗口运行 `codex --yolo`。

它负责：

- 检查 `tmux` 和 `codex` 是否已安装
- 如果 session 已存在，直接 attach / switch
- 如果 session 不存在，创建：
  - `codex-1`
  - `codex-2`
  - `codex-3`
- 每个窗口都在指定工作目录下启动 Codex

适合做多窗口并行 agent 工作流。

#### `bin/setup-powerline.sh`

这是当前 powerline 方案的安装 / 重放脚本。

它会做这些事：

- 检查本机是否存在两个 fork 插件目录：
  - `~/Workspace/tmux-powerline`
  - `~/Workspace/tmux-agent-indicator`
- 把仓库里的配置文件 symlink 到用户目录：
  - `~/.tmux.conf`
  - `~/.config/tmux-powerline/config.sh`
  - `~/.config/tmux-powerline/themes/stcheng.sh`
  - `~/.config/tmux-powerline/segments/agent_indicator.sh`
- 确保 `~/.codex/config.toml` 中有 `notify` 配置
- 重新加载 tmux

这意味着：

- 仓库负责保存“配置”
- `~/Workspace` 里的 fork 仓库负责保存“插件源码”

这是当前推荐的职责边界。

### `codex/`

放和 Codex CLI 集成有关的配置片段。

#### `codex/notify.toml`

这是一个很小的 TOML 片段，只包含：

- `notify = ["bash", ".../tmux-agent-indicator/adapters/codex-notify.sh"]`

它的作用是告诉 Codex CLI 在事件发生时通知 `tmux-agent-indicator`，从而让 tmux 中的 agent 状态可以被显示出来。

注意：

- 这个文件本身不会自动生效
- 真正把它写入 `~/.codex/config.toml` 的，是 `bin/setup-powerline.sh`

因此它更像“配置来源”或“配置模板”，不是直接被程序读取的最终文件。

### `misc/`

放一些零散的小工具，不属于主环境配置链路。

#### `misc/calculate_mean.py`

一个简单的 Python 脚本，读取格式为 `key,value` 的 CSV 文件，然后按 key 聚合并计算均值。

输入示例：

```csv
a,1
a,3
b,2
```

输出示例：

```text
a,2.0
b,2.0
```

这是一个独立小工具，和 tmux / iTerm / Codex 配置没有关系。

### `tmux-powerline/`

放本仓库自己的 `tmux-powerline` 用户层配置，而不是插件源码本身。

插件源码在：

- `~/Workspace/tmux-powerline`

这个目录保存的是“覆盖层”和“自定义层”。

#### `tmux-powerline/config.sh`

tmux-powerline 的主用户配置。

目前负责：

- 开启 patched font / Nerd Font glyph
- 指定自定义主题名为 `stcheng`
- 指定用户 themes 和 segments 的目录
- 设置状态栏刷新间隔
- 设置左右状态栏长度
- 设置 git branch 图标颜色

这个文件是 powerline 行为层面的总开关。

#### `tmux-powerline/themes/stcheng.sh`

自定义主题文件。

主要定义：

- separator glyph
- 默认前景 / 背景色
- window status 样式
- 左右状态栏 segment 排列
- 当前使用的蓝色渐变配色

当前左侧大致是：

- session info：深蓝
- hostname：中蓝
- git branch：浅蓝

右侧则是更深、更克制的蓝色系，文字统一为白色。

#### `tmux-powerline/segments/agent_indicator.sh`

自定义 powerline segment。

它会调用：

- `~/Workspace/tmux-agent-indicator/scripts/indicator.sh`

然后把返回结果嵌入 tmux-powerline 右侧状态栏。

作用是把 Codex / agent 状态整合进 powerline，而不是只显示普通时间、路径之类的信息。

## 现在这套 tmux / Codex / powerline 是怎么工作的

当前链路大致如下：

1. `~/.tmux.conf` 加载本机 fork 的 `tmux-powerline` 和 `tmux-agent-indicator`
2. `tmux-powerline` 从 `~/.config/tmux-powerline/` 读取用户配置
3. 这些用户配置实际是 symlink 到本仓库里的文件
4. `agent_indicator.sh` 这个自定义 segment 会调用 `tmux-agent-indicator`
5. Codex CLI 通过 `notify` 把事件发给 `tmux-agent-indicator`
6. `tmux-agent-indicator` 再把状态显示到 tmux 里

也就是说：

- 插件源码在 `~/Workspace`
- 配置源码在这个仓库
- `setup-powerline.sh` 负责把两者接起来

## 推荐使用方式

如果迁移到新机器，或者想重新应用这套配置，先准备好两个 fork：

- `~/Workspace/tmux-powerline`
- `~/Workspace/tmux-agent-indicator`

然后执行：

```bash
~/Workspace/env/bin/setup-powerline.sh
```

它会把当前仓库里的 powerline 配置重新链接到 `$HOME` 下，并刷新 tmux。

## 后续可以继续整理的点

- 给 `iterm.json` 和 `ShuotianiTermConfig.json` 标注清楚差异
- 给 `bin/tmux-codex.sh` 增加参数说明
- 把 `codex/notify.toml` 和 `setup-powerline.sh` 的关系写成更明确的安装流程
- 如果以后还有更多 tmux 自定义，可以继续放进 `tmux-powerline/` 或新增 `tmux/` 目录
