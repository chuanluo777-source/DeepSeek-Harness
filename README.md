# DeepSeek Harness 桌面启动器

Windows 桌面上的 DeepSeek Harness 一键启动器：**双击图标即可打开使用**，无需每次打开终端输入命令。

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

## 使用方法

1. 把整个文件夹放到任意位置（建议保持文件夹名不变）
2. 给 `DeepSeek Harness.cmd` 创建快捷方式到桌面，图标指向文件夹里的 `icon.ico`
   （或直接双击 `DeepSeek Harness.cmd` 使用）
3. 首次启动需已安装 Node.js（`C:\Program Files\nodejs`）和 DeepSeek Harness

### 配置项（`DeepSeek Harness.cmd` 顶部）

- `URL`：界面地址，默认 `http://127.0.0.1:3080`
- `APP_MODE`：`1` = 独立应用窗口（Chrome/Edge）；`0` = 默认浏览器标签页

## 许可

代码可自由使用。鲸鱼 logo 版权归 DeepSeek 所有，仅用于个人工具。
