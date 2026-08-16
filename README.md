# DeepSeek Harness 桌面启动器

Windows 桌面上的 DeepSeek Harness 一键启动器：**双击图标即可打开使用**，无需每次打开终端输入命令。

## 快速开始（下载后怎么打开）

1. **解压** zip 到任意固定位置（如 `D:\DeepSeek-Harness`，不要放临时目录）
2. **安装 Node.js**（如电脑还没有）：到 https://nodejs.org 下载 LTS 版，一路默认安装即可。
   若 Node 装在非默认路径，用记事本打开 `run-server.cmd`，修改第 2 行的 `NODE` 路径
3. **双击 `DeepSeek Harness.cmd`**：
   - 首次启动会自动联网下载安装 DeepSeek Harness 本体（需几分钟，之后就是秒开）
   - 启动完成后自动打开界面（Chrome 独立窗口，无地址栏）
4. 建议右键 `DeepSeek Harness.cmd` → 发送到 → 桌面快捷方式，以后双击快捷方式即可

停止服务：双击 `停止 DeepSeek Harness.cmd`，或直接关闭任务栏里最小化的「DeepSeek Harness Server」窗口。

> ⚠️ **需要一个 AI 模型 API Key**：界面能打开，但要真正对话，需要在界面设置里
> 填入你自己的 API Key（例如 DeepSeek 开放平台的 key）。Key 是个人账号的，无法共用。

## 功能

- 🐳 双击桌面「启动 DeepSeek Harness」图标即可使用
- 🔍 自动检测服务是否已运行（`http://127.0.0.1:3080`），已运行则直接打开界面
- ⚙️ 未运行时自动在后台（最小化窗口）启动服务，并等待就绪（最长 90 秒）
- 🖥️ 默认用 Chrome / Edge **独立应用窗口**打开（无地址栏，像桌面应用）；可切换为默认浏览器标签页
- 🛑 一键停止服务（只结束 3080 端口上确认为 dsh 的进程，不误杀其他程序）
- ♻️ CLI 文件丢失时自动用 `npx --yes @deepseek-ai/dsh` 重新安装（自愈）
- 📄 服务日志写入 `%USERPROFILE%\.dsh\server.log`
- 🎨 图标为 DeepSeek 官方鲸鱼 logo（提取自 DSH 前端 favicon.svg，商标归 DeepSeek 所有）

## 文件说明

| 文件 | 作用 |
| --- | --- |
| `DeepSeek Harness.cmd` | 启动器主逻辑（双击入口） |
| `run-server.cmd` | 后台启动服务并写日志 |
| `停止 DeepSeek Harness.cmd` + `stop.ps1` | 停止服务 |
| `whale-256.svg` | 鲸鱼图标 SVG 源文件 |
| `make-icon.ps1` | 重新生成 `icon.ico`（可改颜色） |
| `使用说明.txt` | 本地使用说明 |

## 桌面快捷方式（可选）

右键 `DeepSeek Harness.cmd` → 发送到 → 桌面快捷方式；想要鲸鱼图标的话，
右键快捷方式 → 属性 → 更改图标，指向文件夹里的 `icon.ico`。

### 配置项（`DeepSeek Harness.cmd` 顶部）

- `URL`：界面地址，默认 `http://127.0.0.1:3080`
- `APP_MODE`：`1` = 独立应用窗口（Chrome/Edge）；`0` = 默认浏览器标签页

## 许可

代码可自由使用。鲸鱼 logo 版权归 DeepSeek 所有，仅用于个人工具。
