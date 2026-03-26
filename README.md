-----

# 🔧 Mephia 自动续期 (多账号增强版)

[](https://www.google.com/search?q=https://github.com/your-username/your-repo/blob/main/LICENSE)
[](https://www.google.com/search?q=https://github.com/your-username/your-repo/stargazers)
[](https://www.google.com/search?q=https://github.com/your-username/your-repo/actions)

本项目基于 GitHub Actions 实现自动化续期，专为 **Mephia** 服务设计。支持多账号并行、环境隔离及详细的响应捕获，确保你的服务永不到期。

## ✨ 功能亮点

  * 👥 **多账号支持**：一个仓库管理无限个账号，矩阵式自动化。
  * 🛡️ **隔离环境**：账号间配置完全独立，互不干扰，安全可靠。
  * 📢 **智能通知**：支持 Telegram 推送，包含账号备注及 Discord 原始响应。
  * 🌐 **代理转发**：内置 GOST 模块，支持 SOCKS5/HTTP 代理，规避 GitHub IP 封锁。

-----

## 🚀 快速开始

### 第一步：Fork 本仓库

点击页面右上角的 **Fork** 按钮，将本项目克隆到你的个人账号下。

### 第二步：获取 Discord 凭据 (关键)

1.  登录 [Discord 网页版](https://discord.com/app)。
2.  在 Mephia 频道手动执行一次 `/renew` 指令。
3.  按下 `F12` 打开开发者工具，切换到 **Network (网络)** 标签页。
4.  搜索 `interactions`，在请求中获取：
      * **Headers**: 找到 `authorization` (这就是 **Token**)。
      * **Payload**: 找到 `session_id` (这就是 **Session ID**)。

### 第三步：配置 GitHub Secrets

前往：`Settings` -\> `Secrets and variables` -\> `Actions` -\> `New repository secret`。

#### 1\. 核心配置：`ACCOUNTS_JSON` (必填)

请按以下格式填入账号信息：

```json
[
  {
    "name": "主账号",
    "token": "OTg3...此处省略...",
    "session": "a1b2...此处省略...",
    "tg_bot": "1234567,AAEEddeeff" 
  },
  {
    "name": "备用号",
    "token": "MTEy...此处省略...",
    "session": "z0y9...此处省略..."
  }
]
```

#### 2\. 其他可选配置

| Secret 名称 | 说明 | 格式示例 |
| :--- | :--- | :--- |
| `GOST_PROXY` | 落地代理地址 (解决 403 封锁) | `socks5://user:pass@host:port` |
| `TG_BOT` | 全局通知机器人 (ChatID,Token) | `1234567,7890:ABC-DEF` |

-----

## 📊 通知预览

> [\!TIP]
> 建议开启 Telegram 通知，以便第一时间掌握续期状态。

| 状态 | 预览示例 |
| :--- | :--- |
| **✅ 成功** | `👤 账号: 主账号` <br> `📊 结果: 续期成功` <br> `📝 详情: 指令已送达` |
| **❌ 失败** | `👤 账号: 备用号` <br> `📊 结果: 续期失败` <br> `📝 详情: 401 Unauthorized` |

-----

## ⚠️ 安全与风控

1.  **隐私保护**：Secrets 是加密的，**切勿**将 Token 直接写在代码中。
2.  **执行频率**：预设为每 5 天运行一次。Discord 对 Slash Command 有频率限制，请勿频繁手动触发。
3.  **免责声明**：本工具仅供技术研究，请遵守 Discord 服务条款。开发者不承担账号封禁风险。

-----

## 🙏 致谢

  * 感谢 [losy-mify/Mephia-Renew](https://www.google.com/search?q=https://github.com/losy-mify/Mephia-Renew) 提供的灵感与基础支持。

-----
