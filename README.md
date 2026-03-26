# 🔧 Mephia 自动续期 (多账号增强版)

本项目利用 GitHub Actions 实现自动化续期，支持 **多账号并行**、**环境隔离** 以及 **详细的 Discord 响应捕获**，确保你的 Mephia 服务永不到期。

## ✨ 功能亮点
- 👥 **多账号支持**：一个仓库即可管理无限个 Discord 账号，统一调度。
- 🛡️ **隔离环境**：账号间配置完全独立，单个账号失效不影响其他任务。
- 📢 **智能通知**：支持 Telegram 推送，包含账号备注、详细成功/失败原因及 Discord 原始响应。
- 🌐 **代理转发**：内置 GOST 代理模块，支持使用 SOCKS5/HTTP 代理规避 GitHub IP 封锁。

---

## 🚀 快速开始

### 1. Fork 本仓库
点击页面右上角的 **Fork** 按钮，将本项目克隆到你的个人 GitHub 账号下。

### 2. 获取账号凭据 (关键)
你需要为每个 Discord 账号获取 `Token` 和 `Session ID`：

1. 使用浏览器登录 [Discord 网页版](https://discord.com/app)。
2. 进入 Mephia 所在的服务器频道，手动执行一次 `/renew` 指令。
3. 按下 `F12` (或右键点击“检查”)，切换到 **Network (网络)** 标签页。
4. 在搜索框 (Filter) 输入 `interactions`。
5. 找到对应的请求，查看右侧面板：
   - **Headers (请求头)**：找到 `authorization`，这就是你的 **Token**。
   - **Payload (负载)**：找到 `session_id`，这就是你的 **Session ID**。

### 3. 设置 GitHub Secrets
进入你 Fork 后的仓库 -> **Settings** -> **Secrets and variables** -> **Actions** -> **New repository secret**。

#### 核心配置：`ACCOUNTS_JSON` (必填)
请将所有账号信息整理成以下 JSON 格式并填入：

```json
[
  {
    "name": "我的主账号",
    "token": "OTg3NjU0MzIxMDk4NzY1NDMy...",
    "session": "a1b2c3d4e5f6g7h8i9j0...",
    "tg_bot": "12345678,AAEEddeeff_gg" 
  },
  {
    "name": "备用小号",
    "token": "MTEyMjMzNDQ1NTY2Nzc4ODk5...",
    "session": "z0y9x8w7v6u5t4s3r2q1..."
  }
]

字段详解：
    name: 账号别名（用于通知时区分是谁）。
    token: 你的 Discord Authorization Token。
    session: 你的 Discord Session ID。
    tg_bot: (可选) 格式为 ChatID,BotToken。若不填，则默认使用全局 TG_BOT 配置。
其他配置 (可选)：
    Secret 名称,说明,格式示例
    GOST_PROXY,落地代理地址，若直连 403 请配置此项,socks5://user:pass@host:port
    TG_BOT,全局通知机器人（对未单独配置的账号生效）,"1234567,7890:ABC-DEF"

4. 启用与运行
    激活脚本：点击仓库上方的 Actions 选项卡，点击 “I understand my workflows, go ahead and enable them” 启用。
    手动触发：选择左侧的 Mephia 多账号续期 -> 点击 Run workflow。
    定时执行：默认每 5 天 UTC 02:00（北京时间 10:00）自动运行一次。
📊 通知效果预览
    成功时：
        🔔 Mephia 续期通知
        👤 账号: 我的主账号
        📊 结果: ✅ 续期成功
        📝 详情: 指令已成功送达 Discord
        ⏰ 时间: 2026-03-26 10:00:05

    失败时（含原因）：
        🔔 Mephia 续期通知
        👤 账号: 备用小号
        📊 结果: ❌ 续期失败
        📝 详情: 原因: 401: Unauthorized (Token 已失效或输入错误)
        ⏰ 时间: 2026-03-26 10:01:12
  
⚠️ 安全与风控说明
    隐私保护：GitHub Secrets 是加密存储的，切勿将 Token 直接硬编码在脚本中或发到 Issue。
    频率建议：Discord 对 Slash Command 有频率检测，本项目预设的 5 天执行间隔是经过测试的安全频率。
    免责声明：本工具仅供技术研究使用，请遵守 Discord 服务条款 及 Mephia 相关规定。开发者不承担因滥用导致的账号封禁风险。
建议： 在保存 ACCOUNTS_JSON 时，请务必检查 JSON 格式的合法性（例如双引号的使用以及括号的闭合），以免脚本解析失败。

🙏 致谢
特别感谢原项目 losy-mify/Mephia-Renew 提供的灵感与基础代码支持！

