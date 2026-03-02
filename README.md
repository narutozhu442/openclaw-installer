# OpenClaw 一键安装器 🦕

> 5分钟部署 OpenClaw AI 助手，零配置，多免费模型可选

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS%20%7C%20Windows-blue.svg)]()

## 🚀 一键安装

### Linux / macOS / WSL

```bash
curl -fsSL https://raw.githubusercontent.com/narutozhu442/openclaw-installer/main/scripts/install-openclaw.sh | bash
```

### Windows (PowerShell)

```powershell
iwr -useb https://raw.githubusercontent.com/narutozhu442/openclaw-installer/main/scripts/install-openclaw.ps1 | iex
```

## ✨ 特性

- ✅ **一键安装** - 自动检测环境，自动安装依赖
- ✅ **多模型支持** - 5种免费模型提供商可选
- ✅ **智能配置** - 交互式选择，自动写入配置
- ✅ **国内优化** - 适配国内网络环境
- ✅ **零代码基础** - 复制粘贴即可使用

## 🎯 支持的免费模型

| 提供商 | 模型 | 免费额度 | 难度 |
|--------|------|----------|------|
| **GitHub Models** | GPT-4o-mini, DeepSeek | 个人开发者免费 | ⭐ 最简单 |
| **硅基流动** | DeepSeek, Qwen | 14元体验金+每日免费 | ⭐ 简单 |
| **Coze** | Kimi K2.5, GLM |  generous 额度 | ⭐⭐ 中等 |
| **联通云** | 5款大模型 | 新用户充足额度 | ⭐⭐⭐ 需认证 |

## 📋 安装步骤

1. **运行安装命令**（上面的一键安装）
2. **选择模型提供商**（交互式菜单）
3. **获取 API Key**（按提示访问对应网站）
4. **填入配置文件**
5. **启动使用**

```bash
# 启动 OpenClaw
openclaw gateway start

# 浏览器访问
http://127.0.0.1:18789
```

## 📁 仓库结构

```
.
├── scripts/
│   ├── install-openclaw.sh       # Linux/Mac 安装脚本 ⭐
│   └── install-openclaw.ps1      # Windows 安装脚本
├── configs/
│   ├── models-all-free.json      # 全免费模型配置
│   ├── models-github.json        # GitHub Models 配置
│   ├── models-siliconflow.json   # 硅基流动配置
│   ├── models-coze.json          # Coze 配置
│   └── models-unicom.json        # 联通云配置
└── docs/
    ├── FREE_MODELS.md            # 免费模型申请指南
    └── TROUBLESHOOTING.md        # 常见问题
```

## 🎁 免费模型申请指南

### GitHub Models（推荐新手）

1. 访问 https://github.com/settings/tokens
2. 点击 **Generate new token (classic)**
3. 勾选 `read:packages` 权限
4. 复制 token，填入配置文件

### 硅基流动（推荐国内用户）

1. 访问 https://siliconflow.cn
2. 手机号注册，立即获得 14元体验金
3. 进入控制台获取 API Key
4. 每日还有免费额度！

### Coze

1. 访问 https://www.coze.cn
2. 用抖音/飞书账号登录
3. 创建 Bot，获取 API Key

### 联通云

1. 访问 https://www.cucloud.cn
2. 注册并完成实名认证
3. 申请 AI 大模型服务

## 🔧 手动配置

如果你想手动配置，复制对应的配置文件：

```bash
# 使用 GitHub Models
curl -o ~/.openclaw/agents/main/agent/models.json \
  https://raw.githubusercontent.com/narutozhu442/openclaw-installer/main/configs/models-github.json

# 使用硅基流动
curl -o ~/.openclaw/agents/main/agent/models.json \
  https://raw.githubusercontent.com/narutozhu442/openclaw-installer/main/configs/models-siliconflow.json
```

然后编辑文件填入你的 API Key。

## 🐛 故障排除

```bash
# 检查安装
openclaw doctor

# 查看版本
openclaw --version

# 查看帮助
openclaw --help
```

**常见问题：**

- **Node.js 版本过低** - 脚本会自动安装，如失败请手动安装 Node 22+
- **命令找不到** - 重新打开终端或运行 `source ~/.bashrc`
- **模型返回错误** - 检查 API Key 是否正确，额度是否充足

## 📖 相关链接

- [OpenClaw 官方文档](https://docs.openclaw.ai)
- [OpenClaw GitHub](https://github.com/openclaw/openclaw)
- [硅基流动](https://siliconflow.cn)
- [Coze](https://www.coze.cn)

## 🤝 贡献

欢迎提交 Issue 和 PR！

## 📜 License

MIT License - 自由使用和分发

---

⭐ 如果本项目帮到你，请点个 Star！
